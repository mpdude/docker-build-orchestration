export HOST_UID=$(shell id -u)

.DEFAULT_GOAL: example

ENV ?= development

DOCKER_COMPOSE = docker-compose -f docker/environment/$(ENV)/docker-compose.yml

.PHONY: up
up: vendor/composer/installed.json
	$(DOCKER_COMPOSE) up

vendor/composer/installed.json: composer.json composer.lock docker/service/app/development/.built
	$(DOCKER_COMPOSE) run --rm app composer install

docker/service/app/development/.built: docker/service/app/development/Dockerfile docker/service/app/base/.built
	docker build $(@D) -t mpdude/orchestration-app:development
	touch $@

docker/service/app/base/.built:docker/service/app/base/Dockerfile
	docker build $(@D) -t mpdude/orchestration-app:base
	touch $@
