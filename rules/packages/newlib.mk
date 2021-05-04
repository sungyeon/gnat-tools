# newlib.mk - makefile for newlib library
PKG              := newlib
$(PKG)_VERSION   := newlib-4.1.0
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := git://sourceware.org/git/newlib-cygwin.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR := $(BUILD_DIR)/$($(PKG)_SUBDIR)_$(HOST)_$(TARGET)

ifeq ($(TARGET),arm)
$(PKG)_TARGET_OPT       := arm-eabi
$(PKG)_CONFIG_ARCH_OPTS := --enable-interwork
$(PKG)_BUILD_OPT        :=
endif

define $(PKG)_BUILD
    @echo Building $(1) package for $(HOST) host $(TARGET) architecture
	rm -rf $($(1)_BUILD_DIR)
    cp -rf $(SRC_DIR)/$($(1)_SUBDIR) $($(1)_BUILD_DIR)
	cd $($(1)_BUILD_DIR) &&       						\
	$(SRC_DIR)/$($(1)_SUBDIR)/configure 				\
	$(CONFIG_OPTS)                      				\
	--host=$($(1)_HOST_OPT)             				\
    --target=$($(1)_TARGET_OPT)         				\
	--enable-newlib-io-long-long                        \
	--enable-newlib-io-c99-formats                      \
	--enable-newlib-reent-check-verify                  \
	--enable-newlib-register-fini                       \
	--enable-newlib-retargetable-locking                \
	--disable-newlib-supplied-syscalls                  \
	--disable-nls                                       \
	$($(1)_CONFIG_ARCH_OPTS)
	cd $($(1)_BUILD_DIR) && $(MAKE1) all install
endef
