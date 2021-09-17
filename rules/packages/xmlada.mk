# xmlada.mk - makefile for xmlada library
PKG              := xmlada
$(PKG)_VERSION   := lts-21
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_URL)/AdaCore/xmlada.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR := $(BUILD_DIR)/$($(PKG)_SUBDIR)_$(HOST)_$(TARGET)

# build options
$(PKG)_HOST_OPT  := $(HOST_OPT)
$(PKG)_BUILD_OPT := $(BUILD_HOST_OPT)

ifeq ($(TARGET),arm)
$(PKG)_TARGET_OPT := --target=arm-eabi
endif


# Cross-compile build routine.
define $(PKG)_BUILD
    @echo "Skip building $(1) package: Not required."
endef

# ONLY for HOST 
define $(PKG)_BUILD_HOST
    @echo Building $(1) package for $(HOST) host $(TARGET) architecture
    rm -rf $($(1)_BUILD_DIR) &&                                              \
    cp -rf $(SRC_DIR)/$($(1)_SUBDIR) $($(1)_BUILD_DIR) &&                    \
    cd $($(1)_BUILD_DIR) &&                                                  \
    $(SRC_DIR)/$($(1)_SUBDIR)/configure $(CONFIG_OPTS) $($(1)_TARGET_OPT) && \
    $(MAKE1) all install
endef
