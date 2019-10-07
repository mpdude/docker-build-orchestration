# Build orchestration demo repository

After you checkout this repo from GitHub, you need to 

TODO: Do this the same way as running `composer install` but then in a separate node based container
* run `yarn` to install JS dependencies
* run `node_modules/.bin/gulp` to build front-end assets (creates the
  `html/time` file as an example)

Then, run `make up` to build and bring up the "development"
image where everything is shared into the container. Point your browser to
http://localhost:8080. 

TODO: Add a docker/service/app/dist/Dockerfile which dependens on `vendor/composer/installed.json` and copies all (vendor) code into itself.
