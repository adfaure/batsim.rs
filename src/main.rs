mod batsim;

#[macro_use]
extern crate serde_derive;
#[macro_use]
extern crate serde_json;

use batsim::*;

fn main() {
    let mut batsim = batsim::Batsim::new();
    batsim.run_simulation();
}
