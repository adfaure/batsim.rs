mod batsim;

#[macro_use]
extern crate serde_derive;
#[macro_use]
extern crate serde_json;

fn main() {
    let mut batsim = batsim::Batsim::new();
    batsim.init();
}
