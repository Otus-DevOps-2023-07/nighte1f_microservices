.PHONY: build and push conatiners
USER_NAME=nighte1f

.PHONY: all
all: build_ui build_post-py build_comment build_prometheus build_blackbox

build_ui:
	export USER_NAME=$(USER_NAME) && cd ../src/ui && bash docker_build.sh

build_post-py:
	export USER_NAME=$(USER_NAME) && cd ../src/post-py && bash docker_build.sh

build_comment:
	export USER_NAME=$(USER_NAME) && cd ../src/comment && bash docker_build.sh

build_prometheus:
	export USER_NAME=$(USER_NAME) && cd ../monitoring/prometheus && docker build -t $(USER_NAME)/prometheus .

build_blackbox:
	export USER_NAME=$(USER_NAME) && cd ../monitoring/blackbox_exporter && docker build -t $(USER_NAME)/blackbox .

.PHONY: push
push:
	docker login
	docker push $(USER_NAME)/ui
	docker push $(USER_NAME)/post
	docker push $(USER_NAME)/comment
	docker push $(USER_NAME)/prometheus
	docker push $(USER_NAME)/blackbox
