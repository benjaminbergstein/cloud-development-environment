export BASE_DIR=../..
include ${BASE_DIR}/shared.mk

VOLUME_SIZE ?= 100gb

deploy:
	${DOCTL_CMD} compute volume create ${DROPLET_NAME}-volume \
		--region ${REGION} \
		--fs-type ext4 \
		--size=${VOLUME_SIZE} > ${VOLUME_CONFIG}

attach:
	${DOCTL_CMD} compute volume-action attach ${VOLUME_ID} ${DROPLET_ID}

snapshot:
	${DOCTL_CMD} compute volume snapshot ${VOLUME_ID} \
		--snapshot-name ${SNAPSHOT_NAME}_volume

detach:
	${DOCTL_CMD} compute volume-action detach --wait ${VOLUME_ID} ${DROPLET_ID}

destroy:
	${DOCTL_CMD} compute volume delete ${VOLUME_ID}
