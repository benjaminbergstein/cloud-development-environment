export BASE_DIR=..
include ${BASE_DIR}/shared.mk

PLUGINS_KEY='.plugins | join(" ")'
PLUGINS := $(shell KEY=${PLUGINS_KEY} ${GET_USER_CONFIG})

before-setup: $(addprefix before-setup-,${PLUGINS})

before-setup-%:
	${MAKE} -C ../$* before-setup

after-destroy: $(addprefix after-destroy-,${PLUGINS})

after-destroy-%:
	${MAKE} -C ../$* after-destroy
