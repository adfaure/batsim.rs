extern crate serde_json;
extern crate serde_derive;

extern crate zmq;
use self::serde_json::Error;

pub struct Batsim {
    zmq_context: zmq::Context,
    zmq_socket: zmq::Socket,
    time: f64,
    nb_resources: i32
}

#[derive(Serialize, Deserialize)]
pub struct BatsimMessage {
    now: f64,
    events: Vec<BatsimEvent>
}


#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum BatsimEventData {
    SIMULATION_BEGINS {
        config: serde_json::Value,
        nb_resources: i32
    }
}

#[derive(Serialize, Deserialize)]
pub struct BatsimEvent {
    timestamp: f64,
    data: BatsimEventData
}

impl Batsim {

    /// Constructs a new `Batsim`.
    pub fn new() -> Batsim {
        let socket_url = "tcp://*:28000";

        let context = zmq::Context::new();
        let socket  = context.socket(zmq::REP).unwrap();
        assert!(socket.bind(socket_url).is_ok());

        Batsim {
            zmq_context: context,
            zmq_socket: socket,
            time: -1.0,
            nb_resources: -1
        }
    }

    pub fn init(&mut self) -> Result<(), Error> {
        let mut msg = match zmq::Message::new() {
            Ok(msg) => msg,
            Err(why) => panic!("{:?}", why)
        };

        match self.zmq_socket.recv(&mut msg, 0) {
            Ok(()) => println!("ok"),
            Err(why) => panic!("{:?}", why)
        };

        let json_raw = match msg.as_str() {
            Some(raw_data) => raw_data,
            None           => panic!("Error while initializing batsim")
        };

        //Batsim will send us the init message with
        //the data we need to initialize the scheduler.
        let initMessage: BatsimMessage = read_batsim_message(json_raw).unwrap();
        let init_event: &BatsimEvent = &initMessage.events[0];

        self.nb_resources = match init_event.data {
            BatsimEventData::SIMULATION_BEGINS{ref config, ref nb_resources} => *nb_resources
        };

        println!("Batsim initialized with {} resources", self.nb_resources);
        Ok(())
    }
}

pub fn read_batsim_message(msg_str: &str) -> Result<BatsimMessage, Error>  {
    let message: BatsimMessage = match serde_json::from_str(msg_str) {
        Ok(value) => value,
        Err(why)  => panic!("{:?}", why)
    };


    Ok(message)
}


