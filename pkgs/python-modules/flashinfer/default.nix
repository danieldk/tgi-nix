{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  autoAddDriverRunpath,
  cmake,
  git,
  ninja,
  packaging,
  psutil,
  which,
  cudaPackages,
  torch,
}:

buildPythonPackage rec {
  pname = "flashinfer";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "flashinfer-ai";
    repo = "flashinfer";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-ht234geMnOH0xKjhBOCXrzwYZuBFPvJMCZ9P8Vlpxcs=";
  };

  stdenv = cudaPackages.backendStdenv;

  buildInputs = with cudaPackages; [
    cuda_cccl
    cuda_cudart
    libcublas
    libcusolver
    libcusparse
    psutil
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
    cmake
    git
    ninja
    packaging
    which
  ];

  env = {
    CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
  };

  propagatedBuildInputs = [ torch ];

  # cmake/ninja are used for parallel builds, but we don't want the
  # cmake configure hook to kick in.
  dontUseCmakeConfigure = true;

  # We don't have any tests in this package (yet).
  doCheck = false;

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  pythonImportsCheck = [ "flashinfer" ];

  meta = with lib; {
    description = "Flashinfer";
    license = licenses.asl20;
  };
}
