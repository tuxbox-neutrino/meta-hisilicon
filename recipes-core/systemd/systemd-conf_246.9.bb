SUMMARY = "Systemd system configuration"
DESCRIPTION = "Systemd may require slightly different configuration for \
different machines.  For example, qemu machines require a longer \
DefaultTimeoutStartSec setting."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
    file://journald.conf \
    file://logind.conf \
    file://system.conf \
    file://system.conf-qemuall \
    file://wired.network \
"

do_install() {
	install -D -m0644 ${WORKDIR}/journald.conf ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf
	install -D -m0644 ${WORKDIR}/logind.conf ${D}${systemd_unitdir}/logind.conf.d/00-${PN}.conf
	install -D -m0644 ${WORKDIR}/system.conf ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
	install -D -m0644 ${WORKDIR}/wired.network ${D}${systemd_unitdir}/network/80-wired.network
}

# Based on change from YP bug 8141, OE commit 5196d7bacaef1076c361adaa2867be31759c1b52
do_install:append_qemuall() {
	install -D -m0644 ${WORKDIR}/system.conf-qemuall ${D}${systemd_unitdir}/system.conf.d/01-${PN}.conf

	# Do not install wired.network for qemu bsps
	rm -rf ${D}${systemd_unitdir}/network
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} = "\
    ${systemd_unitdir}/journald.conf.d/ \
    ${systemd_unitdir}/logind.conf.d/ \
    ${systemd_unitdir}/system.conf.d/ \
    ${systemd_unitdir}/network/ \
"
