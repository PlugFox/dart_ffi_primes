# set(CMAKE_C_COMPILER "gcc-14")
# set(CMAKE_CXX_COMPILER "/usr/bin/g++-4.2")

cmake_minimum_required(VERSION 3.15 FATAL_ERROR)
project(cprime_library VERSION 1.0.0 LANGUAGES C)

# Set the C standard and enable strict mode
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Specify the build type and optimizations
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Common compilation options
#if (WIN32)
#    if (MSVC)
#        message(STATUS "Platform: Windows (MSVC)")
#        # Optimization flags for MSVC
#        set(CMAKE_C_FLAGS "/O2 /fp:fast /favor:INTEL64")
#        set(CMAKE_C_FLAGS_DEBUG "/Z7")
#        set(CMAKE_C_FLAGS_RELEASE "/O2 /fp:fast /favor:INTEL64 /DNDEBUG")
#    else()
#        message(STATUS "Platform: Windows (MinGW / Clang)")
#        # Optimization flags for GCC/Clang on Windows
#        set(CMAKE_C_FLAGS "-O3 -mcpu=native -mtune=native -ffast-math -funroll-loops -ftree-vectorize -fomit-frame-pointer")
#        set(CMAKE_C_FLAGS_DEBUG "-g")
#        set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -mtune=native -DNDEBUG")
#    endif()
#elseif(APPLE)
#    message(STATUS "Platform: macOS")
#    set(CMAKE_C_FLAGS "-O3 -mcpu=native -mtune=native -ffast-math -funroll-loops -ftree-vectorize -fomit-frame-pointer")
#    set(CMAKE_C_FLAGS_DEBUG "-g")
#    set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG")
#else()
#    message(STATUS "Platform: Linux")
#    set(CMAKE_C_FLAGS "-O3 -mcpu=native -mtune=native -ffast-math -funroll-loops -ftree-vectorize -fomit-frame-pointer")
#    set(CMAKE_C_FLAGS_DEBUG "-g")
#    set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -mtune=native -DNDEBUG")
#endif()

add_library(cprime_library SHARED prime.c)

# Performance optimizations
if (MSVC)
    # Optimizations for Visual Studio (MSVC)
    target_compile_options(cprime_library PRIVATE
        /O2           # Equivalent to -O2/-O3 for MSVC
        /fp:fast      # Equivalent to -ffast-math
        /favor:INTEL64
    )
else()
    # Optimizations for GCC/Clang
    target_compile_options(cprime_library PRIVATE
        -O3
        -ffast-math
        -funroll-loops
        -ftree-vectorize
        -fomit-frame-pointer
    )
endif()

# Configure properties for the library
set_target_properties(cprime_library PROPERTIES
    PUBLIC_HEADER prime.h                     # Public header
    VERSION ${PROJECT_VERSION}                # Library version
    SOVERSION 1                               # ABI compatibility version
    OUTPUT_NAME "cprime"                      # Output filename
)

# Define different suffixes for libraries on different platforms
if (WIN32)
    set_target_properties(cprime_library PROPERTIES SUFFIX ".dll")
elseif(APPLE)
    set_target_properties(cprime_library PROPERTIES SUFFIX ".dylib")
else()
    set_target_properties(cprime_library PROPERTIES SUFFIX ".so")
endif()

# Specify where the library will be installed
#install(TARGETS cprime_library DESTINATION lib)
install(TARGETS cprime_library
    LIBRARY DESTINATION lib
    PUBLIC_HEADER DESTINATION include
)

# Uncomment if you want to install to platform-specific folders
# if (WIN32)
#     install(TARGETS cprime_library DESTINATION ../assets/lib/windows)
# elseif(APPLE)
#     install(TARGETS cprime_library DESTINATION ../assets/lib/macos)
# else()
#     install(TARGETS cprime_library DESTINATION ../assets/lib/linux)
# endif()

# Optionally, create an executable for testing
# add_executable(prime_test main.c)
# target_link_libraries(prime_test PRIVATE cprime_library)

# Optionally, install header files
# install(FILES prime.h DESTINATION include)
