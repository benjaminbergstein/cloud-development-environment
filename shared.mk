BASE_DIR ?= .
DEVBOX_NAME ?= dev-2
DOMAIN ?= wips.link
DROPLET_NAME=${DEVBOX_NAME}
SNAPSHOT_NAME ?= $$(date +"%F")_${DROPLET_NAME}

DROPLET_CONFIG=${BASE_DIR}/droplets/${DROPLET_NAME}.json
SSH_KEY_CONFIG=${BASE_DIR}/ssh-keys/${DROPLET_NAME}.json
VOLUME_CONFIG=${BASE_DIR}/volumes/${DROPLET_NAME}.json

define DROPLET_IP
$$(KEY='.[0].networks.v4[0].ip_address' ${GET_DROPLET_CONFIG})
endef

SSH_KEY_LOCATION=~/.ssh/${DROPLET_NAME}
SSH_PASS ?= ""

define DOCTL_CMD
doctl --output json
endef

define PWD
$$(pwd)
endef

define GET_CONFIG
${MAKE} -C ../${BASE_DIR}/config parse
endef

define SSH_KEY_ID
$$(KEY='.[0].id' CONFIG_FILE=${PWD}/${SSH_KEY_CONFIG} ${GET_CONFIG})
endef

define SSH_CMD
ssh -i ${SSH_KEY_LOCATION} root@${DROPLET_IP}
endef

define GET_DROPLET_CONFIG
CONFIG_FILE=${PWD}/${DROPLET_CONFIG} ${GET_CONFIG}
endef

define DROPLET_ID
$$(KEY='.[0].id' ${GET_DROPLET_CONFIG})
endef

define VOLUME_ID
$$(KEY='.[0].id' CONFIG_FILE=${PWD}/${VOLUME_CONFIG} ${GET_CONFIG})
endef
