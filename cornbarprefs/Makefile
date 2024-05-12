#THEOS_PACKAGE_SCHEME=rootless

ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	ARCHS = arm64 arm64e
	TARGET = iphone:clang:15.5:15.0
else
	ARCHS = armv7 arm64 arm64e
	TARGET = iphone:clang:14.2:8.0
endif

include $(THEOS)/makefiles/common.mk

SDKVERSION = 16.5
BUNDLE_NAME = CornBarPrefs

$(BUNDLE_NAME)_FILES = CBRRootListController.m
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_LIBRARIES = colorpicker
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
