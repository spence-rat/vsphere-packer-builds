.PHONY: packer_init

packer_init:
	docker run \
		-v $(CURDIR):/packer \
		-v $(build):/packer \
		hashicorp/packer:latest \
		init .

