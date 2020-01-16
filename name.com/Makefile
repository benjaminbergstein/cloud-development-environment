BASE_DIR=..
include ${BASE_DIR}/shared.mk

NAME_USER ?= bennyjbergstein@gmail.com
NAME_ENDPOINT ?= https://api.name.com
HOSTNAME ?= ${DEVBOX_NAME}
RECORD_INFO_FILE = ${DATA_DIR}/records/${HOSTNAME}.json
TTL ?= 30

define RECORDS_ENDPOINT
${NAME_ENDPOINT}/v4/domains/${DOMAIN}/records
endef

define AUTH_HEADER
${NAME_USER}:${NAME_API_TOKEN}
endef

ifeq ("${HOSTNAME}","-")
define RECORD_BODY
{"host":"","type":"A","answer":"${SERVER_IP}","ttl":${TTL}}
endef
else
ifeq ("${HOSTNAME}","*.-")
define RECORD_BODY
{"host":"*","type":"A","answer":"${SERVER_IP}","ttl":${TTL}}
endef
else
define RECORD_BODY
{"host":"${HOSTNAME}","type":"A","answer":"${SERVER_IP}","ttl":${TTL}}
endef
endif
endif

define RECORD_ID
$$(cat ${RECORD_INFO_FILE} | jq --raw-output '.id')
endef

deploy-record:
	curl -u '${AUTH_HEADER}' \
	  '${RECORDS_ENDPOINT}' \
	  -X POST --data '${RECORD_BODY}' \
	  > ${RECORD_INFO_FILE}

list-records:
	curl -u '${AUTH_HEADER}' \
	  '${RECORDS_ENDPOINT}'

destroy-record:
	curl -u '${AUTH_HEADER}' \
	  "${RECORDS_ENDPOINT}/${RECORD_ID}" \
	  -X DELETE
	rm ${RECORD_INFO_FILE}
