#
## Copyright (C) 2013-2020 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=nor-update
PKG_RELEASE:=1
PKG_VERSION:=2.0

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk

define Package/turris-nor-update
  TITLE:=NOR update for Turris routers
  DEPENDS:=+mtd +turris-nor-update-firmware
endef

Build/Compile:=:

define Package/turris-nor-update-devel-firmware
  TITLE:=Data files for nor-update (development version)
  DEPENDS:=+turris-nor-update +rescue-image \
		  +@TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia:u-boot-omnia \
		  +@TARGET_mvebu_cortexa53_DEVICE_cznic-mox:u-boot-mox
  VERSION:=0.9
endef

ifeq ($(CONFIG_TARGET_mvebu_cortexa53_DEVICE_cznic-mox),y)
DEVICE:=mox
DATA_VERSION:=1.0
else ifeq ($(CONFIG_TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia),y)
DEVICE:=omnia
DATA_VERSION:=1.0
else ifeq ($(CONFIG_TARGET_mpc85xx_p2020_DEVICE_turris1x),y)
DEVICE:=turris1x
DATA_VERSION:=0.1
else
DEVICE:=unknown
DATA_VERSION:=0.0
endif

define Package/turris-nor-update-firmware
  TITLE:=Data files for nor-update
  VERSION:=$(DATA_VERSION)
endef

Package/turris-nor-update-devel-firmware/install:=:

define Package/turris-nor-update-firmware/install
	$(INSTALL_DIR) $(1)/usr/share/nor-update/
	$(INSTALL_DATA) ./files/$(DEVICE)/* $(1)/usr/share/nor-update/
endef

define Package/turris-nor-update/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/nor-update $(1)/usr/sbin/nor-update
endef

$(eval $(call BuildPackage,turris-nor-update))
$(eval $(call BuildPackage,turris-nor-update-devel-firmware))
$(eval $(call BuildPackage,turris-nor-update-firmware))
