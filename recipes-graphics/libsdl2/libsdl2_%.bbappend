FILESEXTRAPATHS:prepend := "${THISDIR}/libsdl2:"

DEPENDS += "virtual/libgles2"

SRC_URI += "file://0001-add-mali-fb-video-support.patch"

EXTRA_OECONF += " \
	--enable-video-mali \
"

PACKAGECONFIG += "alsa arm-neon gles2 pulseaudio"

