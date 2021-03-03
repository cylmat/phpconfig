SHELL := /bin/bash

# Call when no arguments
all:
	@echo '';

# Declare no names like command
# Avoid a conflict with a file of the same name, and improve performance
.PHONY: all grump-pre linters testing

###########
# GRUMPHP #
###########

grump-lint:
	vendor/bin/grumphp run --testsuite=lint

grump-tests:
	vendor/bin/grumphp run --testsuite=tests

grump-pre: 
	vendor/bin/grumphp git:pre-commit

grump-tasks:
	vendor/bin/grumphp run --tasks=$(ts)

############
# COMPOSER #
############

compose-update:
	composer update --lock
	composer normalize --no-update-lock

###########
# LINTERS #
###########

# NO autofix before commit on GrumPhp
fix:
	vendor/bin/php-cs-fixer fix --config lint/.php_cs -v
	vendor/bin/phpcbf --colors --standard=lint/phpcs.xml -v
	# phpparser: Work line by line, use only with GrumPhp

# Only used with make cause require 'php-ast' extension
phan:
	PHAN_ALLOW_XDEBUG=1 vendor/bin/phan --allow-polyfill-parser --config-file lint/phan.config.php

linters:
	make phan
	vendor/bin/phpcpd src
	vendor/bin/phpcs --colors --standard=lint/phpcs.xml -s
	vendor/bin/parallel-lint src --exclude vendor
	vendor/bin/phpmd src ansi lint/phpmd.xml --reportfile=STDOUT
	vendor/bin/phpstan analyse --level 8 --configuration lint/phpstan.neon --memory-limit 256M

############
# BEHAVIOR #
############

	# Spec
	echo 'N' | vendor/bin/phpspec describe App/Sample -q --config=phpspec.yml
	vendor/bin/phpspec run --config=phpspec.yml

###########
# TESTING #
###########

test-gen:
	vendor/bin/phpunitgen --config=phpunitgen.yml src

cover:
	XDEBUG_MODE=coverage vendor/bin/phpunit -c phpunit.xml --coverage-html=var/unit-coverage
	phpdbg -qrr vendor/bin/phpunit -c phpunit.xml --coverage-html var/unit-coverage
	phpdbg -qrr vendor/bin/phpspec run -c phpspec.yml
	
testing:
	# paratest or pest or phpunit
	vendor/bin/paratest -c phpunit.xml
	vendor/bin/pest -c phpunit.xml
	vendor/bin/phpunit -c phpunit.xml
