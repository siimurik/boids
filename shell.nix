{ pkgs ? import <nixpkgs> { } }:
let
  unstable = import
    (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz)
    { };
in
with pkgs; mkShell {
  name = "boids";
  buildInputs = [
    unstable.zig
  ];
}
