################################################################################
#
# flutter-textpad
#
################################################################################

FLUTTER_TEXTPAD_VERSION = fe7c6618eea2553dd9d51431f1e0c61b3542bf5e
FLUTTER_TEXTPAD_SITE = https://github.com/WAKazuyoshiAkiyama/flutter_textpad.git
FLUTTER_TEXTPAD_SITE_METHOD = git
FLUTTER_TEXTPAD_LICENSE = BSD-3-Clause
FLUTTER_TEXTPAD_LICENSE_FILES = LICENSE
FLUTTER_TEXTPAD_DEPENDENCIES = \
	host-flutter-sdk-bin \
	flutter-engine

FLUTTER_TEXTPAD_INSTALL_DIR = $(TARGET_DIR)/usr/share/flutter/textpad/$(FLUTTER_ENGINE_RUNTIME_MODE)

define FLUTTER_TEXTPAD_CONFIGURE_CMDS
	cd $(@D) && \
		FLUTTER_RUNTIME_MODES=$(FLUTTER_ENGINE_RUNTIME_MODE) \
		$(HOST_FLUTTER_SDK_BIN_FLUTTER) clean && \
		$(HOST_FLUTTER_SDK_BIN_FLUTTER) pub get && \
		$(HOST_FLUTTER_SDK_BIN_FLUTTER) build bundle
endef

define FLUTTER_TEXTPAD_BUILD_CMDS
	cd $(@D) && \
		$(HOST_FLUTTER_SDK_BIN_DART_BIN) \
			--native-assets $(@D)/.dart_tool/flutter_build/*/native_assets.yaml \
			package:flutter_textpad/main.dart && \
		$(HOST_FLUTTER_SDK_BIN_ENV) $(FLUTTER_ENGINE_GEN_SNAPSHOT) \
			--deterministic \
			--obfuscate \
			--snapshot_kind=app-aot-elf \
			--elf=libapp.so \
			.dart_tool/flutter_build/*/app.dill
endef

define FLUTTER_TEXTPAD_INSTALL_TARGET_CMDS
	mkdir -p $(FLUTTER_TEXTPAD_INSTALL_DIR)/{data,lib}
	cp -dprf $(@D)/build/flutter_assets $(FLUTTER_TEXTPAD_INSTALL_DIR)/data/

	$(INSTALL) -D -m 0755 $(@D)/libapp.so \
		$(FLUTTER_TEXTPAD_INSTALL_DIR)/lib/libapp.so

	ln -sf /usr/share/flutter/$(FLUTTER_ENGINE_RUNTIME_MODE)/data/icudtl.dat \
	$(FLUTTER_TEXTPAD_INSTALL_DIR)/data/

	ln -sf /usr/lib/libflutter_engine.so $(FLUTTER_TEXTPAD_INSTALL_DIR)/lib/
	$(RM) $(FLUTTER_TEXTPAD_INSTALL_DIR)/data/flutter_assets/kernel_blob.bin
	touch $(FLUTTER_TEXTPAD_INSTALL_DIR)/data/flutter_assets/kernel_blob.bin
endef

$(eval $(generic-package))
