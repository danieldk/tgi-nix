self: super: {
  python3 = super.python3.override {
    packageOverrides =
      python-self: python-super: with python-self; {
        fbgemm-gpu = callPackage ./pkgs/python-modules/fbgemm-gpu { };

        flash-attn = callPackage ./pkgs/python-modules/flash-attn { };

        flash-attn-layer-norm = callPackage ./pkgs/python-modules/flash-attn-layer-norm { };

        flash-attn-rotary = callPackage ./pkgs/python-modules/flash-attn-rotary { };

        flashinfer = callPackage ./pkgs/python-modules/flashinfer { };

        hf-transfer = callPackage ./pkgs/python-modules/hf-transfer { };

        marlin-kernels = callPackage ./pkgs/python-modules/marlin-kernels { };

        opentelemetry-instrumentation-grpc = python-super.opentelemetry-instrumentation-grpc.overrideAttrs (
          _: prevAttrs: {
            patches = [
              (super.fetchpatch {
                url = "https://github.com/open-telemetry/opentelemetry-python-contrib/commit/1c8d8ef5368c15d27c0973ce80787fd94c7b3176.diff";
                hash = "sha256-Zc9Q5lCxHP73YErf0TqVAsdmgwibW6LZteycW9zB9a8=";
                stripLen = 2;
                includes = [ "*grpc*" ];
              })
            ];

            meta = prevAttrs.meta // {
              broken = false;
            };
          }
        );

        torch = callPackage ./pkgs/python-modules/torch {
          inherit (super.darwin.apple_sdk.frameworks) Accelerate CoreServices;
          inherit (super.darwin) libobjc;
        };

        vllm = callPackage ./pkgs/python-modules/vllm { };
      };
  };
}
