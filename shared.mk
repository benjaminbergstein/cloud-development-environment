BASE_DIR ?= .
ENVIRONMENT ?= dev-2
DOMAIN ?= $(shell KEY='.domainName' ${GET_USER_CONFIG})
DROPLET_NAME=${ENVIRONMENT}
SNAPSHOT_NAME ?= $$(date +"%F")_${DROPLET_NAME}
REGION=sfo2

BOX_CONFIG_DIR ?= ${HOME}/.cloud-development-environment
BOX_CONFIG_FILE ?= ${BOX_CONFIG_DIR}/config.json
BOX_CONFIG_FILES ?= ${BOX_CONFIG_DIR}/files

DO_DIR=${BASE_DIR}/digital-ocean
DATA_KEY ?= ${ENVIRONMENT}
BOX_DATA_DIR=${BASE_DIR}/data/environments
DATA_DIR ?= ${BOX_DATA_DIR}/${DATA_KEY}
DROPLET_CONFIG=${DATA_DIR}/droplets/${DROPLET_NAME}.json
SSH_KEY_CONFIG=${DATA_DIR}/ssh-keys/${DROPLET_NAME}.json
VOLUME_CONFIG=${DATA_DIR}/volumes/${DROPLET_NAME}.json

define DROPLET_IP
$$(KEY='.[0].networks.v4[0].ip_address' ${GET_DROPLET_CONFIG})
endef

SSH_BASE ?= ~/.ssh
SSH_KEY_LOCATION=${SSH_BASE}/${DROPLET_NAME}
SSH_PASS ?= ""

define DOCTL_CMD
doctl --output json
endef

define PWD
$$(pwd)
endef

define GET_CONFIG
${MAKE} -C ${BASE_DIR}/config parse
endef

define GET_USER_CONFIG
CONFIG_FILE=${BOX_CONFIG_FILE} ${GET_CONFIG}
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
