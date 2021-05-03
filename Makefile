##
# Makefile - makefile for GNAT tools
##

# get current locations
MAKEFILE            := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
TOP_DIR             := $(patsubst %/,%,$(dir $(MAKEFILE)))
PWD                 := $(shell pwd)

# include user configuration file
sinclude $(PWD)/.config.mk

# setup build locations
PREFIX              := $(PWD)/usr/
BUILD_DIR           := $(PWD)/build/
SRC_DIR             := $(PWD)/sources/
RULES_DIR           := $(PWD)/rules/
PKG_DIR             := $(RULES_DIR)/packages/
INSTALL_DIR         := $(PREFIX)/$(HOST)
LIB_DIR             := $(PREFIX)/$(HOST)_lib

# include build settings
include $(RULES_DIR)/settings.mk

INSTALL_NATIVE_DIR  := $(PREFIX)/$(BUILD_HOST)
LIB_NATIVE_DIR      := $(PREFIX)/$(BUILD_HOST)_lib
PATH                := $(INSTALL_NATIVE_DIR)/bin:$(LIB_NATIVE_DIR)/bin:$(INSTALL_DIR)/bin:$(LIB_DIR)/bin:$(PATH)

# check processor numbers.
MAKE_MAX_JOBS       := 8
LIST_NMAX            = $(shell echo '$(strip $(1))' | tr ' ' '\n' | sort -n | tail -1)
LIST_NMIN            = $(shell echo '$(strip $(1))' | tr ' ' '\n' | sort -n | head -1)
NPROCS              := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
JOBS_AUTO           := $(call LIST_NMIN, $(MAKE_MAX_JOBS) $(NPROCS))
JOBS                := $(strip $(if $(findstring undefined,$(origin JOBS)),\
                       $(if $(and $(MAKECMDGOALS),$(filter $(MAKECMDGOALS),$(PKGS))), \
                            $(info [using autodetected $(JOBS_AUTO) job(s)])) $(JOBS_AUTO),$(JOBS)))
# build tool definitions
SHELL               := bash
DATE                := $(shell gdate --help >/dev/null 2>&1 && echo g)date
INSTALL             := $(shell ginstall --help >/dev/null 2>&1 && echo g)install
LIBTOOL             := $(shell glibtool --help >/dev/null 2>&1 && echo g)libtool
LIBTOOLIZE          := $(shell glibtoolize --help >/dev/null 2>&1 && echo g)libtoolize
PATCH               := $(shell gpatch --help >/dev/null 2>&1 && echo g)patch
GIT_GET             := git clone --branch
GIT_PUSH            := git push
GIT_PULL            := git pull
MAKE                := make -j$(JOBS)
MAKE1               := make

# common build options
CONFIG_OPTS         := --prefix=$(INSTALL_DIR)
LIB_OPTS            := --prefix=$(LIB_DIR)
TIMESTAMP           := $(shell date +%Y%m%d)
TOOLS_VERSION       := gnat tools $(TIMESTAMP)

# export variables
export PATH

# getting required branch from the GIT repository
define PREPARE_PKG_SOURCE
	$(foreach pkg,$(PKGS),$(GIT_GET) $($(pkg)_BRANCH)  $($(pkg)_URL) $(SRC_DIR)/$($(pkg)_SUBDIR);)
endef

# pull all source packages to server
define PUSH_PKG_SOURCE
        $(foreach pkg,$(PKGS), echo -n "pushing $(pkg) ...  " && cd $(SRC_DIR)/$(pkg) && $(GIT_PUSH);)
endef

define PULL_PKG_SOURCE
        $(foreach pkg,$(PKGS), echo -n "Checking $(pkg) ... " && cd $(SRC_DIR)/$(pkg) && $(GIT_PULL);)
endef

.PHONY: all get-pkgs build clean help config clobber build-setup build-stage1 build-gcc-stage1 build-gcc-final build-utils build-libc

all: help

