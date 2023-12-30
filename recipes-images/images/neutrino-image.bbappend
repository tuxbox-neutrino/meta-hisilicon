DEPENDS:append += " \
        gfutures-partitions-${MACHINE} \
        gfutures-bootargs-${MACHINE} \
	gfutures-recovery-${MACHINE} \
"

IMAGE_INSTALL += " \
	gfutures-dvb-modules-${MACHINE} \
	gfutures-libs-${HICHIPSET} \
	gfutures-mali-${HICHIPSET} \
	kernel-module-mali-${HICHIPSET} \
"
