extern crate serde_json;
extern crate zmq;

use self::serde_json::Error;
use std::fmt;

/// Base trait to implement scheduler for batsim.
pub trait Scheduler {
    /// When the simulation in started, batsim will call `simulation_begins` to give to the
    /// scheduler information on the simulations such as the number of resourcs available a
    /// configuration (optional) and the original timestamp.
    fn simulation_begins(&mut self, timestamp: f64, nb_resources: i32, config: serde_json::Value);

    /// When batsim receive a job from the submiter it will inform the scheduler.
    /// This function can return an array of Batsim event to send back to batsim.
    fn on_job_submission(&mut self, timestamp: f64, job: Job) -> Option<Vec<BatsimEvent>>;

    /// When a job is finished batsim will inform the scheduler with this function.
    ///
    /// * `self` Take a reference mutable on the scheduler so we can update it.
    /// * `timestamp` The current timestamp of the simulation.
    /// * `job_id` The string id of the terminated job.
    /// * `status` The return status of the job.
    fn on_job_completed(&mut self, timestamp: f64, job_id: String, status: String) -> Option<Vec<BatsimEvent>>;

    /// This function is call a the end of the simulation.
    fn on_simulation_ends(&mut self, timestamp: f64);
}

pub struct Batsim<'a> {
    zmq_context: zmq::Context,
    zmq_socket: zmq::Socket,
    time: f64,
    nb_resources: i32,
    scheduler: &'a mut Scheduler,
}

#[derive(Serialize, Deserialize)]
pub struct Job {
    pub id: String,
    pub res: i32,
    profile: String,
    subtime: f64,
    walltime: i32
}

impl Clone for Job {
    fn clone(&self) -> Job {
        Job{
            id: self.id.clone(),
            res: self.res,
            profile: self.profile.clone(),
            subtime: self.subtime,
            walltime: self.walltime
        }
    }
}

impl fmt::Display for Job {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "(id: {}\t,res: {},\t subtime: {},\t walltime: {})", self.id, self.res, self.subtime, self.walltime)
    }
}

#[derive(Serialize, Deserialize)]
pub struct Profile {
    #[serde(rename = "type")]
    profile_type: String,
    delay: i32
}

#[derive(Serialize, Deserialize)]
pub struct BatsimMessage {
    now: f64,
    pub events: Vec<BatsimEvent>
}

#[derive(Serialize, Deserialize)]
pub struct JobSubmitted{
        job_id: String,
        job: Job
}

#[derive(Serialize, Deserialize)]
pub struct ExecuteJob {
        pub job_id: String,
        pub alloc: String
}

#[derive(Serialize, Deserialize)]
pub struct JobCompleted {
        pub job_id: String,
        pub status: String
}

#[derive(Serialize, Deserialize)]
pub struct SimulationBegins {
    config: serde_json::Value,
    nb_resources: i32
}

#[allow(non_camel_case_types)]
#[derive(Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum BatsimEvent {
    SIMULATION_BEGINS {
        timestamp: f64,
        data: SimulationBegins
    },
    JOB_SUBMITTED {
        timestamp: f64,
        data: JobSubmitted
    },
    SIMULATION_ENDS {
        timestamp: f64,
    },
    JOB_COMPLETED {
        timestamp: f64,
        data: JobCompleted
    },
    EXECUTE_JOB {
        timestamp: f64,
        data: ExecuteJob
    }
}

impl<'a> Batsim<'a> {

