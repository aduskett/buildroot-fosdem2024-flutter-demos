################################################################################
#
# flutter-animations-example
#
################################################################################

FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_VERSION = $(FLUTTER_PACKAGES_VERSION)
FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_SITE = $(FLUTTER_PACKAGES_SITE)
FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_SITE_METHOD = $(FLUTTER_PACKAGES_SITE_METHOD)
FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_SOURCE = $(FLUTTER_PACKAGES_SOURCE)
FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_LICENSE = $(FLUTTER_PACKAGES_LICENSE)
FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_LICENSE_FILES = $(FLUTTER_PACKAGES_LICENSE_FILES)
FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_DL_SUBDIR = $(FLUTTER_PACKAGES_DL_SUBDIR)
FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_DEPENDENCIES = $(FLUTTER_PACKAGES_DEPENDENCIES)
FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_PKG_NAME = example
FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_INSTALL_DIR = $(TARGET_DIR)/usr/share/flutter/dynamc-layouts-$(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_PKG_NAME)/$(FLUTTER_ENGINE_RUNTIME_MODE)
FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_BUILD_DIR = $(@D)/packages/dynamic_layouts/example

define FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_CONFIGURE_CMDS
	cd $(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_BUILD_DIR) && \
		FLUTTER_RUNTIME_MODES=$(FLUTTER_ENGINE_RUNTIME_MODE) \
		$(HOST_FLUTTER_SDK_BIN_FLUTTER) clean && \
		$(HOST_FLUTTER_SDK_BIN_FLUTTER) pub get && \
		$(HOST_FLUTTER_SDK_BIN_FLUTTER) build bundle
endef

define FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_BUILD_CMDS
	cd $(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_BUILD_DIR) && \
		$(HOST_FLUTTER_SDK_BIN_DART_BIN) \
			--native-assets $(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_BUILD_DIR)/.dart_tool/flutter_build/*/native_assets.yaml \
			package:$(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_PKG_NAME)/main.dart && \
		$(HOST_FLUTTER_SDK_BIN_ENV) $(FLUTTER_ENGINE_GEN_SNAPSHOT) \
			--deterministic \
			--obfuscate \
			--snapshot_kind=app-aot-elf \
			--elf=libapp.so \
			.dart_tool/flutter_build/*/app.dill
endef

define FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_INSTALL_TARGET_CMDS
	mkdir -p $(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_INSTALL_DIR)/{data,lib}
	cp -dprf $(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_BUILD_DIR)/build/flutter_assets $(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_INSTALL_DIR)/data/

	$(INSTALL) -D -m 0755 $(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_BUILD_DIR)/libapp.so \
		$(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_INSTALL_DIR)/lib/libapp.so

	ln -sf /usr/share/flutter/$(FLUTTER_ENGINE_RUNTIME_MODE)/data/icudtl.dat \
	$(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_INSTALL_DIR)/data/

	ln -sf /usr/lib/libflutter_engine.so $(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_INSTALL_DIR)/lib/
	$(RM) $(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_INSTALL_DIR)/data/flutter_assets/kernel_blob.bin
	touch $(FLUTTER_DYNAMIC_LAYOUTS_EXAMPLE_INSTALL_DIR)/data/flutter_assets/kernel_blob.bin
endef

$(eval $(generic-package))
