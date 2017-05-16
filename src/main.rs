mod batsim;
mod FCFS;

#[macro_use]
extern crate serde_derive;
#[macro_use]
extern crate serde_json;
use std::collections::LinkedList;

fn main() {
    let mut scheduler = FCFS::FCFS{
        nb_resources: -1,
        running_job: None,
        job_queue: LinkedList::new()
    };
    let mut batsim = batsim::Batsim::new(&mut scheduler);
    batsim.run_simulation();
}
