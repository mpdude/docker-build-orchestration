# Build orchestration demo repository

After you checkout this repo from GitHub, you need to 

* run `yarn` to install JS dependencies
* run `node_modules/.bin/gulp` to build front-end assets (creates the
  `html/time` file as an example)
* run `composer install` to fetch PHP dependencies

Then, run `docker-compose up apache` to build and bring up the "production"
image where everything is copied into the container. Point your browser to
http://localhost:8080.

Alternatively, run `docker-compose up apache_dev` to run the "dev" image. 
In this image, the local directory is mounted into the container. You can
then run `node_modules/.bin/gulp` again and observe that the time displayed 
should change.