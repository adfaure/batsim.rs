extern crate serde_json;

use std::rc::Rc;
use self::serde_json::{Value, Error};
use batsim::*;
use std::fmt::Write as FmtWrite;
use std::collections::LinkedList;

pub struct FCFS {
    pub nb_resources: i32,
    pub running_job: Option<Rc<Job>>,
    pub job_queue: LinkedList<Rc<Job>>
}


impl FCFS {

    fn schedule_job(&mut self, timestamp: f64) -> Option<Vec<BatsimEvent>> {
        let mut res: Vec<BatsimEvent> = Vec::new();
        match self.running_job {
            Some(_) => {
              return None
            },
            None => {
                match self.job_queue.pop_front() {
                    Some(job) => {
                            let mut alloc = String::new();
                            write!(&mut alloc, "0-{}", job.res - 1).unwrap();
                            res.push( BatsimEvent::EXECUTE_JOB{
                            timestamp: timestamp,
                            data: ExecuteJob{
                                job_id: job.id.clone(),
                                alloc: alloc
                            }
                            });
                            self.running_job = Some(job.clone());
                    }
                    None => {return None},
                }
            }
        };
        Some(res)
    }

}

impl Scheduler for FCFS {
    fn simulation_begins(&mut self, timestamp: f64, nb_resources: i32, config: serde_json::Value) {
        println!("FCFS Scheduler initialized: nb resources is {}", nb_resources);
        self.nb_resources = nb_resources;
    }
    fn on_job_submission(&mut self, timestamp: f64, job: Rc<Job>) -> Option<Vec<BatsimEvent>> {
        self.job_queue.push_back(job.clone());
        self.schedule_job(timestamp)
    }
    fn on_job_completed(&mut self, timestamp: f64, job_id: String, status: String) -> Option<Vec<BatsimEvent>> {
        println!("Job terminated: {} with Status: {}", job_id, status);
        self.running_job = None;
        self.schedule_job(timestamp)
    }
    fn on_simulation_ends(&mut self, timestamp: f64) {
        println!("Simulation ends: {}", timestamp);
    }
}
