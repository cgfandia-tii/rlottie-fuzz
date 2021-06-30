# rlottie-fuzz
Fuzzer for the rlottie library fork of Telegram messenger. Aimed at finding bugs in parsing and rendering of lottie stickers.

## Usage
Fuzzing and triage are performing in `rlottie-fuzz` docker container which is built with a simple `build.sh` script. Initial input corpus can be gathered [here](executor/rlottie/example/resource).

### Fuzzing
Initial fuzzing
```bash
$ docker run -it -v /host_in:/container_in -v /host_out:/container_out -e INPUT=/container_in -e OUTPUT=/container_out -e JOB=8 rlottie-fuzz
```
Continue fuzzing
```bash
$ docker run -it -v /host_out:/container_out -e INPUT=- -e OUTPUT=/container_out -e JOB=8 rlottie-fuzz
```

### Triage
`triage` python script depends on ASAN or/and Release(Valgrind) binaries of the target and crash inputs. It passes crash inputs to ASAN/Valgrind target and gather these useful outputs to find unique.
```
usage: triage [-h] [--input INPUT] [--output OUTPUT] [--asan ASAN] [--valgrind VALGRIND]

Triage of the Angora crashes

optional arguments:
  -h, --help            show this help message and exit
  --input INPUT, -i INPUT
                        Folder with crash inputs
  --output OUTPUT, -o OUTPUT
                        Folder with triage crashes
  --asan ASAN, -a ASAN  Path to ASAN binary
  --valgrind VALGRIND, -v VALGRIND
                        Path to Valgrind binary
```
```bash
$ docker run -it -v /host_out:/container_out rlottie-fuzz ./triage -i /container_out/crashes -o /container_out/triage -a /fuzzer/executor/build/asan/rlottie_executor -v /fuzzer/executor/build/valgrind/rlottie_executor
```