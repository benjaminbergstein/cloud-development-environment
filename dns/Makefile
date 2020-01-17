export BASE_DIR=..
include ${BASE_DIR}/shared.mk

DNS_PROVIDER=$$(KEY='.dnsProvider' ${GET_USER_CONFIG})
MAKE_DNS=${MAKE} -C ${BASE_DIR}/${DNS_PROVIDER}
SUBDOMAIN_NAME ?= ${DROPLET_NAME}

before-setup: deploy-dns
deploy-dns:
	HOSTNAME=${SUBDOMAIN_NAME} SERVER_IP=${DROPLET_IP} ${MAKE_DNS} deploy-record
	HOSTNAME='*.${SUBDOMAIN_NAME}' SERVER_IP=${DROPLET_IP} ${MAKE_DNS} deploy-record

after-destroy: destroy-dns
destroy-dns:
	HOSTNAME=${SUBDOMAIN_NAME} SERVER_IP=${DROPLET_IP} ${MAKE_DNS} destroy-record
	HOSTNAME='*.${SUBDOMAIN_NAME}' SERVER_IP=${DROPLET_IP} ${MAKE_DNS} destroy-record
