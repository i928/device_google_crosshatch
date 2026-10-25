#
# Copyright (C) 2018-2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Kernel
BOARD_KERNEL_IMAGE_NAME := Image.lz4
TARGET_COMPILE_WITH_MSM_KERNEL := true
# i928 kernel_google_msm-4.9 bka_pub (Evo msm-4.9 bka + our crosshatch work:
# KernelSU-Next + SUSFS, EROFS, Clang 23 fixes) instead of Evo's kernel_google_b1c1.
TARGET_KERNEL_CLANG_PATH := $(abspath prebuilts/clang/host/$(HOST_PREBUILT_TAG)/clang-r614150)
TARGET_KERNEL_CONFIG := b1c1_defconfig
TARGET_KERNEL_LLVM_BINUTILS := false
# ld.lld for the LTO link (Clang 23 ships no LLVMgold.so for gold). Only LD:
# LLVM_BINUTILS would also force LLVM=1 LLVM_IAS=1.
TARGET_KERNEL_ADDITIONAL_FLAGS := LD=$(TARGET_KERNEL_CLANG_PATH)/bin/ld.lld
TARGET_KERNEL_SOURCE := kernel/google/msm-4.9
TARGET_NEEDS_DTBOIMAGE := true

# Manifests
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += vendor/lineage/config/device_framework_matrix.xml

# Partitions
AB_OTA_PARTITIONS += \
    vendor
ifneq ($(PRODUCT_USE_DYNAMIC_PARTITIONS), true)
    BOARD_VENDORIMAGE_PARTITION_SIZE := 805306368
endif
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs

# Reserve space for gapps install
-include vendor/lineage/config/BoardConfigReservedSize.mk
ifneq ($(WITH_GMS),true)
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 1069547520
endif

# SELinux
BOARD_SEPOLICY_DIRS += device/google/crosshatch/sepolicy-lineage/dynamic
BOARD_SEPOLICY_DIRS += device/google/crosshatch/sepolicy-lineage/vendor

# Verified Boot
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
