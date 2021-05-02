# isl.mk - makefile for ISL library
PKG              := isl
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := https://repo.or.cz/isl.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR := $(BUILD_DIR)/$($(PKG)_SUBDIR)_$(HOST)_$(TARGET)

# build options
$(PKG)_HOST_OPT  := $(HOST_OPT)
$(PKG)_BUILD_OPT := $(BUILD_HOST_OPT)

define $(PKG)_BUILD
    @echo Building $(1) package for $(HOST) host $(TARGET) architecture
	cd $(SRC_DIR)/$($(1)_SUBDIR) && ./autogen.sh
	mkdir -p $($(1)_BUILD_DIR)
	rm -rf $(SRC_DIR)/$($(1)_SUBDIR)/.git
    cd $($(1)_BUILD_DIR) &&       		\
	CC=$(CC) CXX=$(CXX) 				\
	$(SRC_DIR)/$($(1)_SUBDIR)/configure \
	$(LIB_OPTS)							\
	--host=$($(1)_HOST_OPT)             \
	--build=$($(1)_BUILD_OPT)           \
	--with-gmp_prefix=$(LIB_DIR)
    $(MAKE) -C $($(1)_BUILD_DIR)
    $(MAKE) -C $($(1)_BUILD_DIR) install
endef
