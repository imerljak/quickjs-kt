if(CMAKE_GENERATOR MATCHES "Visual Studio")
    message(FATAL_ERROR "Visual Studio generator not supported, use: cmake -G Ninja")
endif()

set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR "x86_64")

# Find iOS Simulator SDK path
execute_process(
    COMMAND xcrun --sdk iphonesimulator --show-sdk-path
    OUTPUT_VARIABLE IOS_SDK_PATH
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
)

if(IOS_SDK_PATH)
    set(CMAKE_C_COMPILER "zig" cc -target x86_64-ios --sysroot=${IOS_SDK_PATH})
    set(CMAKE_CXX_COMPILER "zig" c++ -target x86_64-ios --sysroot=${IOS_SDK_PATH})
    message(STATUS "Using iOS Simulator SDK: ${IOS_SDK_PATH}")
else()
    set(CMAKE_C_COMPILER "zig" cc -target x86_64-ios)
    set(CMAKE_CXX_COMPILER "zig" c++ -target x86_64-ios)
    message(WARNING "iOS Simulator SDK not found, building without sysroot")
endif()

# Skip compiler checks for cross-compilation
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

if(WIN32)
    set(SCRIPT_SUFFIX ".cmd")
else()
    set(SCRIPT_SUFFIX ".sh")
endif()

set(CMAKE_AR "${CMAKE_CURRENT_LIST_DIR}/zig-ar${SCRIPT_SUFFIX}")
set(CMAKE_RANLIB "${CMAKE_CURRENT_LIST_DIR}/zig-ranlib${SCRIPT_SUFFIX}")