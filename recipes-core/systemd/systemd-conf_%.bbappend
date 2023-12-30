FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append += "file://logind.conf \
                   file://journald.conf \
"

do_install:append() {
	install -d ${D}/etc/systemd
        install -m 0644 ${WORKDIR}/logind.conf ${D}/etc/systemd/
        install -m 0644 ${WORKDIR}/journald.conf ${D}/etc/systemd/
}

FILES_${PN} = "/etc \
	       /lib \
"
