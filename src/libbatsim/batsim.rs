extern crate serde_json;
extern crate zmq;

use self::serde_json::Error;
use std::fmt;
use std::str::FromStr;

/// Base trait to implement scheduler for batsim.
pub trait Scheduler {
    /// When the simulation in started, batsim will call `simulation_begins` to give to the
    /// scheduler information on the simulations such as the number of resourcs available a
    /// configuration (optional) and the original timestamp.
    #[warn(unused_variables)]
    fn simulation_begins(&mut self,
                         timestamp: &mut f64,
                         nb_resources: i32,
                         config: serde_json::Value) -> Option<Vec<BatsimEvent>>;

    /// When batsim receive a job from the submiter it will inform the scheduler.
    /// This function can return an array of Batsim event to send back to batsim.
    #[warn(unused_variables)]
    fn on_job_submission(&mut self, timestamp: &mut f64, job: Job, profile: Option<Profile>) -> Option<Vec<BatsimEvent>>;

    /// When a job is finished batsim will inform the scheduler with this function.
    ///
    /// * `self` Take a reference mutable on the scheduler so we can update it.
    /// * `timestamp` The current timestamp of the simulation.
    /// * `job_id` The string id of the terminated job.
    /// * `status` The return status of the job.
    #[warn(unused_variables)]
    fn on_job_completed(&mut self,
                        timestamp: &mut f64,
                        job_id: String,
                        status: String)
                        -> Option<Vec<BatsimEvent>>;

    /// When the scheduler kill on or several jobs batsim acknoiwledge by sending back the id of
    /// the killed job.
    #[warn(unused_variables)]
    fn on_job_killed(&mut self,
                     timestamp: &mut f64,
                     job_ids: Vec<String>)
                     -> Option<Vec<BatsimEvent>>;

    /// The function is called at the reception of a message
    /// Before loop trhough each event and call `on_*` functions.
    #[warn(unused_variables)]
    fn on_message_received_end(&mut self, timestamp: &mut f64) -> Option<Vec<BatsimEvent>>;

    /// The function is called just before sending back events to batsim.
    #[warn(unused_variables)]
    fn on_message_received_begin(&mut self, timestamp: &mut f64) -> Option<Vec<BatsimEvent>>;

    /// This function is call a the end of the simulation.
    #[warn(unused_variables)]
    fn on_simulation_ends(&mut self, timestamp: &mut f64);
}

pub struct Batsim<'a> {
    zmq_context: zmq::Context,
    zmq_socket: zmq::Socket,
    time: f64,
    nb_resources: i32,
    scheduler: &'a mut Scheduler,
}


#[derive(Debug, Serialize, Deserialize)]
pub struct Job {
    pub id: String,
    pub res: i32,
    pub profile: String,
    pub subtime: f64,
    pub walltime: f64,
}

impl Job {
    /// Split the job id in two parts `(workload id, job id)` as defined n batsim.
    pub fn split_id(id: &String) -> (String, String) {
        let workload;
        let decimal_id;
        let indx = id.find('!').unwrap();
        {
            let (w_id, job_id) = id.split_at(indx + 1);
            decimal_id = String::from(job_id);
            workload = String::from(w_id);
        }
        (workload, decimal_id)
    }
}

impl Clone for Job {
    fn clone(&self) -> Job {
        Job {
            id: self.id.clone(),
            res: self.res,
            profile: self.profile.clone(),
            subtime: self.subtime,
            walltime: self.walltime,
        }
    }
}

impl fmt::Display for Job {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f,
               "(id: {}\t,res: {},\t subtime: {},\t walltime: {})",
               self.id,
               self.res,
               self.subtime,
               self.walltime)
    }
}


#[derive(Debug, Serialize, Deserialize)]
pub struct Profile {
    #[serde(rename = "type")]
    pub profile_type: String,
    pub delay: f64,
}

