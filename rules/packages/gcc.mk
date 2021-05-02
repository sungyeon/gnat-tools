# gcc.mk - makefile for gcc

PKG                     := gcc
$(PKG)_VERSION          := releases/gcc-10.3.0
$(PKG)_SUBDIR           := $(PKG)
$(PKG)_URL              := https://gcc.gnu.org/git/gcc.git
$(PKG)_BRANCH           := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR1       := $(BUILD_DIR)/$($(PKG)_SUBDIR)_$(HOST)_$(TARGET)_1
$(PKG)_BUILD_DIR2       := $(BUILD_DIR)/$($(PKG)_SUBDIR)_$(HOST)_$(TARGET)_2

# host system detection
GCC_BUILD_HOST_OPT:= $(shell uname -m)-apple-darwin$(shell uname -r)

# target options
ifeq ($(TARGET),aarch64)
$(PKG)_TARGET_OPT       := aarch64-eabi
$(PKG)_CONFIG_ARCH_OPTS += --disable-libssp --enable-interwork --enable-multilib --with-multilib-list=default
$(PKG)_BUILD_OPT        +=
CFLAGS_FOR_TARGET       += -DARM -D__ARM__ -D__ARM64__
CXXFLAGS_FOR_TARGET     += $(CFLAGS_FOR_TARGET)
endif

ifeq ($(TARGET),arm)
$(PKG)_TARGET_OPT       := arm-eabi
$(PKG)_CONFIG_ARCH_OPTS += --disable-libssp --enable-interwork --enable-multilib --with-multilib-list=rmprofile,aprofile
$(PKG)_BUILD_OPT        +=
CFLAGS_FOR_TARGET       += -DARM -D__ARM__ -D__ARM32__
CXXFLAGS_FOR_TARGET     += $(CFLAGS_FOR_TARGET)
endif

ifeq ($(TARGET),x86)
$(PKG)_TARGET_OPT       := i386-elf
$(PKG)_CONFIG_ARCH_OPTS += --disable-libssp --enable-multilib --with-multilib-list=m32
$(PKG)_BUILD_OPT        +=
CFLAGS_FOR_TARGET       += -DX86 -D__X86__
CXXFLAGS_FOR_TARGET     += $(CFLAGS_FOR_TARGET)
endif

ifeq ($(TARGET),ppc)
$(PKG)_TARGET_OPT       := powerpc-elf
$(PKG)_CONFIG_ARCH_OPTS += --disable-libssp --enable-multilib
$(PKG)_BUILD_OPT        +=
CFLAGS_FOR_TARGET       += -DPPC -D__PPC__ -D__PPC32__
CXXFLAGS_FOR_TARGET     += $(CFLAGS_FOR_TARGET)
endif

ifeq ($(TARGET),ppc64)
$(PKG)_TARGET_OPT       := powerpc64-elf
$(PKG)_CONFIG_ARCH_OPTS += --disable-libssp --enable-multilib
$(PKG)_BUILD_OPT        +=
CFLAGS_FOR_TARGET       += -DPPC -D__PPC__ -D__PPC64__
CXXFLAGS_FOR_TARGET     += $(CFLAGS_FOR_TARGET)
endif

# host options
ifeq ($(HOST),osx)
$(PKG)_HOST_OPT         := $(GCC_BUILD_HOST_OPT)
$(PKG)_BUILD_OPT        := $(BUILD_HOST_OPT)
CC_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-gcc"
CXX_FOR_TARGET          := "$($(PKG)_TARGET_OPT)-g++"
GCC_FOR_TARGET          := "$($(PKG)_TARGET_OPT)-gcc"
AR_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-ar"
LD_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-ld"
NM_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-nm"
RANLIB_FOR_TARGET       := "$($(PKG)_TARGET_OPT)-ranlib"
STRIP_FOR_TARGET        := "$($(PKG)_TARGET_OPT)-strip"
READELF_FOR_TARGET      := "$($(PKG)_TARGET_OPT)-readelf"
endif

# host options
ifeq ($(HOST),win32)
$(PKG)_HOST_OPT         := $(HOST_OPT)
$(PKG)_BUILD_OPT        := $(BUILD_HOST_OPT)
CC_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-gcc"
CXX_FOR_TARGET          := "$($(PKG)_TARGET_OPT)-g++"
GCC_FOR_TARGET          := "$($(PKG)_TARGET_OPT)-gcc"
AR_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-ar"
LD_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-ld"
NM_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-nm"
RANLIB_FOR_TARGET       := "$($(PKG)_TARGET_OPT)-ranlib"
STRIP_FOR_TARGET        := "$($(PKG)_TARGET_OPT)-strip"
READELF_FOR_TARGET      := "$($(PKG)_TARGET_OPT)-readelf"
endif

# host options
ifeq ($(HOST),linux32)
$(PKG)_HOST_OPT         := $(HOST_OPT)
$(PKG)_BUILD_OPT        := $(BUILD_HOST_OPT)
CC_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-gcc"
CXX_FOR_TARGET          := "$($(PKG)_TARGET_OPT)-g++"
GCC_FOR_TARGET          := "$($(PKG)_TARGET_OPT)-gcc"
AR_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-ar"
LD_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-ld"
NM_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-nm"
RANLIB_FOR_TARGET       := "$($(PKG)_TARGET_OPT)-ranlib"
STRIP_FOR_TARGET        := "$($(PKG)_TARGET_OPT)-strip"
READELF_FOR_TARGET      := "$($(PKG)_TARGET_OPT)-readelf"
endif

