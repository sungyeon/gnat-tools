# gmp.mk - makefile for GMP library
PKG              := gmp
$(PKG)_VERSION   := v6.2.0
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_URL)/sungyeon/gmp.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR := $(BUILD_DIR)/$($(PKG)_SUBDIR)_$(HOST)_$(TARGET)

# build options
$(PKG)_HOST_OPT  := $(HOST_OPT)
$(PKG)_BUILD_OPT := $(BUILD_HOST_OPT)

define $(PKG)_BUILD
    @echo Building $(1) package for $(HOST) host $(TARGET) architecture
    mkdir -p $($(1)_BUILD_DIR) && 		\
    cd $($(1)_BUILD_DIR) &&       		\
    CC=$(CC) CXX=$(CXX) 				\
    $(SRC_DIR)/$($(1)_SUBDIR)/configure \
    $(LIB_OPTS)							\
    $(CONFIG_ARCH_OPTS)                 \
    --host=$($(1)_HOST_OPT)             \
    --build=$($(1)_BUILD_OPT)           \
    --enable-cxx --without-readline
    $(MAKE) -C $($(1)_BUILD_DIR)
    $(MAKE) -C $($(1)_BUILD_DIR) install
endef
