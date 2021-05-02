# binutils.mk - makefile for binutils
PKG              := binutils
$(PKG)_VERSION   := binutils-2_36_1
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := https://sourceware.org/git/binutils-gdb.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR := $(BUILD_DIR)/$($(PKG)_SUBDIR)_$(HOST)_$(TARGET)

# host options
ifeq ($(HOST),osx)
$(PKG)_HOST_OPT         := $(HOST_OPT)
$(PKG)_BUILD_OPT        := $(BUILD_HOST_OPT)
else
$(PKG)_HOST_OPT         := $(HOST_OPT)
$(PKG)_BUILD_OPT        := $(BUILD_HOST_OPT)
CC_FOR_TARGET           := "$(HOST_OPT)-gcc"
CXX_FOR_TARGET          := "$(HOST_OPT)-g++"
GCC_FOR_TARGET          := "$(HOST_OPT)-gcc"
AR_FOR_TARGET           := "$(HOST_OPT)-ar"
LD_FOR_TARGET           := "$(HOST_OPT)-ld"
NM_FOR_TARGET           := "$(HOST_OPT)-nm"
RANLIB_FOR_TARGET       := "$(HOST_OPT)-ranlib"
STRIP_FOR_TARGET        := "$(HOST_OPT)-strip"
READELF_FOR_TARGET      := "$(HOST_OPT)-readelf"
CC_FOR_BUILD            := gcc
export CC_FOR_BUILD CC CXX AR RANLIB STRIP NM
endif

export CC_FOR_TARGET CXX_FOR_TARGET GCC_FOR_TARGET AR_FOR_TARGET LD_FOR_TARGET NM_FOR_TARGET
export RANLIB_FOR_TARGET STRIP_FOR_TARGET READELF_FOR_TARGET CFLAGS_FOR_TARGET CXXFLAGS_FOR_TARGET

# target options
ifeq ($(TARGET),aarch64)
$(PKG)_TARGET_OPT       := aarch64-eabi-
$(PKG)_CONFIG_ARCH_OPTS := --enable-interwork --enable-multilib --enable-poison-system-directories
$(PKG)_BUILD_OPT        :=
endif

ifeq ($(TARGET),arm)
$(PKG)_TARGET_OPT       := arm-eabi
$(PKG)_CONFIG_ARCH_OPTS := --enable-interwork --enable-multilib --enable-poison-system-directories
$(PKG)_BUILD_OPT        :=
endif

ifeq ($(TARGET),x86)
$(PKG)_TARGET_OPT       := i386-elf
$(PKG)_CONFIG_ARCH_OPTS := --enable-multilib --enable-poison-system-directories
$(PKG)_BUILD_OPT        :=
endif

ifeq ($(TARGET),ppc)
$(PKG)_CONFIG_ARCH_OPTS := --enable-multilib --enable-poison-system-directories
$(PKG)_TARGET_OPT       := powerpc-elf
$(PKG)_BUILD_OPT        :=
endif

ifeq ($(TARGET),ppc64)
$(PKG)_TARGET_OPT       := powerpc64-elf
$(PKG)_CONFIG_ARCH_OPTS := --enable-multilib --enable-poison-system-directories --enable-64-bit-bfd
$(PKG)_BUILD_OPT        :=
endif

define $(PKG)_BUILD
    @echo Building $(1) package for $(HOST) host $(TARGET) architecture
	mkdir -p $($(1)_BUILD_DIR)
    cd $(SRC_DIR)/$($(1)_SUBDIR) && git checkout tags/$($(1)_VERSION)
	cd $($(1)_BUILD_DIR) &&                                                 \
    CC=$(CC) CXX=$(CXX) CC_FOR_BUILD=$(BUILD_CC) CXX_FOR_BUILD=$(BUILD_CXX) \
    $(SRC_DIR)/$($(1)_SUBDIR)/configure                                     \
    --host=$($(1)_HOST_OPT)                                                 \
    --target=$($(1)_TARGET_OPT)                                             \
    --build=$($(1)_BUILD_OPT)                                               \
    $(CONFIG_OPTS)                                                          \
    $($(1)_CONFIG_ARCH_OPTS)                                                \
    --disable-nls                                                           \
    --disable-werror                                                        \
    --disable-shared                                                        \
    --disable-gdb                                                           \
    --enable-plugins                                                        \
    --enable-expat                                                          \
    --enable-gold                                                           \
    --enable-lto                                                            \
    --enable-target=all                                                     \
    --with-expat                                                            \
    --with-libexpat-prefix=$(LIB_DIR)                                       \
    --with-sysroot=$(INSTALL_DIR)/$($(1)_HOST_OPT)                          \
    "--with-pkgversion=$(TOOLS_VERSION)"
    $(MAKE) -C $($(1)_BUILD_DIR)
	$(MAKE) -C $($(1)_BUILD_DIR) install
endef
