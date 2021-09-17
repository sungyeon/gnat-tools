# gprbuild.mk - makefile for gprbuild
PKG              := gprbuild
$(PKG)_VERSION   := v21.0.0
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_URL)/AdaCore/gprbuild.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR := $(BUILD_DIR)/$($(PKG)_SUBDIR)_$(HOST)_$(TARGET)

# build options
$(PKG)_HOST_OPT  := $(HOST_OPT)
$(PKG)_BUILD_OPT := $(BUILD_HOST_OPT)

define $(PKG)_BUILD
    @echo Building $(1) package for $(HOST) host $(TARGET) architecture
    rm -rf $($(1)_BUILD_DIR) &&                              \
    cp -rf $(SRC_DIR)/$($(1)_SUBDIR) $($(1)_BUILD_DIR) &&    \
    cd $($(1)_BUILD_DIR) &&       						     \
    git apply $(PKG_DIR)/gpr_imports_macos.patch &&          \
    ./bootstrap.sh --with-xmlada=$(SRC_DIR)/$(xmlada_SUBDIR) --with-kb=$(SRC_DIR)/$(gprconfig_kb_SUBDIR) --prefix=$(BUILD_DIR)/gprbuild_bootstrap && \
    export PATH=$(BUILD_DIR)/gprbuild_bootstrap:"$(PATH)" && \
    $(MAKE1) prefix=$(INSTALL_DIR) setup && \
    $(MAKE1) all install
endef
