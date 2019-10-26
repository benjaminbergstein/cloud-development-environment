DROPLET_NAME ?= dev-1
DROPLET_INFO_FILE=droplets/${DROPLET_NAME}.json
REGION=sfo2
IMAGE=docker-18-04
SIZE ?= 1gb

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

define JQ
jq --raw-output
endef

define INSTANCE_ID
$$(cat ${DROPLET_INFO_FILE} | ${JQ} '.[0].id')
endef

define INSTANCE_IP
$$(cat ${DROPLET_INFO_FILE} | ${JQ} '.[0].networks.v4[0].ip_address')
endef

define SSH_KEY_ID
$$(cat ssh-keys/${DROPLET_NAME}.json | ${JQ} '.[0].id')
endef

define SSH_CMD
ssh -i ${SSH_KEY_LOCATION} root@${INSTANCE_IP}
endef

.PHONY: ${DROPLET_INFO_FILE}

${SSH_KEY_LOCATION}:
	ssh-keygen -t rsa -b 4096 -f $@ -P ${SSH_PASS}

files/private.key:
	gpg --export-secret-key -a ${GPG_USER} 1> $@ 2>> error.log

deploy-ssh-key: ${SSH_KEY_LOCATION}
	${DOCTL_CMD} compute ssh-key create ${DROPLET_NAME} \
		--public-key "$$(cat ${SSH_KEY_LOCATION}.pub)" \
		1> ssh-keys/${DROPLET_NAME}.json 2>> error.log

destroy-ssh-key: ${SSH_KEY_LOCATION}
	${DOCTL_CMD} compute ssh-key delete ${SSH_KEY_ID}
	rm ssh-keys/${DROPLET_NAME}.json

deploy-droplet:
	${DOCTL_CMD} compute droplet create ${DROPLET_NAME} \
		--ssh-keys ${SSH_KEY_ID} \
		--region ${REGION} \
		--image=${IMAGE} \
		--size=${SIZE} > ${DROPLET_INFO_FILE}

destroy-droplet:
	${DOCTL_CMD} compute droplet delete ${INSTANCE_ID}
	rm ${DROPLET_INFO_FILE}

deploy: check deploy-ssh-key deploy-droplet
destroy: destroy-droplet destroy-ssh-key

console:
	${SSH_CMD}

upload:
	cd uploads && zip ../uploads.zip -r .
	scp -i ${SSH_KEY_LOCATION} ./uploads.zip root@${INSTANCE_IP}:uploads.zip
	${SSH_CMD} unzip uploads.zip
	${SSH_CMD} rm uploads.zip
	rm ./uploads.zip

setup: ${SETUP_DEPS}
	${SSH_CMD} apt-get install unzip
	cd files && zip ../files.zip -r .
	scp -i ${SSH_KEY_LOCATION} ./files.zip root@${INSTANCE_IP}:files.zip
	${SSH_CMD} unzip files.zip
	${SSH_CMD} -t /bin/bash setup.sh
	rm files.zip

check:
	if [ -f ${DROPLET_INFO_FILE} ]; then exit 1; fi

${DROPLET_INFO_FILE}:
	${DOCTL_CMD} compute droplet get ${INSTANCE_ID} > $@

update: ${DROPLET_INFO_FILE}
	cat $<

create-snapshot:
	${DOCTL_CMD} compute droplet-action snapshot ${INSTANCE_ID} \
		--snapshot-name ${SNAPSHOT_NAME}

browse:
	open http://${INSTANCE_IP}:${PORT}

clean:
	-rm files/private.key
	-rm files.zip
