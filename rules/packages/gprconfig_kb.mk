# gprconfig_kb.mk - makefile for gprconfig_kb
PKG              := gprconfig_kb
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_URL)/AdaCore/gprconfig_kb.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR := $(BUILD_DIR)/$($(PKG)_SUBDIR)_$(HOST)_$(TARGET)

define $(PKG)_BUILD
    @echo Nothing to do for $(1) package
endef
