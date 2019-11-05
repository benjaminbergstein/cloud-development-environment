include ../shared.mk

DROPLET_NAME=${DEVBOX_NAME}
DROPLET_HOSTNAME=${DROPLET_NAME}.${DOMAIN}
REGION=sfo2
IMAGE=docker-18-04
SIZE ?= 1gb
VOLUME_SIZE ?= 100gb

DROPLET_CONFIG=droplets/${DROPLET_NAME}.json
SSH_KEY_CONFIG=ssh-keys/${DROPLET_NAME}.json
VOLUME_CONFIG=volumes/${DROPLET_NAME}.json

SSH_KEY_LOCATION=~/.ssh/${DROPLET_NAME}
SSH_PASS ?= ""
ENCRYPTED_SSH_KEY ?= true
SNAPSHOT_NAME ?= $$(date +"%F")_${DROPLET_NAME}

PORT ?= 80

ifeq ($(ENCRYPTED_SSH_KEY),true)
define SETUP_DEPS
files/private.key
endef
else
define SETUP_DEPS
endef
endif

define DOCTL_CMD
doctl --output json
endef

define PWD
$$(pwd)
endef

define GET_CONFIG
${MAKE} -C ../config parse
endef

define GET_DROPLET_CONFIG
CONFIG_FILE=${PWD}/${DROPLET_CONFIG} ${GET_CONFIG}
endef

define DROPLET_ID
$$(KEY='.[0].id' ${GET_DROPLET_CONFIG})
endef

define DROPLET_IP
$$(KEY='.[0].networks.v4[0].ip_address' ${GET_DROPLET_CONFIG})
endef

define SSH_KEY_ID
$$(KEY='.[0].id' CONFIG_FILE=${PWD}/${SSH_KEY_CONFIG} ${GET_CONFIG})
endef

define VOLUME_ID
$$(KEY='.[0].id' CONFIG_FILE=${PWD}/${VOLUME_CONFIG} ${GET_CONFIG})
endef

define SSH_CMD
ssh -i ${SSH_KEY_LOCATION} root@${DROPLET_IP}
endef

.PHONY: ${DROPLET_CONFIG}

${SSH_KEY_LOCATION}:
	ssh-keygen -t rsa -b 4096 -f $@ -P ${SSH_PASS}

files/private.key:
	gpg --export-secret-key -a ${GPG_USER} 1> $@ 2>> error.log

deploy-ssh-key: ${SSH_KEY_LOCATION}
	${DOCTL_CMD} compute ssh-key create ${DROPLET_NAME} \
		--public-key "$$(cat ${SSH_KEY_LOCATION}.pub)" \
		1> ssh-keys/${DROPLET_NAME}.json 2>> error.log

deploy-dns:
	HOSTNAME=${DROPLET_NAME} SERVER_IP=${DROPLET_IP} ${MAKE} -C ../name.com deploy-record
	HOSTNAME='*.${DROPLET_NAME}' SERVER_IP=${DROPLET_IP} ${MAKE} -C ../name.com deploy-record

destroy-dns:
	HOSTNAME=${DROPLET_NAME} SERVER_IP=${DROPLET_IP} ${MAKE} -C ../name.com destroy-record
	HOSTNAME='*.${DROPLET_NAME}' SERVER_IP=${DROPLET_IP} ${MAKE} -C ../name.com destroy-record

destroy-ssh-key: ${SSH_KEY_LOCATION}
	${DOCTL_CMD} compute ssh-key delete ${SSH_KEY_ID}
	rm ssh-keys/${DROPLET_NAME}.json

deploy-droplet:
	${DOCTL_CMD} compute droplet create ${DROPLET_NAME} \
		--ssh-keys ${SSH_KEY_ID} \
		--region ${REGION} \
		--image=${IMAGE} \
		--size=${SIZE} > ${DROPLET_CONFIG}

deploy-volume:
	${DOCTL_CMD} compute volume create ${DROPLET_NAME}-volume \
		--region ${REGION} \
		--fs-type ext4 \
		--size=${VOLUME_SIZE} > ${VOLUME_CONFIG}
	${DOCTL_CMD} compute volume-action attach ${VOLUME_ID} ${DROPLET_ID}

destroy-volume:
	${DOCTL_CMD} compute volume-action detach --wait ${VOLUME_ID} ${DROPLET_ID}
	${DOCTL_CMD} compute volume delete ${VOLUME_ID}

destroy-droplet:
	${DOCTL_CMD} compute droplet delete ${DROPLET_ID}
	rm ${DROPLET_CONFIG}

deploy: check deploy-ssh-key deploy-droplet
destroy: destroy-dns destroy-droplet destroy-ssh-key

console:
	${SSH_CMD}

upload:
	cd uploads && zip ../uploads.zip -r .
	scp -i ${SSH_KEY_LOCATION} ./uploads.zip root@${DROPLET_IP}:uploads.zip
	${SSH_CMD} unzip uploads.zip
	${SSH_CMD} rm uploads.zip
	rm ./uploads.zip

setup: ${SETUP_DEPS} deploy-dns
	${SSH_CMD} apt-get install unzip
	echo "export HOSTNAME=${DROPLET_HOSTNAME}" > files/meta.bash
	cd files && zip ../files.zip -r .
	scp -i ${SSH_KEY_LOCATION} ./files.zip root@${DROPLET_IP}:files.zip
	${SSH_CMD} unzip files.zip
	${SSH_CMD} -t /bin/bash setup.sh
	rm files/meta.bash
	rm files.zip

check:
	if [ -f ${DROPLET_CONFIG} ]; then exit 1; fi

${DROPLET_CONFIG}:
	${DOCTL_CMD} compute droplet get ${DROPLET_ID} > $@

update: ${DROPLET_CONFIG}
	cat $<

create-snapshot:
	${DOCTL_CMD} compute droplet-action snapshot ${DROPLET_ID} \
		--snapshot-name ${SNAPSHOT_NAME}

browse:
	open http://${DROPLET_HOSTNAME}:${PORT}

clean:
	-rm files/private.key
	-rm files.zip