# host options
ifeq ($(HOST),linux64)
$(PKG)_HOST_OPT         := $(HOST_OPT)
$(PKG)_BUILD_OPT        := $(BUILD_HOST_OPT)
CC_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-gcc"
CXX_FOR_TARGET          := "$($(PKG)_TARGET_OPT)-g++"
GCC_FOR_TARGET          := "$($(PKG)_TARGET_OPT)-gcc"
AR_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-ar"
LD_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-ld"
NM_FOR_TARGET           := "$($(PKG)_TARGET_OPT)-nm"
RANLIB_FOR_TARGET       := "$($(PKG)_TARGET_OPT)-ranlib"
STRIP_FOR_TARGET        := "$($(PKG)_TARGET_OPT)-strip"
READELF_FOR_TARGET      := "$($(PKG)_TARGET_OPT)-readelf"
$(PKG)_CONFIG_ARCH_OPTS := --with-system-zlib
endif

export CC_FOR_TARGET CXX_FOR_TARGET GCC_FOR_TARGET AR_FOR_TARGET LD_FOR_TARGET NM_FOR_TARGET
export RANLIB_FOR_TARGET STRIP_FOR_TARGET READELF_FOR_TARGET CFLAGS_FOR_TARGET CXXFLAGS_FOR_TARGET
export INCL_FIXED_PATH

# stage-1 build
define $(PKG)_BUILD_first
    @echo Building $(1) package for $(HOST) host and $(TARGET) architecture
    mkdir -p $($(1)_BUILD_DIR1)
    cd $($(1)_BUILD_DIR1) &&                                \
    CC=$(CC) CXX=$(CXX) $(SRC_DIR)/$($(1)_SUBDIR)/configure \
    --host=$($(1)_HOST_OPT)                                 \
    --target=$($(1)_TARGET_OPT)                             \
    --build=$($(1)_BUILD_OPT)                               \
    $(CONFIG_OPTS)                                          \
    $($(1)_CONFIG_ARCH_OPTS)                                \
    --disable-decimal-float                                 \
    --disable-libffi                                        \
    --disable-libgomp                                       \
    --disable-libmudflap                                    \
    --disable-libquadmath                                   \
    --disable-libssp                                        \
    --disable-libstdcxx-pch                                 \
    --disable-nls                                           \
    --disable-shared                                        \
    --disable-threads                                       \
    --disable-tls                                           \
    --enable-languages=c                                    \
    --without-headers                                       \
    --with-gnu-as                                           \
    --with-gnu-ld                                           \
    --with-gmp=$(LIB_NATIVE_DIR)                            \
    --with-mpfr=$(LIB_NATIVE_DIR)                           \
    --with-mpc=$(LIB_NATIVE_DIR)                            \
    "--with-pkgversion=$(TOOLS_VERSION)"
    $(MAKE1) -C $($(1)_BUILD_DIR1) all-gcc
    $(MAKE1) -C $($(1)_BUILD_DIR1) install-gcc
endef

# final build including c++.
define $(PKG)_BUILD_final
    @echo Building $(1) final package for $(HOST) host and $(TARGET) architecture
    @mkdir -p $($(1)_BUILD_DIR2)
    cd $($(1)_BUILD_DIR2) && CC=$(CC) CXX=$(CXX)            \
    $(SRC_DIR)/$($(1)_SUBDIR)/configure                     \
    --target=$($(1)_TARGET_OPT)                             \
    --host=$($(1)_HOST_OPT)                                 \
    --build=$($(1)_BUILD_OPT)                               \
    $(CONFIG_OPTS)                                          \
    $($(1)_CONFIG_ARCH_OPTS)                                \
    --disable-decimal-float                                 \
    --disable-libffi                                        \
    --disable-libgomp                                       \
    --disable-libmudflap                                    \
    --disable-libquadmath                                   \
    --disable-libstdcxx-pch                                 \
    --disable-nls                                           \
    --disable-shared                                        \
    --disable-tls                                           \
	--enable-plugins                                        \
	--disable-threads                                       \
	--disable-libada                                        \
	--enable-languages=c,c++,ada                            \
    --enable-poison-system-directories                      \
    --enable-__cxa_atexit                                   \
    --with-gnu-as                                           \
    --with-gnu-ld                                           \
    --with-newlib                                           \
	--with-headers=yes                                      \
    --with-gmp=$(LIB_DIR)                                   \
    --with-mpfr=$(LIB_DIR)                                  \
    --with-mpc=$(LIB_DIR)                                   \
    --with-cloog=$(LIB_DIR)                                 \
    --with-libelf=$(LIB_DIR)                                \
    --with-isl=$(LIB_DIR)                                   \
    --with-libiconv-prefix=$(NATIVE_LIB_DIR)                \
    --with-native-system-header-dir=/include                \
    --with-build-sysroot=$(INSTALL_DIR)/$($(1)_TARGET_OPT)  \
    --with-sysroot=$(INSTALL_DIR)/$($(1)_TARGET_OPT)        \
    "--with-pkgversion=$(TOOLS_VERSION)"
    $(MAKE1) -C $($(1)_BUILD_DIR2)
    $(MAKE1) -C $($(1)_BUILD_DIR2) install
endef
