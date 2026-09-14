export TARGET_CODESIGN = echo

TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TurathAlert

TurathAlert_FILES = main.m
TurathAlert_CFLAGS = -fobjc-arc
TurathAlert_FRAMEWORKS = UIKit CoreGraphics WebKit

include $(THEOS)/makefiles/tweak.mk
