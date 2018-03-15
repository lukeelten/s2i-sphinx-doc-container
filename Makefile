
IMAGE_NAME = iconoeugen/s2i-sphinx-doc

build:
	docker build --build-arg HTTP_PROXY="${http_proxy}" --build-arg HTTPS_PROXY="${https_proxy}" --build-arg NO_PROXY="${no_proxy}" -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
