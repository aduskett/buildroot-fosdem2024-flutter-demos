################################################################################
#
# flutter-packages
#
################################################################################

FLUTTER_PACKAGES_VERSION = 611aea1657fbfc0d2564a14b08e12dffc70189bb
FLUTTER_PACKAGES_SITE = https://github.com/flutter/packages.git
FLUTTER_PACKAGES_SITE_METHOD = git
FLUTTER_PACKAGES_LICENSE = BSD-3-Clause
FLUTTER_PACKAGES_LICENSE_FILES = LICENSE
FLUTTER_PACKAGES_DL_SUBDIR = flutter-packages
FLUTTER_PACKAGES_SOURCE = flutter-packages-$(FLUTTER_PACKAGES_VERSION)-br1.tar.gz

include $(sort $(wildcard package/flutter-packages/*/*.mk))