get-pkgs:
	@echo "getting source packages from the repositry."
	@$(call PREPARE_PKG_SOURCE)

push-pkgs:
	@echo "push all source packages"
	@$(call PUSH_PKG_SOURCE)
	@git push

pull-pkgs:
	@echo "pull all source packages"
	@$(call PULL_PKG_SOURCE)
	@git pull

build-setup:
	@echo Configure build environments ...
ifeq (,$(wildcard ./build))
	@mkdir -p $(TOP_DIR)/build
endif

build-pkg-%:
	@echo " "
	@echo [START Build $*]-----------------------------------------------------------
	@echo " "
	@echo Start building $* package for $(BOARD) board.
	$(call $*_BUILD,$*)
	@echo " "
	@echo [END Build $*]-------------------------------------------------------------
	@echo " "

clean-pkg-%:
	@echo " "
	@echo [START Clean $*]-----------------------------------------------------------
	@echo " "
	@echo Start building $* package for $(BOARD) board.
	$(call $*_CLEAN,$*)
	@echo " "
	@echo [END Clean $*]-------------------------------------------------------------
	@echo " "

# stage #1 build procedure
build-stage1:
	@echo build for $(HOST) $(TARGET) architecture
	@echo package lists: $(BUILD_LISTS)
	@for pkg in $(BUILD_LISTS);do $(MAKE1) -f $(MAKEFILE) build-pkg-$$pkg; done

build-gcc-stage1:
	@echo ""
	@echo "Build gcc stage #1"
	@echo ""
	$(call gcc_BUILD_first,gcc)
	@echo ""
	@echo "End gcc stage #1"
	@echo ""

build-libc:
	@echo Build for libc
	@echo package lists: $(BUILD_LISTS_LIBC)
	@for pkg in $(BUILD_LISTS_LIBC);do $(MAKE1) -f $(MAKEFILE) build-pkg-$$pkg; done

build-gcc-final:
	@echo ""
	@echo "Build final gcc"
	@echo ""
	$(call gcc_BUILD_final,gcc)
	@echo ""
	@echo "End final gcc"
	@echo ""

build-utils:
	@echo ""
	@echo "Build utilities"
	@echo ""
	@for pkg in $(BUILD_UTILS);do $(MAKE1) -f $(MAKEFILE) build-pkg-$$pkg; done

build:
	@rm -rf $(BUILD_DIR)
	@$(MAKE1) -f $(MAKEFILE) build-setup
	@$(MAKE1) -f $(MAKEFILE) get-pkgs
	@$(MAKE1) -f $(MAKEFILE) build-stage1
	@$(MAKE1) -f $(MAKEFILE) build-gcc-stage1
	@$(MAKE1) -f $(MAKEFILE) build-libc
	@$(MAKE1) -f $(MAKEFILE) build-gcc-final
	@$(MAKE1) -f $(MAKEFILE) build-utils

clean:
	@echo clean build outputs ... done!
	@rm -rf $(BUILD_DIR)

clobber:
	@echo Delete all source and build directory!!
	@rm -rf $(SRC_DIR) $(BUILD_DIR)

config:
	@sh $(RULES_DIR)/config.tgt

help:
	@echo ""
	@echo "Usage:make [options] build HOST=host_name TARGET=target_architecture"
	@echo "host_name lists: "
	@echo "osx     for Mac OSX"
	@echo "linux64 for Linux 64bit"
	@echo ""
	@echo "target_architecture lists:"
	@echo "arm     for ARM architecture"
	@echo "ppc     for PowerPC architecture"
	@echo "x86     for Intel x86 architecture"
	@echo ""
	@echo "example to build ARM compiler for win32"
	@echo "make build HOST=win32 TARGET=arm"

test:
	@echo HOST=$(HOST)
	@echo TARGET=$(TARGET)
	@echo BUILD_HOST=$(BUILD_HOST)
	@echo PATH=$(PATH)

include $(patsubst %,$(PKG_DIR)/%.mk,$(PKGS))

## END ##