impl Clone for Profile {
    fn clone(&self) -> Profile {
        Profile {
            profile_type: self.profile_type.clone(),
            delay: self.delay,
        }
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct BatsimMessage {
    now: f64,
    pub events: Vec<BatsimEvent>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct SubmitJob {
    job_id: String,
    job: Job,
    profile: Option<Profile>
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Notify {
    #[serde(rename = "type")]
    notify_type: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct JobSubmitted {
    job_id: String,
    job: Job,
    profile: Option<Profile>
}

#[derive(Debug, Serialize, Deserialize)]
pub struct RejectJob {
    job_id: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ExecuteJob {
    pub job_id: String,
    pub alloc: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct KillJob {
    pub job_ids: Vec<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct JobKilled {
    pub job_ids: Vec<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct JobCompleted {
    pub job_id: String,
    pub status: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct SimulationBegins {
    config: serde_json::Value,
    nb_resources: i32,
}

#[allow(non_camel_case_types)]
#[derive(Debug, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum BatsimEvent {
    ///From batsim to sched
    SIMULATION_BEGINS {
        timestamp: f64,
        data: SimulationBegins,
    },
    JOB_SUBMITTED { timestamp: f64, data: JobSubmitted },
    SIMULATION_ENDS { timestamp: f64 },
    JOB_COMPLETED { timestamp: f64, data: JobCompleted },
    JOB_KILLED { timestamp: f64, data: JobKilled },

    /// From sched to batsim
    EXECUTE_JOB { timestamp: f64, data: ExecuteJob },
    REJECT_JOB { timestamp: f64, data: RejectJob },
    KILL_JOB { timestamp: f64, data: KillJob },

    /// Dynamic submit feature
    SUBMIT_JOB { timestamp: f64, data: SubmitJob },
    NOTIFY { timestamp: f64, data: Notify },
}

impl<'a> Batsim<'a> {
    /// Constructs a new `Batsim`.
    pub fn new(scheduler: &'a mut Scheduler) -> Batsim<'a> {
        let socket_url = "tcp://*:28000";

        let context = zmq::Context::new();
        let socket = context.socket(zmq::REP).unwrap();
        assert!(socket.bind(socket_url).is_ok());

        Batsim {
            scheduler: scheduler,
            zmq_context: context,
            zmq_socket: socket,
            time: -1.0,
            nb_resources: -1,
        }
    }

    pub fn init(&mut self) -> Result<(), Error> {
        let init_message: BatsimMessage = self.get_next_message().unwrap();
        let init_event: &BatsimEvent = &init_message.events[0];

        let mut res = self.get_nop().unwrap();

        match *init_event {
            BatsimEvent::SIMULATION_BEGINS {
                ref data,
                ref timestamp,
            } => {
                let mut temp_timestamp = *timestamp;
                self.nb_resources = data.nb_resources;
                match self.scheduler.simulation_begins(&mut temp_timestamp, data.nb_resources, data.config.clone()) {
                    Some(mut events) => res.events.append(&mut events),
                    None => {}
                }
                self.time = temp_timestamp;
            }
            _ => panic!("We should receive a SIMULATION BEGIN at this point"),
        };

        res.now = self.time;
        try!(self.send_message(res));
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
            Err(why) => panic!("{:?}", why),
        };
        Ok(String::from(msg.as_str().unwrap()))
    }

    pub fn get_nop(&self) -> Result<BatsimMessage, Error> {
        Ok(BatsimMessage {
               now: self.time,
               events: Vec::new(),
           })
    }

    pub fn send_message(&self, message: BatsimMessage) -> Result<(), Error> {
        let message_json = serde_json::to_string(&message).unwrap();
        self.zmq_socket
            .send_str(message_json.as_str(), 0)
            .unwrap();
        Ok(())
    }

    pub fn run_simulation(&mut self) -> Result<(), Error> {
        match self.init() {
            Ok(()) => {}
            _ => panic!("Could not initialize the simulation, aborting."),
        };

        let mut next: Option<BatsimMessage> = self.get_next_message();

        'main: while let Some(msg) = next {
            self.time = msg.now;
            let mut schedule_timestamp: f64 = msg.now;
            let mut res = self.get_nop().unwrap();

            match self.scheduler
                      .on_message_received_begin(&mut schedule_timestamp) {
                Some(mut events) => res.events.append(&mut events),
                None => {}
            };

            for event in msg.events {
                match event {
                    BatsimEvent::SIMULATION_BEGINS { .. } => {
                        panic!("Received simulation_begins,
                               this should not happends at this point");
                    }
                    //TODO It appears that the timestamp is the same as the one provided at the root
                    //message.
                    BatsimEvent::JOB_SUBMITTED  { ref data, .. } => {
                        match self.scheduler
                                  .on_job_submission(&mut schedule_timestamp,  data.job.clone(), data.profile.clone()) {
                            Some(mut events) => res.events.append(&mut events),
                            None => {}
                        };
                    }
                    //
                    BatsimEvent::SIMULATION_ENDS { ref timestamp } => {
                        self.scheduler
                            .on_simulation_ends(&mut schedule_timestamp);
                        next = None;
                        try!(self.send_message(res));
                        continue 'main;
                    }
                    BatsimEvent::JOB_COMPLETED {
                        ref data,
                        ref timestamp,
                    } => {
                        match self.scheduler
                                  .on_job_completed(&mut schedule_timestamp,
                                                    data.job_id.clone(),
                                                    data.status.clone()) {
                            Some(mut events) => res.events.append(&mut events),
                            None => {}
                        };
                    }
                    BatsimEvent::JOB_KILLED {
                        ref data,
                        ref timestamp,
                    } => {
                        match self.scheduler
                                  .on_job_killed(&mut schedule_timestamp,
                                                 data.job_ids.clone()) {
                            Some(mut events) => res.events.append(&mut events),
                            None => {}
                        };
                    }
                    _ => panic!("Unexpected event"),
                }
            }

            match self.scheduler
                      .on_message_received_end(&mut schedule_timestamp) {
                Some(mut events) => res.events.append(&mut events),
                None => {}
            };

            res.now = schedule_timestamp;
            try!(self.send_message(res));
            next = self.get_next_message();
        }
        Ok(())
    }
}

pub fn allocate_job_event(time: f64, job: &Job, allocation: String) -> BatsimEvent {
    BatsimEvent::EXECUTE_JOB {
        timestamp: time,
        data: ExecuteJob {
            job_id: job.id.clone(),
            alloc: allocation,
        },
    }
}

pub fn reject_job_event(time: f64, job: &Job) -> BatsimEvent {
    BatsimEvent::REJECT_JOB {
        timestamp: time,
        data: RejectJob { job_id: job.id.clone() },
    }
}

pub fn notify_event(time: f64, n_type: String) -> BatsimEvent {
    BatsimEvent::NOTIFY {
        timestamp: time,
        data: Notify { notify_type: n_type.clone() },
    }
}

pub fn submit_job_event(time: f64, job: &Job, profile: Option<&Profile>) -> BatsimEvent {
    let p = match profile {
        Some(prof) => Some(prof.clone()),
        None => None
    };
    BatsimEvent::SUBMIT_JOB {
        timestamp: time,
        data: SubmitJob {
            job_id: job.id.clone(),
            job: job.clone(),
            profile: p
        },
    }
}


pub fn kill_jobs_event(time: f64, jobs: Vec<&Job>) -> BatsimEvent {
    let mut job_ids = vec![];
    for job in jobs {
        job_ids.push(job.id.clone());
    }
    BatsimEvent::KILL_JOB {
        timestamp: time,
        data: KillJob { job_ids: job_ids },
    }
}


///Convert a json fromated string into a typed rust struct `BatsimMessage`.
pub fn read_batsim_message(msg_str: &str) -> Result<BatsimMessage, Error> {
    let message: BatsimMessage = match serde_json::from_str(msg_str) {
        Ok(value) => value,
        Err(why) => panic!("{:?} full str: {}", why, msg_str),
    };

    Ok(message)
}
