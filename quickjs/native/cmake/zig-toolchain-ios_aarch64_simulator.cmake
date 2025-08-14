if(CMAKE_GENERATOR MATCHES "Visual Studio")
    message(FATAL_ERROR "Visual Studio generator not supported, use: cmake -G Ninja")
endif()

set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR "aarch64")
set(IOS_TARGET "aarch64-ios-simulator")

# Find iOS SDK path
execute_process(
    COMMAND xcrun --sdk iphoneos --show-sdk-path
    OUTPUT_VARIABLE IOS_SDK_PATH
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
)

# Find zig executable
find_program(ZIG_EXECUTABLE zig REQUIRED)

if(IOS_SDK_PATH)
    # Fixed: Use list format for compiler arguments
    set(CMAKE_C_COMPILER ${ZIG_EXECUTABLE})
    set(CMAKE_CXX_COMPILER ${ZIG_EXECUTABLE})

    # Set compiler arguments properly
    set(CMAKE_C_COMPILER_ARG1 "cc")
    set(CMAKE_CXX_COMPILER_ARG1 "c++")

    # Set target and sysroot flags
    set(CMAKE_C_FLAGS_INIT "-target ${IOS_TARGET} --sysroot=${IOS_SDK_PATH} -isystem${IOS_SDK_PATH}/usr/include")
    set(CMAKE_CXX_FLAGS_INIT "-target ${IOS_TARGET} --sysroot=${IOS_SDK_PATH} -isystem${IOS_SDK_PATH}/usr/include")

    message(STATUS "Using iOS SDK: ${IOS_SDK_PATH}")
else()
    set(CMAKE_C_COMPILER ${ZIG_EXECUTABLE})
    set(CMAKE_CXX_COMPILER ${ZIG_EXECUTABLE})
    set(CMAKE_C_COMPILER_ARG1 "cc")
    set(CMAKE_CXX_COMPILER_ARG1 "c++")
    set(CMAKE_C_FLAGS_INIT "-target ${IOS_TARGET}")
    set(CMAKE_CXX_FLAGS_INIT "-target ${IOS_TARGET}")
    message(WARNING "iOS SDK not found, building without sysroot")
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