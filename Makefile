include ./shared.mk

install:
	mkdir ${BOX_CONFIG_DIR}
	echo '{"encryption": false, "plugins": []}' > ${BOX_CONFIG_FILE}
	mkdir ${BOX_CONFIG_FILES}
	echo "" > ${BOX_CONFIG_FILES}/repos.txt
	@echo ""
	@echo "Setup complete!"
	@echo "Copy any files you want uploaded to your environment to ${BOX_CONFIG_FILES}"
	@echo "Your github private key goes in ${BOX_CONFIG_FILES}/id_rsa"
	@echo "Add the URL for any repositories you want cloned to ${BOX_CONFIG_FILES}/repos.txt"

%:
	make -C digital-ocean $*
