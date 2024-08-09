{
  description = "tgi development";

  inputs = {
    nixpkgs.url = "github:danieldk/nixpkgs/cudnn-9.3";
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs =
    { self, flake-compat, nixpkgs }:
    with import nixpkgs;
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      config = {
        allowUnfree = true;
        cudaSupport = true;
      };
    in
    rec {
      overlay = import ./overlay.nix;
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit config system;
            overlays = [ overlay ];
          };
          lib = pkgs.lib;
        in
        rec {
          all = pkgs.symlinkJoin {
            name = "all";
            paths = lib.attrsets.attrValues python3Packages;
          };
          python3Packages = with pkgs.python3.pkgs; {
            inherit

              fbgemm-gpu
              flash-attn
              flash-attn-layer-norm
              flash-attn-rotary
              flashinfer
              hf-transfer
              marlin-kernels
              opentelemetry-instrumentation-grpc
              torch
              vllm
              ;
          };
        }
      );
    };
}
