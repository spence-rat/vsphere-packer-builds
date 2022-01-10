.PHONY: packer_init packer_validate

#HTTP_IP := $(shell ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

packer_init:
	docker run \
		-v ${CURDIR}/$(build):/workspace/$(build) \
		-v ${CURDIR}:/workspace \
		-w /workspace/$(build) \
		-e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins/ \
		hashicorp/packer:latest \
		init .

packer_build:
	docker run \
		-v ${CURDIR}/$(build):/workspace/$(build) \
		-v ${CURDIR}:/workspace \
		-p 8000-8010:8000-8010 \
		-w /workspace/$(build) \
		-e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins/ \
		hashicorp/packer:latest \
		build -var-file="../vsphere-prod.pkrvars.hcl" -var-file="../common.pkrvars.hcl"  .