# rp-ucd-deployment
UC Davis Researcher Profiles Application Deployment


# Application Setup

The UC Davis Research Profiles (rp) application is a series of git repositories containing one or more Docker containers.  A build of the rp application is defined in the `config.sh` file where `*_REPO_TAG` variables define which git repository tag/branches will be used for the `APP_VERSION` of the application.

Each branch of this deployment repository corresponds to a deployed application environment; master = prod, dev = dev, etc.

To run the the application, simply clone this repository at the tag/branch you wish to run, setup the .env file, and start.

 - `git clone https://github.com/ucd-library/rp-ucd-deployment`
 - `git checkout [APP_VERSION]`
 - Setup .env file [see below](#env-file)
 - Start docker-compose
   `docker-compose up`

# Development deployments

Development deployments, any non-master branch (production) deployment, have relaxed rules for their deployment definition (`config.sh`) to facilitate rapid builds and testing.

  - When starting work on a new feature you can set `APP_VERSION` to either: the branch name or a version up tick with a suffix of `-dev`, `-rc`, `-[branch name]`, etc.  ex: `APP_VERSION=v1.0.1-dev`.  You do not need to update this tag will you updates and redeployments.  It can stay fixed throughout the development process.
  - `*_REPO_TAG` variables can point at branches in development branches.  This allows you to create builds of the latest code without having to create new 'versions' very time you want to test.
  - Branches `master`, `rc`, and `dev` will automatically build new images when this repository is pushed to GitHub.  However, in development you may wish to build without committing the repo.  For that case, simply run `./cmds/submit.sh` to start a new build.
  - IMPORTANT.  When you are ready to commit changes, run `./cmds/generate-dc-files.sh` to build a new docker-compose.yml file of this deployment setup.  Then you can commit your changes.


# Production Deployments

Production deployments follow strict rules.  Please follow below.

  - merge the `rc` branch into `master`
    - `git checkout master`
    - `git merge rc`
  - Uptick `APP_VERSION` in `config.sh` to the new production version of the application.
  - Generate new docker-compose file
    - `./cmds/generate-dc-files.sh`
  - Commit and push changes to this repository.  Set the commit message as the version tag if you have nothing better to say
    - `git add --all`
    - `git commit -m "[APP_VERSION]"`
    - `git push`
  - On push all production images will be automatically built
  - Tag the commit with the `APP_VERSION`.
    - `git tag [APP_VERSION]`
    - `git push origin [APP_VERSION]`
  - It is very important that `APP_VERSION` in `config.sh` and the tag match.

Done!

# Local Development

Local development should be thought of has completely seperate from production or development deployments.  Local development images should NEVER leave your machine.  To deploy to a server use the Development Deployment described above.

## Local Development - Setup

To get started with local development, do the following:

  - Clone this repository
    - `git clone https://github.com/ucd-library/rp-ucd-deployment`
  - Checkout the branch you wish to work on, ex:
    - `git checkout dev`
  - In the same parent folder at you cloned `rp-ucd-deployment`, clone all git repositories for this deployment.  They are defined in `config.sh` in the `Repositories` section.  Make sure you checkout to the branches you wish to work on.
  - Setup the `repositories` folder.  There is a helper script for this:
    - `./cmds/init-local-dev.sh`
  - Create the docker-compose.yaml file:
    - `./cmds/generate-dc-files.sh`
    - Note: this file is ignored from git.  you can make changes at will, though these changes will be overwritten every time you run `generate-dc-files.sh`.  To makes permanent changes you will need to update the `dc-templates/local-dev.yaml` script
  - create your .env file [see below](#env-file)

## Local Development - Dev Cycle

  - Makes your code changes in your local folders.  You do not need to commit these changes.
  - Build the `local-dev` tagged images:
    - `./cmds/build-local-dev.sh`
  - Start the local environment:
    - `cd rp-local-dev; docker-compose up`

Local development notes.

   - Most containers have a commented out `command: bash -c "tail -f /dev/null"`.  You can uncomment this so the container starts, but then you can bash onto container to for faster start/stop of server to see changes. ex:
     - uncomment `command: bash -c "tail -f /dev/null"` in `client`
     - `docker-compose exec server bash`
     - `node index.sh` - starts the server
     - `ctrl+c` - stops the server
  - Code directories are mounted as volumes so changes to your host filesystem are reflected in container.

# Env File

Here are the .env file parameters.

  - `VIVO_CONTENT_TRIPLE_SOURCE`: defaults to `tdbContentTripleSource`.  To use Fueski, switch to `sparqlContentTripleSource`
    - If you use Fueski, the following must be supplied as well:
    - `FUSEKI_HOSTNAME`
    - `FUSEKI_USERNAME`
    - `FUSEKI_PASSWORD`