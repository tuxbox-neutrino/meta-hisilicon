SUMMARY = "Hardware drivers for ${MACHINE_DRIVER}"
SECTION = "base"
PRIORITY = "required"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"

PV = "${KV}+${SRCDATE}"
PR = "r0"
inherit module
SRC_URI = "https://source.mynonpublic.com/gfutures/${MACHINE_DRIVER}-drivers-${KV}-${SRCDATE}.zip \
	   file://license \
"
S = "${WORKDIR}"

INHIBIT_PACKAGE_STRIP = "1"

do_compile() {
}
do_populate_sysroot() {
}

do_install() {
	install -d ${D}/lib/modules/${KV}/extra
	install -d ${D}/${sysconfdir}/modules-load.d
	for i in ${MACHINE}_1 ${MACHINE}_2 ${MACHINE}_3 ${MACHINE}_4; do
		install -m 0755 ${WORKDIR}/$i.ko ${D}/lib/modules/${KV}/extra
		echo $i >> ${D}/${sysconfdir}/modules-load.d/${MACHINE}.conf
	done
}

FILES_${PN} += "${sysconfdir}/modules-load.d/${MACHINE}.conf"

