# Build orchestration demo repository

This project uses `https://github.com/chefkoch-dev/container-run` to optimize local docker runs.
After you checkout this repo from GitHub, you only need to run
 
```
tasks/install-and-start-dev
```

What this will do:

* run `tasks/yarn` to install JS dependencies
* run `tasks/gulp` to build front-end assets (creates the
  `html/time` file as an example)
* run `tasks/composer install` to fetch PHP dependencies
* run `tasks/start-dev` to build and run the "dev" image
 
Using the "dev" image, the local directory is mounted into the container running in background. You can
then run `tasks/gulp` again and observe that the time displayed 
should change. To stop the dev image, just call `tasks/stop-dev`

Alternatively, run `tasks/start-prod` to build and bring up the "production"
image where everything is copied into the container.

In either case, point your browser to
http://localhost:8080.