# TUPRESS

- This site is primarily based on the Book model.
- We populate this daily with metadata from the PressWorks third party application (a Filemaker Pro instance administered by another company).
- An xml file is generated on their server (which is in the Temple umbrella) and we then FTP that file to the production server.
- The rails app then ingests that xml file, creating, books, catalogs, series, subjects, etc...

- The backend is being ported from Trestle to Administrate.
- It will (might still) use a combination of local storage and AWS.
- There is currently no authentication.

## Getting started

### Load Data

#### For the local instance:

`bundle exec rails sync:pressworks:all[<utf-8 xml file from pressworks>]`

#### For the docker instance:
* By default the database sync is not run locally. Use `make load-data` to run it.

The app database needs to be initialized in oder for `make load-data` to work.  If that has not happened, then run `make db-init` (this only needs to run once).

### If using docker-compose:
* source .env or set LOCAL_BASE_IMAGE manually.
* run docker-compose up

### Start the Application using Docker as an alternative

We defined a Makefile with many useful commands for local development. These commands replicate the process used to deploy in the Gitlab pipeline.

* To build an image: ```make build ```
  * `BASE_IMAGE` can be set to override the default base_image: ```make build BASE_NAME=ruby:3.1.0-alpine```
  * `PLATFORM` can be set to override default platform used: ```make build PLATFORM=arm64```
* To start the dockerized app, run ```make run```
* To deploy prod image: ```make deploy VERSION=x```  
    * VERSION=latest by default
* To run security check on image: ```make scan```
    * This depends on trivy. Run `brew install aquasecurity/trivy/trivy` to make this available locally.
* To run a shell with image: ```make shell```
* To run docker lint: ```make lint```
    * This depends on hadolint. Run `brew install hadolint` to make this available locally.


## Deployment
### QA
* Deploys to https://tupress-qa.k8s.temple.edu

### Production
* In order to deploy to production, create a release in GitLab. The release tag normally used for releases should continue to be added manually during the release process, e.g. “1.3.3”. Gitlab will then automatically tag the release image with both a “prod” tag and a release tag that references the git tag (e.g. 1.3.3). The newly tagged image will then be deployed to the production environment.
