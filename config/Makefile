define JQ
jq --raw-output
endef

parse:
	@echo $$(cat ${CONFIG_FILE} | ${JQ} '${KEY}')
