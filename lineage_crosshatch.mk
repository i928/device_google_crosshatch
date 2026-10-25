#
# Copyright (C) 2018-2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/google/crosshatch/aosp_crosshatch.mk)

include device/google/crosshatch/crosshatch/device-lineage.mk

# Device identifier. This must come after all inclusions
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 3 XL
PRODUCT_NAME := lineage_crosshatch

# Boot animation
TARGET_SCREEN_HEIGHT := 2960
TARGET_SCREEN_WIDTH := 1440

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="crosshatch-user 12 SP1A.210812.016.C2 8618562 release-keys" \
    BuildFingerprint=google/crosshatch/crosshatch:12/SP1A.210812.016.C2/8618562:user/release-keys \
    DeviceProduct=crosshatch

$(call inherit-product, vendor/google/crosshatch/crosshatch-vendor.mk)

# GApps: CROSSHATCH_GAPPS=full, mini (default) or none, e.g.
#   CROSSHATCH_GAPPS=none m evolution
# none is a de-Googled build (WITH_GMS=false). Same switch as sunfish; the
# other flags are stated explicitly so a diff against sunfish shows the choice.
# GApps are built in: with all four partitions on EROFS nothing can be
# flashed into them after the ROM.
CROSSHATCH_GAPPS ?= mini
ifeq ($(filter full mini none,$(CROSSHATCH_GAPPS)),)
$(error CROSSHATCH_GAPPS=$(CROSSHATCH_GAPPS): use full, mini or none)
endif
EVO_BUILD_TYPE := Unofficial
TARGET_USES_PICO_GAPPS := false
TARGET_DISABLE_EPPE := false

ifeq ($(CROSSHATCH_GAPPS),none)
WITH_GMS := false
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/apex/com.google.android.permission.apex
else
WITH_GMS := true
ifeq ($(CROSSHATCH_GAPPS),full)
TARGET_USES_MINI_GAPPS := false
else
TARGET_USES_MINI_GAPPS := true
endif
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/app/GoogleExtShared/GoogleExtShared.apk \
    system/app/GooglePrintRecommendationService/GooglePrintRecommendationService.apk \
    system/apex/com.google.android.permission.apex \
    system/etc/permissions/privapp-permissions-google.xml \
    system/etc/permissions/privapp_allowlist_com.google.android.ext.services.xml \
    system/priv-app/GoogleExtServices/GoogleExtServices.apk \
    system/priv-app/DocumentsUIGoogle/DocumentsUIGoogle.apk \
    system/priv-app/TagGoogle/TagGoogle.apk \
    system/priv-app/GooglePackageInstaller/GooglePackageInstaller.apk
endif
