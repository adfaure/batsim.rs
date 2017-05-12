extern crate serde_json;
extern crate serde_derive;
extern crate zmq;

use self::serde_json::Error;

trait Scheduler {
    fn onJobSubmission(self, job: Job) -> Result<(), Error>;
}

struct DummyScheduler;

impl Scheduler for DummyScheduler {
    fn onJobSubmission(self, job: Job) -> Result<(), Error> {
        panic!("onJobSubmission is not implemented");
        Ok(())
    }
}

pub struct Batsim {
    zmq_context: zmq::Context,
    zmq_socket: zmq::Socket,
    time: f64,
    nb_resources: i32,
    scheduler: DummyScheduler
}

#[derive(Serialize, Deserialize)]
pub struct Job {
    id: String,
    res: i32,
    profile: String,
    subtime: i32,
    walltime: i32}

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
pub struct job_submitted {
        job_id: String,
        job: Job
}

#[derive(Serialize, Deserialize)]
pub struct simulation_begins {
    config: serde_json::Value,
    nb_resources: i32
}

#[derive(Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum BatsimEvent {
    SIMULATION_BEGINS {
        timestamp: f64,
        data: simulation_begins
    },
    JOB_SUBMITTED {
        timestamp: f64,
        data: job_submitted
    }
}

impl Batsim {

    /// Constructs a new `Batsim`.
    pub fn new() -> Batsim {
        let socket_url = "tcp://*:28000";

        let context = zmq::Context::new();
        let socket  = context.socket(zmq::REP).unwrap();
        assert!(socket.bind(socket_url).is_ok());

        Batsim {
            scheduler: DummyScheduler{},
            zmq_context: context,
            zmq_socket: socket,
            time: -1.0,
            nb_resources: -1
        }
    }

    pub fn init(&mut self) -> Result<(), Error> {
        let initMessage: BatsimMessage = self.get_next_message().unwrap();
        let init_event: &BatsimEvent = &initMessage.events[0];

        self.nb_resources = match *init_event {
            BatsimEvent::SIMULATION_BEGINS{ref data, ref timestamp} => data.nb_resources,
            _ => panic!("We should receive a SIMULATION BEGIN at this point")
        };

        println!("Batsim initialized with {} resources", self.nb_resources);
        self.send_message(self.get_nop().unwrap());
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
        self.init();

        //We can create a function to call the scheduler with the conf and notify it that the
        //simulation may begins.

        let mut next: Option<BatsimMessage> = self.get_next_message();
        while let Some(msg) = next {
            self.time = msg.now;
            println!("Message received: {}", self.time);
            for event in msg.events {
                match event {
                    BatsimEvent::SIMULATION_BEGINS{ref data, ref timestamp} => {
                        panic!("Received simulation_begins, this should not happends at this point");
                    },
                    _ => println!("Not yet implemented")
                }
            }
            self.send_message(self.get_nop().unwrap());
            next = self.get_next_message();
        }
        Ok(())
    }

}

///Convert a json fromated string into a typed rust struct `BatsimMessage`.
pub fn read_batsim_message(msg_str: &str) -> Result<BatsimMessage, Error>  {

    println!("Received message: {}", msg_str);
    let message: BatsimMessage = match serde_json::from_str(msg_str) {
        Ok(value) => value,
        Err(why)  => panic!("{:?}", why)
    };

    Ok(message)
}
