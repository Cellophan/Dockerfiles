REGISTRY=docker.outer.systems/cell
CONTEXT=$(abspath $(shell pwd))
IMAGE=$(notdir ${CONTEXT})
BLAH=${CONTEXT}

.PHONY: build

build:
	docker build -t ${REGISTRY}/${IMAGE} ${CONTEXT}

push:
	docker push ${REGISTRY}/${IMAGE}
