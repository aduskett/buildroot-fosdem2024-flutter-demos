################################################################################
#
# flutter-packages
#
################################################################################

FLUTTER_PACKAGES_VERSION = e4cbf235ec4d2c0286e6abce2a802560b1d8e1b4
FLUTTER_PACKAGES_SITE = https://github.com/flutter/packages.git
FLUTTER_PACKAGES_SITE_METHOD = git
FLUTTER_PACKAGES_LICENSE = BSD-3-Clause
FLUTTER_PACKAGES_LICENSE_FILES = LICENSE
FLUTTER_PACKAGES_DL_SUBDIR = flutter-packages
FLUTTER_PACKAGES_SOURCE = flutter-packages-$(FLUTTER_PACKAGES_VERSION)-br1.tar.gz
FLUTTER_PACKAGES_DEPENDENCIES = \
	host-flutter-sdk-bin \
	flutter-engine

include $(sort $(wildcard package/flutter-packages/*/*.mk))
