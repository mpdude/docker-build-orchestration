set dotenv-load := true
set positional-arguments

export uid:= `id -u`
export gid := `id -g`
export PWD := `pwd`

COMPOSE := 'docker-compose'
COMPOSE-RUN := COMPOSE + ' run --rm'
PHP-RUN := COMPOSE-RUN + ' --no-deps php'
NODE-RUN := COMPOSE-RUN + ' --no-deps node'

_default:
    just --list

# Fetch all vendors/dependencies
install:
    {{COMPOSE-RUN}} composer --no-interaction install
    {{NODE-RUN}} yarn install --non-interactive

# Prepare the project for execution
build: install
    {{NODE-RUN}} npx gulp

# Run composer with arbitrary arguments
composer *args:
    {{COMPOSE-RUN}} composer "$@"

# Run yarn with arbitrary arguments
yarn *args:
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

# Rebuild all necessary Docker images
docker-rebuild:
    {{COMPOSE}} build

# Clean artifacts and vendors
clean:
    rm -rf node_modules vendor composer.lock yarn.lock

serve $PORT="8000":
    {{COMPOSE}} up --detach apache

stop:
    {{COMPOSE}} down apache
