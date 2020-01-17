export BASE_DIR=..
include ${BASE_DIR}/shared.mk

MOUNT_DIR := $(shell KEY='.mountAt' ${GET_USER_CONFIG})

before-setup: mount
mount:
	sshfs -o IdentityFile=${SSH_KEY_LOCATION} root@${DROPLET_IP}:/root ${MOUNT_DIR}

after-destroy: unmount
unmount:
	umount ${MOUNT_DIR}
