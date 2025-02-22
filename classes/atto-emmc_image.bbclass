inherit image_types

IMAGE_TYPEDEP:attoemmc = "ext4"

do_image_attoemmc[depends]  = " \
    parted-native:do_populate_sysroot \
    dosfstools-native:do_populate_sysroot \
    mtools-native:do_populate_sysroot \
    virtual/kernel:do_populate_sysroot \
    "

GPT_OFFSET = "0"
GPT_SIZE = "1024"

ROOTFS_PARTITION_OFFSET = "$(expr ${GPT_OFFSET} \+ ${GPT_SIZE})"
ROOTFS_PARTITION_SIZE = "1048576"

EMMC_IMAGE = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.emmc.img"
EMMC_IMAGE_SIZE = "3817472"

IMAGE_CMD:attoemmc () {
    dd if=/dev/zero of=${EMMC_IMAGE} bs=1024 count=0 seek=${EMMC_IMAGE_SIZE}
    parted -s ${EMMC_IMAGE} mklabel gpt
    parted -s ${EMMC_IMAGE} unit KiB mkpart rootfs1 ext2 ${ROOTFS_PARTITION_OFFSET} $(expr ${ROOTFS_PARTITION_OFFSET} \+ ${ROOTFS_PARTITION_SIZE})
    dd if=${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.ext4 of=${EMMC_IMAGE} bs=1024 seek=${ROOTFS_PARTITION_OFFSET}
}