    /// Constructs a new `Batsim`.
    pub fn new(scheduler: &'a mut Scheduler) -> Batsim<'a> {
        let socket_url = "tcp://*:28000";

        let context = zmq::Context::new();
        let socket  = context.socket(zmq::REP).unwrap();
        assert!(socket.bind(socket_url).is_ok());

        Batsim {
            scheduler: scheduler,
            zmq_context: context,
            zmq_socket: socket,
            time: -1.0,
            nb_resources: -1
        }
    }

    pub fn init(&mut self) -> Result<(), Error> {
        let init_message: BatsimMessage = self.get_next_message().unwrap();
        let init_event: &BatsimEvent = &init_message.events[0];

        match *init_event {
            BatsimEvent::SIMULATION_BEGINS{ref data, ref timestamp} => {
                self.time = *timestamp;
                self.nb_resources = data.nb_resources;
                self.scheduler.simulation_begins(*timestamp, data.nb_resources, data.config.clone());
            }
            _ => panic!("We should receive a SIMULATION BEGIN at this point")
        };

        try!(self.send_message(self.get_nop().unwrap()));
        Ok(())
    }

    pub fn get_next_message(&self) -> Option<BatsimMessage> {
        let msg = self.pull_network_message().unwrap();

        //Batsim will send us the init message with
        //the data we need to initialize the scheduler.
        Some(read_batsim_message(&msg).unwrap())
    }

    pub fn pull_network_message(&self) -> Result<String, Error> {
        let msg = match self.zmq_socket.recv_msg(0) {
            Ok(msg) => msg,
            Err(why) => panic!("{:?}", why)
        };
        Ok(String::from(msg.as_str().unwrap()))
    }

    pub fn get_nop(&self) -> Result<BatsimMessage, Error> {
        Ok(BatsimMessage{now: self.time, events: Vec::new()})
    }

    pub fn send_message(&self, message: BatsimMessage) -> Result<(), Error> {
        let message_json = serde_json::to_string(&message).unwrap();
        self.zmq_socket.send_str(message_json.as_str(), 0).unwrap();
        Ok(())
    }

    pub fn run_simulation(&mut self) -> Result<(), Error> {
        match self.init() {
            Ok(()) => {},
            _ => panic!("Could not initialize the simulation, aborting.")
        };

        let mut next: Option<BatsimMessage> = self.get_next_message();

        'main: while let Some(msg) = next {
            self.time = msg.now;
            let mut res = self.get_nop().unwrap();
            for event in msg.events {
                match event {
                    BatsimEvent::SIMULATION_BEGINS{..} => {
                        panic!("Received simulation_begins, this should not happends at this point");
                    },
                    //TODO It appears that the timestamp is the same as the one provided at the root
                    //message.
                    BatsimEvent::JOB_SUBMITTED{ref data, ..} => {
                        let job = data.job.clone();

                        match self.scheduler.on_job_submission(self.time, job) {
                            Some(mut events) =>  res.events.append(&mut events),
                            None => {}
                        };
                    },
                    //
                    BatsimEvent::SIMULATION_ENDS{ref timestamp} => {
                        self.scheduler.on_simulation_ends(*timestamp);
                        next = None;
                        try!(self.send_message(res));
                        continue 'main;
                    },
                    BatsimEvent::JOB_COMPLETED{ref data, ref timestamp} => {
                       match self.scheduler.on_job_completed(*timestamp, data.job_id.clone(), data.status.clone()) {
                            Some(mut events) =>  res.events.append(&mut events),
                            None => println!("No events")
                        };
                    },
                    _ => panic!("Unexpected event")
                }
            }
            try!(self.send_message(res));
            next = self.get_next_message();
        }
        Ok(())
    }


}

pub fn allocate_job_event(time: f64, job: &Job, allocation : String) ->  BatsimEvent {
    BatsimEvent::EXECUTE_JOB{
        timestamp: time,
        data: ExecuteJob{
            job_id: job.id.clone(),
            alloc: allocation
        }
    }
}

///Convert a json fromated string into a typed rust struct `BatsimMessage`.
pub fn read_batsim_message(msg_str: &str) -> Result<BatsimMessage, Error>  {
    let message: BatsimMessage = match serde_json::from_str(msg_str) {
        Ok(value) => value,
        Err(why)  => panic!("{:?} full str: {}", why, msg_str)
    };

    Ok(message)
}
