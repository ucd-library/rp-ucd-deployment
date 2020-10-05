# rp-ucd-deployment
UC Davis Researcher Profiles Application Deployment


Current architecture:
https://docs.google.com/drawings/d/1TvNR2_PHlqCFE6ptN4bmAiF3V9OxUWFaNqtkuK3sWnc


# Contents
  - [Application Setup](#application-setup)
  - [Development deployments](#development-deployments)
  - [Production Deployments](#production-deployments)
  - [Local Development](#local-development)
    - [Setup](#local-development---setup)
    - [Dev Cycle](#local-development---dev-cycle)
  - [Usage](#usage)
    - [Env File](#env-file)
    - [Endpoints](#endpoints)
      - [Public Endpoints](#public-endpoints)
      - [Private Endpoints](#private-endpoints)

# Application Setup

The UC Davis Research Profiles (rp) application is a series of git repositories containing one or more Docker containers.  A build of the rp application is defined in the `config.sh` file where `*_TAG` variables define which git repository tag/branches or docker image tag (for external images) will be used for the `APP_VERSION` of the application.

Each branch of this deployment repository corresponds to a deployed application environment; master = prod, dev = dev, etc.

To run the the application, simply clone this repository at the tag/branch you wish to run, setup the .env file, and start.

 - `git clone https://github.com/ucd-library/rp-ucd-deployment`
 - `git checkout [APP_VERSION]`
 - Setup .env file [see below](#env-file)
 - Start docker-compose
   `docker-compose up`

# Development deployments

Development deployments, any non-master branch (production) deployment, have relaxed rules for their deployment definition (`config.sh`) to facilitate rapid builds and testing.

  - When starting work on a new feature you can set `APP_VERSION` to either: the branch name or a version up tick with a suffix of `-dev`, `-rc1`, `-rc2`, etc.  ex: `APP_VERSION=v1.0.1-dev`.  You do not need to update this tag while you make updates and redeployments.  The `APP_VERSION` tag can stay fixed throughout the feature development process.
  - `*_TAG` variables can point at branches (instead of tags) in development branches (ONLY!).  This allows you to create builds of the latest code without having to create new 'versions' very time you want to test.
  - Branches `master`, `rc`, and `dev` will automatically build new images when this repository is pushed to GitHub.  However, in development you may wish to build without committing the repo.  For that case, simply run `./cmds/submit.sh` to start a new build.
  - IMPORTANT.  When you are ready to commit changes, run `./cmds/generate-deployment-files.sh` to build a new docker-compose.yml file(s) and k8s files (TODO) of this deployment setup.  Then you can commit your changes.


# Production Deployments

Production deployments follow strict rules.  Please follow below.

  - merge the `rc` branch into `master`
    - `git checkout master`
    - `git merge rc`
  - Uptick `APP_VERSION` in `config.sh` to the new production version of the application.  There should be no suffix.
  - Generate new docker-compose file
    - `./cmds/generate-deployment-files.sh`
  - Commit and push changes to this repository.  Set the commit message as the version tag if you have nothing better to say
    - `git add --all`
    - `git commit -m "[APP_VERSION]"`
    - `git push`
  - On push, all production images will be automatically built
  - Tag the commit with the `APP_VERSION`.
    - `git tag [APP_VERSION]`
    - `git push origin [APP_VERSION]`
  - It is very important that `APP_VERSION` in `config.sh` and the tag match.

Done!

# Local Development

Local development should be thought of has completely seperate from production or development deployments.  Local development images should NEVER leave your machine.  To protect agains local images deployed elsewhere, they will always be tagged with 'local-dev'.  To deploy development images to a server use the [Development Deployment](#development-deployments) described above.

## Local Development - Setup

To get started with local development, do the following:

  - Clone this repository
    - `git clone https://github.com/ucd-library/rp-ucd-deployment`
  - Checkout the branch you wish to work on, ex:
    - `git checkout dev`
    - `git checkout -b [my-new-feature]`
  - In the same **parent** folder at you cloned `rp-ucd-deployment`, clone all git repositories for this deployment.  They are defined in `config.sh` in the `Repositories` section.  
  IMPORATANT: Make sure you checkout to the branches you wish to work on for each repository.
  - Setup the `./repositories` folder.  There is a helper script for this:
    - `./cmds/init-local-dev.sh`
  - Create the docker-compose.yaml file:
    - `./cmds/generate-deployment-files.sh`
    - Note: the local development folder (rp-local-dev) is ignored from git.  you can make changes at will, though these changes will be overwritten every time you run `generate-deployment-files.sh`.  To makes permanent changes you will need to update the `./templates/local-dev.yaml` file
  - create your .env file [see below](#env-file)

## Local Development - Dev Cycle

  - Make your code changes in your local repositories
    - See note below, you do not need to rebuild images on every change.  Just certain changes.
  - Build the `local-dev` tagged images:
    - `./cmds/build-local-dev.sh`
  - Start the local environment:
    - `cd rp-local-dev; docker-compose up`

  - Add admin
    - docker-compose exec redis redis-cli set role-[username]-admin true

Local development notes.

   - Most containers have a commented out `command: bash -c "tail -f /dev/null"` in the `./rp-local-dev/docker-compose.yaml`.  You can uncomment this so the container starts without running the default process. Then you can bash onto container to for faster start/stop of server to see changes. ex:
     - uncomment `command: bash -c "tail -f /dev/null"` under the `client` service
     - `docker-compose exec client bash`
     - `node index.js` - starts the server
     - `ctrl+c` - stops the server
  - Code directories are mounted as volumes so changes to your host filesystem are reflected in container.  However, changes to application packages (ex: package.json) will require rebuild of images (`./cmds/build-local-dev.sh`)

# Usage

## Env File

Here are the .env file parameters.

  - `SERVER_URL` Public url for rp system.  Defaults to http://localhost:8080
  - `PRIVATE_SERVER` defaults to true.  must be explicity set to 'false' to allow public access.  Otherwise only users logged in with role 'admin' will be allowed.
  - `ALLOWED_PATHS` If the server is private, these paths are always allowed.  Paths should be space separated regex with no start/end slashes and should point to login portal and assets.  /auth/.* is always in list.
  - `AUTH_SERVICE_LOGOUT_REDIRECT` and `AUTH_SERVICE_LOGIN_REDIRECT` specify paths to redirect user to after successful login/logout.  Both default to '/'.
  - `AUTH_PORTAL` speficy path to redirect unauthenticated users to if not logged in
  - `ALLOWED_ROLES` If the server is private, users with these roles are allowed access.  Roles should be space separated.  If not provided, only users with role 'admin' are allowed.  To allow any authenticated user, set `ALLOWED_ROLES=all`.
  - `HOST_PORT` host machine port for main public gateway to bind to, defaults to 8080
  - `FUSEKI_HOST_PORT` host machine port for Fuseki instance to bind to, defaults to 8081.  This port should never be publicly accessible but is exposed to the host machine for data injest and Fuseki UI access.
  - `INDEXER_HOST_PORT` host machine port for index service to bind to, defaults to 8082.  This port should never be publicly accessible but is exposed to the host machine for access to the indexer rest api.  See [Private Endpoints](#private-endpoints) section.
  - `DEFAULT_ADMINS` common seperated list of users to ensure are in the system with role admin.
  - `CLIENT_ENV` used by `ucd-rp-client` to select which folder to server for client.  Setting to `prod` will serve the `dist` folder, everything else will serve the `public` folder.  Defaults to dev.
  - `JWT_EXPIRES_IN` Time in ms jwt expiration
  - `JWT_COOKIE_NAME` name of jwt cookie.  defaults to `rp-ucd-jwt`.
  - Fuseki. variables used to control fuseki.  Note some of these can be modified if you wish to attach to an external fuseki instance.
    - Connection: `FUSEKI_USERNAME`, `FUSEKI_PASSWORD`, `FUSEKI_HOST`, `FUSEKI_PORT`, `FUSEKI_DATABASE`
    - `FUSEKI_GRAPHS` space seperated list of graphs to use in the fuseki dataset when creating an es model

There are additional config variables you an use see in the main [config.js](https://github.com/ucd-library/vessel/blob/master/node-utils/lib/config.js) file.  However it is not recommend to change them unless you know what you are doing.

## Endpoints

This section covers the various api endpoints.  It's broken out by both public endpoint provided by the `gateway` and private endpoints provided by some services

### Public Endpoints

Below is a list of the public endpoint provided by the `gateway` service.  The gateway service should be the only host/port exposed to the public.

By default the server will bind to localhost:8080, however the port can be modified with the `HOST_PORT` env variable.

  - /
    - Access the main client UI (`rp-ucd-client`).  All request not specifically defined in this [Public Endpoints](#public-endpoints) section will be routed to the `rp-ucd-client` service.
  - /api
    - Access the Swagger/OpenAPI3 JSON definition file.  Only the endpoints are listed below, please see OpenAPI definition for more information.  If running on localhost using standard 8080 port you can use: https://editor.swagger.io/?url=http://localhost:8080/api
    - /api/:id
    - /api/search
    - /api/search/es
  - /indexer/model/:type/:uri
    - Get a on-the-fly es model.  `:type` should be a vivo type.  `:uri` should be a URI Encoded subject URI.
  - /auth/login
    - Login using CAS service.  Note, buy default the server is private and a user must use this endpoint to login.
  - /auth/logout
    - logout of rp system
  - /fuseki
    - Run a SPARQL query againts the http://fuseki:3030/vivo/query endpoint


### Private Endpoints

  - http://localhost:8081
    - Fuseki UI.  Use /[dataset name]/query to run SPARQL query
  - http://localhost:8082
    - Access the indexer api.  Current access points are:
    - /admin/reindex
      - get the current status of the reindexer.  The reindexer handles the full load of Fuseki dataset into elastic search
    - /admin/reindex/run/:type
      - The the Fuseki dataset into elastic search.  Optional type parameter to only reindex all models of a single type
    - /admin/reindex/rebuild-schema
      - Used to create a new elastic search index when the elastic search schema has changed.  This will reindex into a new es index.  When complete the es alias will be set to the new index and all old indexes will be deleted.
    - /admin/getCurrentIndexes
      - Returns the current list of es indexes with details.
    - /model/:type:uri
      - This is the same endpoint that is accessible via the public gateway at /reindexer/model/:type:uri.  Note, this is the only indexer endpoint that is publicly accessible.

## Custom Models

You can define custom models by mounting a directory with a `map.js` file and [model name].tpl.rq files.

TODO: Expand on this.

## Roles

Currently you add roles via the `DEFAULT_ADMINS` env variable or by directly adding the role key to redis.

Example, add user jrmerz@ucdavis.edu as role admin:

```
docker-compose exec redis redis-cli set role-jrmerz@ucdavis.edu-admin true
```

## Add Sample Data

https://github.com/ucd-library/research-profiles/tree/master/examples/material_science