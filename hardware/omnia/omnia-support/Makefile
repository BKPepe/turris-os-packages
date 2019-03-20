include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=omnia-support
PKG_VERSION:=2.1
PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/packages

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	TITLE:=$(PKG_NAME)
	VERSION:=$(LINUX_VERSION)-$(LINUX_RELEASE)-$(LINUX_VERMAGIC)
	DEPENDS:=@TARGET_mvebu_cortexa9_DEVICE_turris-omnia
endef

define Package/$(PKG_NAME)/description
 Contains supporting files for Turris Omnia.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(KERNEL_MAKE) zImage dtbs
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/boot
	$(INSTALL_DATA) $(LINUX_DIR)/arch/$(LINUX_KARCH)/boot/dts/armada-385-turris-omnia-*.dtb "$(1)"/boot
	mkimage -T script -C none -n boot -d files/boot.txt "$(1)"/boot.scr
endef

define Package/$(PKG_NAME)/postinst
# Link default Omnia dtb unless there is existing link
DTB="$$IPKG_INSTROOT/boot/dtb"
[ -L "$$DTB" ] || ln -sf armada-385-turris-omnia-phy.dtb "$$DTB"
endef

$(eval $(call BuildPackage,$(PKG_NAME)))