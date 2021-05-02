# zlib.mk - makefile for zlib library
PKG            := zlib
$(PKG)_VERSION := v1.2.11
$(PKG)_SUBDIR  := $(PKG)
$(PKG)_URL     := https://github.com/madler/zlib.git
$(PKG)_BRANCH  := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR := $(BUILD_DIR)/$($(PKG)_SUBDIR)_$(HOST)_$(TARGET)

define $(PKG)_BUILD
    @echo Building $(1) package for $(HOST) host $(TARGET) architecture
	mkdir -p $($(1)_BUILD_DIR) && \
    cd $($(1)_BUILD_DIR) &&       \
	CC=$(CC) CXX=$(CXX) $(SRC_DIR)/$($(1)_SUBDIR)/configure $(LIB_OPTS) --static
    $(MAKE) -C $($(1)_BUILD_DIR)
    $(MAKE) -C $($(1)_BUILD_DIR) install
endef
