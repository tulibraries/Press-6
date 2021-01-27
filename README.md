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

To load data into your local instance, run the following command:

`bundle exec rails sync:pressworks:all[press.xml]`

### Start the Application using Docker as an alternative

If Docker is available, we defined a Makefile with many useful commands.

* To build prod image: ```make build ASSETS_PRECOMPILE=yes```
  * `ASSETS_PRECOMPILE=no` by default
* To start the dockerized app, run ```make run```
* To deploy prod image: ```make deploy VERSION=x```  VERSION=latest by default
* To run security check on image: ```make secure``` depends on trivy (brew install aquasecurity/trivy/trivy)
* To run a shell with image: ```make shell```
* To run docker lint: ```make lint```
