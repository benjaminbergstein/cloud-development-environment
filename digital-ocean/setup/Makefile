export BASE_DIR=../..
include ${BASE_DIR}/shared.mk
ENCRYPTED_SSH_KEY ?= true

ifeq ($(ENCRYPTED_SSH_KEY),true)
define SETUP_DEPS
${DATA_DIR}/setup/private.key
endef
else
define SETUP_DEPS
skip
endef
endif

default: setup

console:
	${SSH_CMD}

upload:
	cd uploads && zip ../uploads.zip -r .
	scp -i ${SSH_KEY_LOCATION} ./uploads.zip root@${DROPLET_IP}:uploads.zip
	${SSH_CMD} unzip uploads.zip
	${SSH_CMD} rm uploads.zip
	rm ./uploads.zip

download-%:
	scp -i ${SSH_KEY_LOCATION} root@${DROPLET_IP}:$* ./downloads/$*

${DATA_DIR}/setup/private.key:
	gpg --export-secret-key -a ${GPG_USER} 1> $@ 2>> error.log

skip:

setup:
	${MAKE} -C ${BASE_DIR} deploy-dns
	${SSH_CMD} apt-get install unzip
	cp -r ${BOX_CONFIG_FILES} ${DATA_DIR}/setup/
	echo "export HOSTNAME=${DROPLET_HOSTNAME}" > ${DATA_DIR}/setup/meta.bash
	cp ./setup.sh ${DATA_DIR}/setup/
	${MAKE} ${SETUP_DEPS}
	cd ${DATA_DIR}/setup && zip ../setup.zip -r .
	scp -i ${SSH_KEY_LOCATION} ${DATA_DIR}/setup.zip root@${DROPLET_IP}:setup.zip
	${SSH_CMD} unzip setup.zip
	${SSH_CMD} -t /bin/bash setup.sh
	rm ${DATA_DIR}/setup/meta.bash
	rm ${DATA_DIR}/setup.zip

browse:
	open http://${DROPLET_HOSTNAME}:${PORT}

clean:
	-rm ${DATA_DIR}/setup/private.key
	-rm ${DATA_DIR}/setup.zip
