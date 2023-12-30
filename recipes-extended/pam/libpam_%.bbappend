do_install:append() {
	if [ "${MACHINE}" = "hd60" ] || [ "${MACHINE}" = "hd61" ]; then
		echo "QT_QPA_EGLFS_INTEGRATION=eglfs_mali" >> ${D}${sysconfdir}/environment
	fi
}
