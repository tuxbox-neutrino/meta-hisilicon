FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append += "file://smb.conf \
"

do_install:append() {
	install -m 644 ${WORKDIR}/smb.conf ${D}${sysconfdir}/samba/
	sed -i "s|COOLSTREAM|${MACHINE}|" ${D}${sysconfdir}/samba/smb.conf
}

