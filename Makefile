#Defaults
include .env
export #exports the .env variables

#Set DOCKER_IMAGE_VERSION in the .env file OR by passing in
VERSION ?= $(DOCKER_IMAGE_VERSION)
IMAGE ?= tulibraries/tupress
HARBOR ?= harbor.k8s.temple.edu
CLEAR_CACHES ?= no
RAILS_MASTER_KEY ?= $(TUPRESS_MASTER_KEY)
TUPRESS_DB_HOST ?= host.docker.internal
TUPRESS_DB_NAME ?= tupress
TUPRESS_DB_USER ?= root
DB_SYNC ?= no
CI ?= false

build:
	@docker build --build-arg RAILS_MASTER_KEY=$(RAILS_MASTER_KEY) \
		--tag $(HARBOR)/$(IMAGE):$(DOCKER_IMAGE_VERSION) \
		--tag $(HARBOR)/$(IMAGE):latest \
		--file .docker/app/Dockerfile \
		--no-cache .

run:
	@docker run --rm -it --name=tupress -p 127.0.0.1:3000:3000/tcp \
		-e "TUPRESS_DB_HOST=$(TUPRESS_DB_HOST)" \
		-e "TUPRESS_DB_NAME=$(TUPRESS_DB_NAME)" \
		-e "TUPRESS_DB_USER=$(TUPRESS_DB_USER)" \
		-e "TUPRESS_DB_PASSWORD=$(TUPRESS_DB_PASSWORD)" \
		-e "RAILS_MASTER_KEY=$(RAILS_MASTER_KEY)" \
		-e "RAILS_ENV=production" \
		-e "RAILS_SERVE_STATIC_FILES=yes" \
		-e "K8=yes" \
		-e "DB_SYNC=$(DB_SYNC)" \
		--rm -it \
		$(HARBOR)/$(IMAGE):$(VERSION)

lint:
	@if [ $(CI) == false ]; \
		then \
			hadolint .docker/app/Dockerfile; \
		fi

shell:
	@docker run --rm -it \
		-e "RAILS_MASTER_KEY=$(RAILS_MASTER_KEY)" \
		-e "RAILS_ENV=production" \
		-e "RAILS_SERVE_STATIC_FILES=yes" \
		--entrypoint=sh --user=root \
		$(HARBOR)/$(IMAGE):$(VERSION)

scan:
	@if [ $(CLEAR_CACHES) == yes ]; \
		then \
			trivy image -c $(HARBOR)/$(IMAGE):$(VERSION); \
		fi
	@if [ $(CI) == false ]; \
		then \
			trivy $(HARBOR)/$(IMAGE):$(VERSION); \
		fi

deploy: scan lint
	@docker push $(HARBOR)/$(IMAGE):$(VERSION) \
	# This "if" statement needs to be a one liner or it will fail.
	# Do not edit indentation
	@if [ $(VERSION) != latest ]; \
		then \
			docker push $(HARBOR)/$(IMAGE):latest; \
		fi
