FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append += " \
           file://create_etc.sh \
           file://update_etc.sh \
"


do_configure:prepend () {
        sed -i "s|GIT_USER|${GIT_USER}|" ${WORKDIR}/update_etc.sh
        sed -i "s|MAIL|${MAIL}|" ${WORKDIR}/update_etc.sh
        sed -i "s|GIT_USER|${GIT_USER}|" ${WORKDIR}/create_etc.sh
        sed -i "s|MAIL|${MAIL}|" ${WORKDIR}/create_etc.sh
}

do_install:append () {
        install -m 755 ${WORKDIR}/update_etc.sh ${D}/etc/etckeeper/update_etc.sh
        install -m 755 ${WORKDIR}/create_etc.sh ${D}/etc/etckeeper/create_etc.sh
}
