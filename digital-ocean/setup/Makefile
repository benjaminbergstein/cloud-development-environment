export BASE_DIR=..
include ../${BASE_DIR}/shared.mk
ENCRYPTED_SSH_KEY ?= true

ifeq ($(ENCRYPTED_SSH_KEY),true)
define SETUP_DEPS
files/private.key
endef
else
define SETUP_DEPS
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

files/private.key:
	gpg --export-secret-key -a ${GPG_USER} 1> $@ 2>> error.log

setup: ${SETUP_DEPS}
	${MAKE} -C ${BASE_DIR} deploy-dns
	${SSH_CMD} apt-get install unzip
	echo "export HOSTNAME=${DROPLET_HOSTNAME}" > files/meta.bash
	cd files && zip ../files.zip -r .
	scp -i ${SSH_KEY_LOCATION} ./files.zip root@${DROPLET_IP}:files.zip
	${SSH_CMD} unzip files.zip
	${SSH_CMD} -t /bin/bash setup.sh
	rm files/meta.bash
	rm files.zip

browse:
	open http://${DROPLET_HOSTNAME}:${PORT}

clean:
	-rm files/private.key
	-rm files.zip
