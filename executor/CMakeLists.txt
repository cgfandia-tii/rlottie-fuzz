cmake_minimum_required(VERSION 3.5.1)

project("rlottie_executor")
add_executable(${PROJECT_NAME} "main.cpp")

target_compile_options(${PROJECT_NAME}
                       PUBLIC
                       -std=c++14)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
                       
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -w")

# Sanitizers
option(ASAN "Enable Address sanitizer" OFF)
if (ASAN)
    set (ASAN_FLAGS "-fsanitize=undefined -fno-omit-frame-pointer -fsanitize=address")
    set (CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${ASAN_FLAGS}")
    set (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${ASAN_FLAGS}")
    set (CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${ASAN_FLAGS}")
    set (CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} ${ASAN_FLAGS}")
endif()

# add librlottie
add_subdirectory(rlottie)
# problem with taint compiling
set_property(DIRECTORY rlottie/example PROPERTY EXCLUDE_FROM_ALL YES)

target_link_libraries(${PROJECT_NAME} rlottie)

target_include_directories(${PROJECT_NAME}
                           PRIVATE
                           ${PROJECT_SOURCE_DIR}/rlottie/inc)
