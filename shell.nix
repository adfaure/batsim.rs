{
  kapack ? import
    (builtins.fetchTarball {
      url = "https://github.com/oar-team/kapack/archive/master.tar.gz";
    }) {}
}:
kapack.pkgs.mkShell {
  buildInputs = with kapack; with pkgs; [
    pkgconfig
    zeromq
    cargo
    rustc
    batsim
  ];
}
