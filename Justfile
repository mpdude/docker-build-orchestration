set dotenv-load := true

export UID := `id -u`
export GID := `id -g`
export PWD := `pwd`

COMPOSE := 'docker-compose'
COMPOSE-RUN := COMPOSE + ' run --rm'
PHP-RUN := COMPOSE-RUN + ' --no-deps php'
NODE-RUN := COMPOSE-RUN + ' --no-deps node'

default:
	just --list

composer *args:
    {{COMPOSE-RUN}} composer {{args}}

php *args:
    {{COMPOSE-RUN}} php '{{args}}'

install:
	{{PHP-RUN}} composer --no-interaction install
	{{NODE-RUN}} yarn install --non-interactive --frozen-lockfile
