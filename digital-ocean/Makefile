BASE_DIR=..
include ${BASE_DIR}/shared.mk

SETUP_DIRS=droplets records ssh-keys downloads uploads

.PHONY: setup

${SSH_KEY_LOCATION}:
	ssh-keygen -t rsa -b 4096 -f $@ -P ${SSH_PASS}

create: init deploy

init:
	mkdir ${DATA_DIR}
	cd ${DATA_DIR} && mkdir ${SETUP_DIRS}

clean:
	rm -rf ${DATA_DIR}

deploy: check deploy-ssh-key deploy-droplet

deploy-ssh-key: ${SSH_KEY_LOCATION}
	${DOCTL_CMD} compute ssh-key create ${DROPLET_NAME} \
		--public-key "$$(cat ${SSH_KEY_LOCATION}.pub)" \
		1> ${SSH_KEY_CONFIG} 2>> error.log

deploy-droplet:
	${MAKE} -C droplets

destroy: destroy-droplet destroy-ssh-key destroy-plugins

destroy-ssh-key: ${SSH_KEY_LOCATION}
	${DOCTL_CMD} compute ssh-key delete ${SSH_KEY_ID}
	-rm ssh-keys/${DROPLET_NAME}.json

destroy-droplet:
	${MAKE} -C droplets destroy

destroy-plugins:
	${MAKE} -C ../plugin after-destroy

update:
	${MAKE} -C droplets update

check:
	if [ -f ${DROPLET_CONFIG} ]; then exit 1; fi

which:
	@echo ${ENVIRONMENT}

setup:
	${MAKE} -C setup

console:
	${MAKE} -C setup $@

upload:
	${MAKE} -C setup $@
