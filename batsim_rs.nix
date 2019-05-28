
# To build this file
# nix-build -E 'with import <nixpkgs> {}; callPackage ./batsim_rs.nix {}'
{ pkgs }:
rec {

   cratesIO = pkgs.callPackage ./crates-io.nix {};
   crates = pkgs.callPackage ./Cargo.nix { inherit cratesIO; };

   batsim_rs = (crates.batsim_rs {}).override {
     crateOverrides = (pkgs.defaultCrateOverrides // {

        zmq-sys =  _: {
          buildInputs = [ pkgs.pkgconfig pkgs.zeromq ];
        };

        zmq =  _: {
          buildInputs = [ pkgs.pkgconfig pkgs.zeromq ];
        };

     });

   };

}
