export BASE_DIR=../..
include ${BASE_DIR}/shared.mk

.PHONY: ${DROPLET_CONFIG}

REGION=sfo2
IMAGE=docker-18-04
SIZE ?= 1gb

deploy:
	${DOCTL_CMD} compute droplet create ${ENVIRONMENT} \
		--ssh-keys ${SSH_KEY_ID} \
		--region ${REGION} \
		--image=${IMAGE} \
		--size=${SIZE} > ${DROPLET_CONFIG}

destroy:
	${DOCTL_CMD} compute droplet delete ${DROPLET_ID}
	rm ${DROPLET_CONFIG}

${DROPLET_CONFIG}:
	${DOCTL_CMD} compute droplet get ${DROPLET_ID} > $@

update: ${DROPLET_CONFIG}
	cat $<

snapshot:
	${DOCTL_CMD} compute droplet-action snapshot ${DROPLET_ID} \
		--snapshot-name ${SNAPSHOT_NAME}

shutdown:
	-${SSH_CMD} sudo shutdown -h now

freeze: shutdown create-snapshot

list-snapshots:
	${DOCTL_CMD} compute droplet snapshots ${DROPLET_ID}
