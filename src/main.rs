mod batsim;
mod fcfs;

#[macro_use]
extern crate serde_derive;
#[macro_use]
extern crate serde_json;

fn main() {
    let mut scheduler = fcfs::FCFS::new();
    let mut batsim = batsim::Batsim::new(&mut scheduler);
    batsim.run_simulation().unwrap();
}
