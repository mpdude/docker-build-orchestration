# Build orchestration demo repository

In this repository, I try to collect various examples of how a PHP-centric web application can be developed and shipped in a container-centric way.

My wishlist items are:

### Use containerized tools

Working on the project should not require complex VM setups (Vagrant or similar). It should be easy to switch between projects, and each project should be able to use different tools and/or different versions of the same tools.

Probably the best way to make this work is when the languages and tools (`php`, `node`, `composer`, `yarn`, `php-cs-fixer`, ...) are run in containers or during Docker builds `FROM` suitable base images.

### "Composition over aggregation"

Avoid building "fat" Docker images where a lot of things (tools) are installed into a single image. I consider it an antipattern to have a `development` Docker image where PHP, Apache, Node.js, yarn, ... get installed. Effectively, this is a Vagrant VM disguised as a Docker image.

Instead, (re)use (pre-)exisiting images. Use a `node` or `node`-based container for Node-related tasks, and a `php`-based one for PHP. That also seems to follow the "one process per container" Docker philosophy.

It does _not_ mean you cannot have your own "base" images. It's about having _dedicated_ containers.

Keeping things up to date is much easier if you don't have to rebuild a "fat" image whenever a package or tool in it needs to be updated. Instead, use and update e. g. the PHP container independently of the Node container.

Also, mixing different versions (e. g. Node 14 and PHP 7.4 in one project, Node 16 and PHP 8.1 in another) is much easier to maintain when you don't build images that are cross-combinations of all needed versions, but single images per version.

### Same workflows everywhere

Use the same script/tool/workflow definition for the same task, everywhere.

For example, don't put `docker run ... -v $(pwd):$(pwd) ... composer install` into a ./go script (see [here](https://www.thoughtworks.com/insights/blog/praise-go-script-part-i), [there](https://www.hamvocke.com/blog/makefiles-for-accessibility/)) to fetch vendors during development, while using `FROM composer:latest... RUN composer install ...` in a `Dockerfile` on CI.

There should be _one_ definition of how to perform a particular task, and it should be used during development, CI runs and for the final image builds in the same way.

### No target- or environment specific `Dockerfiles` etc.

For example, do not maintain a `Dockerfile.dev` to build an image used during development (or CI test runs), and a different `Dockerfile` to build the final production image.

This is somewhat a corollary of the preceding item, since there should be no two places that define the same task or step, or even variations of it. 

In the best case, tests (at least on CI) are being run on, on top of or against the Docker image that will be shipped to production.

When the image used for testing or development requires additional software or tools installed (say, `xdebug` for PHP), it seems preferrable to _add_ that to the production (base) image, instead of building completely separate images. Of course, it would be even better if such tools could be run from dedicated, independent containers _against_ the existing image.   

### Ad hoc tasks

During development, you will often need to run tasks in an "ad hoc" manner that is not necessary during CI runs or during builds of the final image.

For example, it should (easily) be possible to run `composer why-not foo/bar` or `yarn add some-dependency` using the appropriate containers/images. The build process itself probably only needs `composer install`, `yarn` or `gulp` to be run.

I've mentioned `./go` scripts before. To improve DX, a common (similar) entry point for all these tasks would be nice.

### Filesystem mounts during development

At least for PHP-centric applications, it is necessary to use filesystem mounts at development time so that you can change code in the IDE and immediately reload a page in the browser, even when the webserver is running in a Docker container.

Vendors possibly being fetched by a containerized tool (`vendor` directory for `composer`, `node_modules` for `yarn`) need to be visible to the IDE to support code inspection and completion. 

For artifacts being built (e. g. Webpack results), this is not strictly necessary, but probably helpful.

### Private dependencies

It must be possible to fetch vendors from private repositories/registries. 

This probably means one or several of the following:

* [Build secrets](https://medium.com/@tonistiigi/build-secrets-and-ssh-forwarding-in-docker-18-09-ae8161d066) can be used
* Multi-stage builds make sure no sensitive data leaks into final images
* Things like the SSH auth socket or necessary tokens mounted into containers only at run-time

### Multi-arch builds

There are good reasons why [the need for multi-platform builds increases](https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/) in the future.

The approach taken to build the application must not prevent the use of `buildx` or prevent multi-platform builds for final images.

For PHP/Node-centric web applications, the application code itself (PHP, [compiled/transpiled] JavaScript) is architecture-independent. The PHP interpreter or the webserver used are not.

### Tooling

When using specialized tooling (beyond shell scripts or Makefiles) to orchestrate the build process, do these tools have a healthy ecosystem?

* A reasonable base of other people using them
* Enough maintainers or contributors so we can assume they will be maintained for a longer time 
* Sponsors/backing organisations
* No (complicated) software dependencies on their own 

### Shared configuration under version control

Some tools under consideration (#3, #12) allow to share configuration (e. g. Dockerfiles or configuration to spin up PHP and a webserver) via GitHub URLs.

Might be a nice-to-have feature when dealing with a multitude of projects that all share a similar structure and tech stack.

## Building the sample application

To understand, document and illustrate the different approaches to building a dockerized application, I plan to maintain different branches in this repository. Hopefully, that allows to judge the solutions based on the criteria outlined above.

Working with the sample application in this repo requires:

* Run `composer install` to fetch PHP dependencies
* Run `yarn` to install JS dependencies
* Run `node_modules/.bin/gulp` to build front-end assets (creates the `html/time` file as an example)

During development, it should be possible to start a webserver and see the application's output at `http://localhost:...` or similar, while being able to modify the `html/index.php` file. The container image used should include xdebug.  

It should be possible to run ad-hoc commands like `composer show` or `yarn list`, or re-build the assets by running Gulp.

A simple task/command should be available to build the production image.
