PROJECT_NAME := $(PROJECT_NAME)
SHELL := /bin/bash

define run_in_workspace
	cd ./build && docker-compose exec -T --user www-data php-fpm /bin/bash -c "cd /php && $(1)"
endef

define run_in_workspace_as_root
	cd ./build && docker-compose exec -T --user root php-fpm /bin/bash -c "cd /php && $(1)"
endef

.PHONY: help
help: ## Show help
	@IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
    for help_line in $${help_lines[@]}; do \
        IFS=$$'#' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        printf "%-30s %s\n" $$help_command $$help_info ; \
    done

.PHONY: setup
setup: ## Setup the system locally
	$(MAKE) start
	$(call run_in_workspace,composer global require hirak/prestissimo)
	$(call run_in_workspace,COMPOSER_MEMORY_LIMIT=-1 composer install --no-scripts)
	$(call run_in_workspace,/php/vendor/bin/pimcore-install --no-interaction --ignore-existing-config)
	$(call run_in_workspace,yarn install)

.PHONY: start
start: ## Execute this command to start the docker containers
	cd build && docker-compose up -d
# setup
# build-local

.PHONY: restart
restart: ## Restart
	cd build && docker-compose restart

.PHONY: stop
stop: ## Stop the project
	cd build && docker-compose stop

.PHONY: down
down: ## Stop containers and remove them. Volumes will remain untouched (eg. MySQL data).
	cd build && docker-compose down

.PHONY: destroy
destroy: ## Remove containers including volumes (eg. MySQL data).
	cd build && docker-compose down -v --remove-orphans

.PHONY: update
update: ## Updates the local environment to the latest repository state in the CURRENT branch
	git pull
# build-local

.PHONY: watch
watch: ## Run watchers for development
	$(call run_in_workspace,yarn encore dev --watch)

.PHONY: clear-cache
clear-cache: ## Clear pimcore and symfony cache
	$(call run_in_workspace,bin/console pimcore:cache:clear)
	$(call run_in_workspace,bin/console cache:clear --no-warmup)

.PHONY: build-local
build-local: ## After updating the state from repository run this to build the local system
# TODO
	echo "Not implemented yet"

.PHONY: build-ci
build-ci: ## Runs needed commands that must be run on the CI Server
# TODO
	echo "Not implemented yet"

.PHONY: lint
lint: ## Lint JS and PHP
# lint-js
# lint-php
	echo "Not implemented yet"

.PHONY: lint-js
lint-js: ## Lint JS
	echo "Not implemented yet"

.PHONY: lint-php
lint-php: ## Lint PHP
	echo "Not implemented yet"

.PHONY: shell
shell: ## Run a shell in the php-fpm container as www-data user
	cd build && docker-compose exec php-fpm bash

.PHONY: shell-root
shell-root: ## Run a shell in the php-fpm container as root user
	cd build && docker-compose exec -u root php-fpm bash

.PHONY: test
test: ## Run ALL tests

.PHONY: test-unit
test-unit: ## Run unit tests

.PHONY: test-integration
test-integration: ## Run integration tests

.PHONY: test-functional
test-functional: ## Run functional tests

.PHONY: test-acceptance
test-acceptance: ## Run acceptance tests

.PHONY: deploy
deploy: ## Deploy on the server
	echo "NOT IMPLEMENTED - this command must be defined by the team"

.PHONY: down
down: ## Removes all docker containers including it's volumes

.PHONY: xdebug-enable
xdebug-enable:
	$(call run_in_workspace,xdebug-enable)

.PHONY: xdebug-disable
xdebug-disable:
	$(call run_in_workspace,xdebug-disable)

.PHONY: xdebug-cli-enable
xdebug-cli-enable:
	$(call run_in_workspace,xdebug-cli-enable)

.PHONY: xdebug-cli-disable
xdebug-cli-disable:
	$(call run_in_workspace,xdebug-cli-disable)
