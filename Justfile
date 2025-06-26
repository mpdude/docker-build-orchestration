set dotenv-load := true
set positional-arguments

export uid:= `id -u`
export gid := `id -g`
export PWD := `pwd`

# This selects whether to use the PHP build layer including development tools (xdebug),
# or the plain runtime layer. After a change, "just docker-rebuild" has to be run, otherwise
# docker compose does not seem to pick up the changed target config.
#export PHP_TARGET := 'development'
export PHP_TARGET := 'runtime'

export COMPOSER_HOME := if path_exists(config_directory() / "composer") == "true" { config_directory() / "composer" } else { home_directory() / ".composer" }
export COMPOSER_CACHE := if path_exists(cache_directory() / "composer") == "true" { cache_directory() / "composer" } else { home_directory() / ".composer/cache" }
export YARN_CACHE := if path_exists(cache_directory() / "yarn") == "true" { cache_directory() / "yarn" } else { home_directory() / ".yarn/cache" }

COMPOSE := 'docker compose'
COMPOSE-RUN := COMPOSE + ' run --rm'
PHP-RUN := COMPOSE-RUN + ' --no-deps php'
NODE-RUN := COMPOSE-RUN + ' --no-deps node'

_default:
    just --list

# Fetch all vendors/dependencies
install:
    just composer --no-interaction install
    just yarn install --non-interactive

# Prepare the project for execution
build: install
    {{NODE-RUN}} npx gulp

# Run composer with arbitrary arguments
composer *args:
    {{COMPOSE-RUN}} composer "$@"

# Run yarn with arbitrary arguments
yarn *args:
    # Make sure the cache dir exists. Otherwise the docker bind-mount would create it with
    # root permissions, which may lead to errors when running the container as a non-root user
    mkdir -p {{YARN_CACHE}} || true
    {{COMPOSE-RUN}} yarn "$@"

# Run PHP with arbitrary arguments
php *args:
    {{COMPOSE-RUN}} php "$@"

# Run node with arbitrary arguments
node *args:
    {{COMPOSE-RUN}} node "$@"

# Run npm with arbitrary arguments
npm *args:
    {{COMPOSE-RUN}} node npm "$@"

# Run gulp with arbitrary arguments
gulp *args:
    {{COMPOSE-RUN}} node npx gulp "$@"

# Run a shell in a given service, e. g. "just enter php"
enter *args:
    {{COMPOSE-RUN}} --entrypoint /bin/bash "$@"

# Rebuild all necessary Docker images
docker-rebuild *args:
    {{COMPOSE}} build "$@"

# Clean artifacts and vendors
clean:
    rm -rf node_modules vendor composer.lock yarn.lock

serve $PORT="8000":
    {{COMPOSE}} up --detach apache

stop:
    {{COMPOSE}} down apache

build-final: build
    docker buildx build -t build-final --load --target final -f .docker/php/Dockerfile .
