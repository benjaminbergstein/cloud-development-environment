BASE_DIR=..
include ${BASE_DIR}/shared.mk

SUBDOMAIN_NAME ?= ${DROPLET_NAME}
DROPLET_HOSTNAME=${DROPLET_NAME}.${DOMAIN}
REGION=sfo2
IMAGE=docker-18-04
SIZE ?= 1gb
VOLUME_SIZE ?= 100gb

SETUP_DIRS=droplets records ssh-keys downloads uploads
PORT ?= 80

.PHONY: ${DROPLET_CONFIG} setup

${SSH_KEY_LOCATION}:
	ssh-keygen -t rsa -b 4096 -f $@ -P ${SSH_PASS}

deploy-ssh-key: ${SSH_KEY_LOCATION}
	${DOCTL_CMD} compute ssh-key create ${DROPLET_NAME} \
		--public-key "$$(cat ${SSH_KEY_LOCATION}.pub)" \
		1> ${SSH_KEY_CONFIG} 2>> error.log

deploy-dns:
	HOSTNAME=${SUBDOMAIN_NAME} SERVER_IP=${DROPLET_IP} ${MAKE} -C ../name.com deploy-record
	HOSTNAME='*.${SUBDOMAIN_NAME}' SERVER_IP=${DROPLET_IP} ${MAKE} -C ../name.com deploy-record

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

destroy-droplet:
	${DOCTL_CMD} compute droplet delete ${DROPLET_ID}
	rm ${DROPLET_CONFIG}

init:
	mkdir ${DATA_DIR}
	cd ${DATA_DIR} && mkdir ${SETUP_DIRS}

clean:
	rm -rf ${DATA_DIR}

create: init deploy
deploy: check deploy-ssh-key deploy-droplet
destroy: destroy-dns destroy-droplet destroy-ssh-key

check:
	if [ -f ${DROPLET_CONFIG} ]; then exit 1; fi

which:
	@echo ${DEVBOX_NAME}

${DROPLET_CONFIG}:
	${DOCTL_CMD} compute droplet get ${DROPLET_ID} > $@

update: ${DROPLET_CONFIG}
	cat $<

snapshot-droplet:
	${DOCTL_CMD} compute droplet-action snapshot ${DROPLET_ID} \
		--snapshot-name ${SNAPSHOT_NAME}

shutdown:
	-${SSH_CMD} sudo shutdown -h now

freeze: shutdown create-snapshot

list-snapshots:
	${DOCTL_CMD} compute droplet snapshots ${DROPLET_ID}

setup:
	${MAKE} -C setup

console:
	${MAKE} -C setup console

upload:
	${MAKE} -C setup upload
