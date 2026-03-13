OPENCLAW_GIT_REF ?= v2026.3.11
IMAGE_TAG ?= 20260313.1
BASE_IMAGE_TAG ?= 20260312.0

build-ubu:
	docker buildx build --platform linux/amd64 --push \
		--build-arg BASE_IMAGE=registry.cn-beijing.aliyuncs.com/zexi/openclaw-base:ubu-$(OPENCLAW_GIT_REF)-$(BASE_IMAGE_TAG) \
		-t registry.cn-beijing.aliyuncs.com/zexi/openclaw:ubu-$(IMAGE_TAG) \
        -f Dockerfile.ubuntu .

build-ubu-base:
	docker buildx build --platform linux/amd64 --push \
		--build-arg OPENCLAW_GIT_REF=$(OPENCLAW_GIT_REF) \
		-t registry.cn-beijing.aliyuncs.com/zexi/openclaw-base:ubu-$(OPENCLAW_GIT_REF)-$(BASE_IMAGE_TAG) \
        -f Dockerfile.ubuntu-base .
build:
	docker buildx build --platform linux/amd64 --push \
		-t registry.cn-beijing.aliyuncs.com/zexi/openclaw:20260227.3 \
        -f Dockerfile .
