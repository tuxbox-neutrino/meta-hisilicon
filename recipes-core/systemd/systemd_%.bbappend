FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS:append += "glib-2.0"

SRC_URI:append += "file://00-create-volatile.conf \
		   file://etc.conf \
		   file://network.target \
		   file://getty@.service \
"

PACKAGECONFIG_remove = "networkd resolved nss-resolve"

do_install:append() {
	install -m 0644 ${WORKDIR}/etc.conf ${D}${libdir}/tmpfiles.d/etc.conf
	rm -r ${D}${sysconfdir}/resolv-conf.systemd 
	rm -r ${D}${sysconfdir}/systemd/logind.conf
	rm -r ${D}${sysconfdir}/systemd/journald.conf
        install -m 644 ${WORKDIR}/network.target ${D}${systemd_unitdir}/system
        install -m 644 ${WORKDIR}/getty@.service ${D}${systemd_unitdir}/system
	rm -fR ${D}${sysconfdir}/systemd/system/getty.target.wants
# FIXME: The next step is disabled because 'init' is getting stuck here.
#	rm -fR ${D}/lib/systemd/system/multi-user.target.wants/getty.target
	rm -fR ${D}/lib/systemd/system/sysinit.target.wants/systemd-udev-trigger.service
	rm -fR ${D}/lib/systemd/system/sockets.target.wants/systemd-udevd-*
	rm -fR ${D}/lib/systemd/system/sysinit.target.wants/systemd-udevd.service
}

ALTERNATIVE_${PN} = "halt reboot shutdown poweroff runlevel"

pkg_postinst_ontarget_udev-hwdb () {
		udevadm hwdb --update
}
