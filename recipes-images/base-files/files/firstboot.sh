#!/bin/sh

echo "starting firstboot script"
echo "first" > /dev/dbox/oled0

# Path variables
USERDATA_PATH="/mnt/userdata"

# Define functions for code reuse with error handling
resize_partition() {
    if [ -b "$1" ]; then
        echo "Resizing $1 partition"

        # Execute resize2fs and store its output
        output=$(resize2fs "$1" 2>&1)
        exit_status=$?

        # Check if the output contains the specific string "Nothing to do!"
        if echo "$output" | grep -q "Nothing to do!"; then
            echo "Partition $1 has already the correct size. No changes needed."
        elif [ $exit_status -ne 0 ]; then
            echo "Error resizing partition $1: $output"
            exit 1
        fi
    fi
}

setup_partition() {
    partition_device_1="$1"
    partition_device_2="$2"

    # Check device exists
    if [ ! -b "$partition_device_1" ]; then
        echo "Device $partition_device_1 does not exist. Skipping."
        return
    fi

    if [ ! -b "$partition_device_2" ]; then
        echo "Device $partition_device_2 does not exist. Skipping comparison."
    else
        # # Check devices are identical
        if [ "$(readlink -f "$partition_device_1")" = "$(readlink -f "$partition_device_2")" ]; then
            echo "Warning: $partition_device_1 and $partition_device_2 refer to the same partition. Skipping duplicate setup."
            return
        fi
    fi

    if blkid "$1" | grep -q "ext4"; then
        resize_partition "$1"
    else
        echo "Setup userdata partition"
        mkfs.ext4 -F "$1" || { echo "Failed to format userdata partition"; exit 1; }
    fi
}

# Check and resize partitions
setup_partition "/dev/disk/by-partlabel/linuxrootfs" "/dev/disk/by-partlabel/userdata"

# # Check and create swap if required
# SWAPFILE_PATH="${USERDATA_PATH}/swapfile"
# total_ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
# if [ "$total_ram_kb" -ge 1048576 ]; then
# 	# More than 1GB RAM available, don't create swap
# 	echo "Swap creation skipped as the system has sufficient RAM (more than 1GB)."
# else
# 	# Ensure the directory for the swapfile exists
# 	if [ ! -d "${USERDATA_PATH}" ]; then
# 		echo "Creating directory for swapfile at ${USERDATA_PATH}"
# 		mkdir -p "${USERDATA_PATH}" || { echo "Failed to create directory ${USERDATA_PATH}"; exit 1; }
# 	fi
# 
# 	# Create the swapfile if it doesn't exist
# 	if [ ! -f "$SWAPFILE_PATH" ]; then
# 		echo "Creating swapfile at $SWAPFILE_PATH"
# 		dd if=/dev/zero of="$SWAPFILE_PATH" bs=1024 count=204800 || { echo "Failed to create swapfile"; exit 1; }
# 		chmod 600 "$SWAPFILE_PATH" || { echo "Failed to set permissions on swapfile"; exit 1; }
# 		mkswap "$SWAPFILE_PATH" || { echo "Failed to set up swap space on $SWAPFILE_PATH"; exit 1; }
# 	fi
# 
# 	# Activate the swapfile if it's not already active
# 	if ! grep -q "$SWAPFILE_PATH" /proc/swaps; then
# 		echo "Activating swapfile $SWAPFILE_PATH"
# 		swapon "$SWAPFILE_PATH" || { echo "Failed to activate swapfile"; exit 1; }
# 	fi
# 
# 	# Activate swapfile if not already and add it to fstab if not present
# 	if ! grep -q "$SWAPFILE_PATH" /etc/fstab; then
# 		echo "$SWAPFILE_PATH none swap defaults 0 0" >> /etc/fstab || { echo "Failed to add swapfile to fstab"; exit 1; }
# 	fi
# fi

box_model=$(grep "^box_model=" /etc/image-version | cut -d'=' -f2)
hwaddr=$(ifconfig eth0 | awk '/HWaddr/ { split($5, v, ":"); print v[5] v[6] }')
hname="${box_model}-${hwaddr}"
echo "${hname}" > /etc/hostname
hostname "${hname}" || { echo "Failed to set hostname"; exit 1; }

echo > /dev/dbox/oled0

# Update etckeeper if available, if yes then init etckeeper
if [ -f /usr/bin/etckeeper ]; then
	/etc/etckeeper/update_etc.sh || { echo "Warning: etckeeper update failed"; }
else
	echo "Note: etckeeper not available"
fi


echo "first boot script work done"

# Job done, remove it from systemd services
echo "disable firstboot.service"
systemctl disable firstboot || { echo "Failed to disable firstboot service"; exit 1; }
systemctl stop firstboot || { echo "Failed to stop firstboot service"; exit 1; }

# Required for clean init
exit 0
