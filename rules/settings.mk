# settings.mk - configuration file for V2X framework

# Build packages
BUILD_LISTS  :=     \
    zlib            \
    gmp             \
    mpfr            \
    mpc             \
    isl             \
    binutils        \
    gdb             \

BUILD_LISTS_GCC :=  \
    gcc

BUILD_LISTS_LIBC := \
    newlib

BUILD_UTILS :=      \
    xmlada          \
    gprconfig_kb    \
    gprbuild

# Packages
PKGS := $(BUILD_LISTS) $(BUILD_LISTS_GCC) $(BUILD_LISTS_LIBC) $(BUILD_UTILS)

###############################################################################
# Build system configurations
#
# The BUILD_HOST specifies build environment. The default build system is linux
###############################################################################
BUILD_HOST          ?= osx
BUILD_OS            := $(shell uname)
BUILD_PROCESSOR     := $(shell uname -p)

ifeq ($(BUILD_OS),Darwin)
BUILD_HOST          = osx
endif

# build host specific tools.
# If you want to change versions of toolchain and utility, modify following BUILD_HOST_XXX variables:

ifeq ($(BUILD_HOST),osx)
BUILD_HOST_CC     := x86_64-apple-darwin15-gcc
BUILD_HOST_CXX    := x86_64-apple-darwin15-g++
BUILD_HOST_CPP    := cpp
BUILD_HOST_AR     := x86_64-apple-darwin15-gcc-ar
BUILD_HOST_NM     := x86_64-apple-darwin15-gcc-nm
BUILD_HOST_RANLIB := x86_64-apple-darwin15-gcc-ranlib
endif

ifneq (,$(findstring linux64, $(BUILD_HOST)))
BUILD_HOST_CC      := gcc
BUILD_HOST_CXX     := g++
BUILD_HOST_CPP     := cpp
BUILD_HOST_AR      := ar
BUILD_HOST_NM      := nm
BUILD_HOST_RANLIB  := ranlib
endif

###############################################################################
# Host configurations
#
# The HOST variable specifies where to run your compiled tools. you can set
###############################################################################

ifeq ($(HOST),osx)
HOST_OPT        := $(shell uname -m)-apple-darwin$(shell uname -r)
BUILD_HOST_OPT  := $(shell uname -m)-apple-darwin$(shell uname -r)
BUILD_CC        := $(BUILD_HOST_CC)
BUILD_CXX       := $(BUILD_HOST_CXX)
BUILD_CPP       := $(BUILD_HOST_CPP)
CC              := $(BUILD_HOST_CC)
CXX             := $(BUILD_HOST_CXX)
CPP             := $(BUILD_HOST_CPP)
CXXCPP          := $(BUILD_HOST_CPP)
AR              := $(BUILD_HOST_AR)
NM              := $(BUILD_HOST_NM)
RANLIB          := $(BUILD_HOST_RANLIB)
endif

ifeq ($(HOST),win32)
HOST_OPT        := i686-w64-mingw32
BUILD_HOST_OPT  := $(shell uname -m)-apple-darwin$(shell uname -r)
BUILD_CC        := $(BUILD_HOST_CC)
BUILD_CXX       := $(BUILD_HOST_CXX)
BUILD_CPP       := $(BUILD_HOST_CPP)
CC              := $(HOST_OPT)-gcc
CXX             := $(HOST_OPT)-g++
CPP             := $(HOST_OPT)-cpp
AR              := $(HOST_OPT)-ar
NM              := $(HOST_OPT)-nm
OBJCOPY         := $(HOST_OPT)-objcopy
RANLIB          := $(HOST_OPT)-ranlib
LD              := $(HOST_OPT)-ld
endif

ifeq ($(HOST),linux64)
HOST_OPT        := x86_64-linux-gnu
BUILD_HOST_OPT  := $(shell uname -m)-linux-gnu
BUILD_CC        := $(BUILD_HOST_CC)
BUILD_CXX       := $(BUILD_HOST_CXX)
BUILD_CPP       := $(BUILD_HOST_CPP)
CC              := $(HOST_OPT)-gcc
CXX             := $(HOST_OPT)-g++
CPP             := $(HOST_OPT)-cpp
AR              := $(HOST_OPT)-ar
NM              := $(HOST_OPT)-nm
OBJCOPY         := $(HOST_OPT)-objcopy
RANLIB          := $(HOST_OPT)-ranlib
LD              := $(HOST_OPT)-ld
endif

# server URLs
GITHUB_URL    	:= https://github.com

## END ##
