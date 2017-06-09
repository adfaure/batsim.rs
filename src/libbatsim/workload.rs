extern crate serde_json;
extern crate zmq;

use json_protocol::*;

use std::collections::LinkedList;
use std::collections::HashMap;

pub struct Workload {
    job_list: Vec<Job>,
    profiles: HashMap<String, Profile>,

    nb_res: u32,
    description: Option<String>
}

#[test]
pub fn open_workload() {
    assert!(false);
}
