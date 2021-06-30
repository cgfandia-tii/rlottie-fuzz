ANGORA_CC = /angora/bin/angora-clang
ANGORA_CXX = /angora/bin/angora-clang++

TRIAGE_CMAKE_FLAGS = -DLOTTIE_MODULE=OFF -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DBUILD_SHARED_LIBS=OFF
ANGORA_CMAKE_FLAGS = -DLOTTIE_MODULE=OFF -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=$(ANGORA_CC) -DCMAKE_CXX_COMPILER=$(ANGORA_CXX) -DBUILD_SHARED_LIBS=OFF
BUILD_DIR = executor/build

all: fuzzer triage

fuzzer: taint fast

taint: export CC = $(ANGORA_CC)
taint: export CXX = $(ANGORA_CXX)
taint: export LD = $(ANGORA_CC)
taint: export USE_TRACK = 1
taint: export ANGORA_CUSTOM_FN_CONTEXT = 4
taint:
	mkdir -p $(BUILD_DIR)/taint
	cd $(BUILD_DIR)/taint && cmake $(ANGORA_CMAKE_FLAGS) ../.. && make

fast: export CC = $(ANGORA_CC)
fast: export CXX = $(ANGORA_CXX)
fast: export LD = $(ANGORA_CC)
fast: export USE_FAST = 1
fast: export ANGORA_CUSTOM_FN_CONTEXT = 4
fast:
	mkdir -p $(BUILD_DIR)/fast
	cd $(BUILD_DIR)/fast && cmake $(ANGORA_CMAKE_FLAGS) ../.. && make

valgrind:
	mkdir -p $(BUILD_DIR)/valgrind
	cd $(BUILD_DIR)/valgrind && cmake $(TRIAGE_CMAKE_FLAGS) ../.. && make

asan:
	mkdir -p $(BUILD_DIR)/asan
	cd $(BUILD_DIR)/asan && cmake $(TRIAGE_CMAKE_FLAGS) -DASAN=ON ../.. && make

triage: valgrind asan
