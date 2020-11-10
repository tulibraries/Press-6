# TUPRESS

- This site is primarily based on the Book model. 
- We populate this daily with metadata from the PressWorks third party application (a Filemaker Pro instance administered by another company).
- An xml file is generated on their server (which is in the Temple umbrella) and we then FTP that file to the production server.
- The rails app then ingests that xml file, creating, books, catalogs, series, subjects, etc...

- The backend is being ported from Trestle to Administrate.
- It will (might still) use a combination of local storage and AWS.
- There is currently no authentication.

# Load Data

bundle exec rails sync:pressworks:all[press.xml]
