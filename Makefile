IMAGE ?= tulibraries/tupress
VERSION ?= 1.0.8
HARBOR ?= harbor.k8s.temple.edu
CLEAR_CACHES=no
ASSETS_PRECOMPILE=no

build:
	@ if [ $(ASSETS_PRECOMPILE) == yes ]; then \
			RAILS_ENV=production TUPRESS_DB_HOST=localhost bundle exec rails assets:precompile; \
		fi
	@docker build --build-arg RAILS_ENV=production --build-arg SECRET_KEY_BASE=$(SECRET_KEY_BASE) \
			--tag $(HARBOR)/$(IMAGE):$(VERSION) \
			--tag $(HARBOR)/$(IMAGE):latest \
			--file .docker/app/Dockerfile \
			--no-cache .
run:
	@docker run --rm -it --name=tupress -p 127.0.0.1:3000:3000/tcp \
		-v `pwd`/config/secrets.yml:/app/config/secrets.yml \
		-e "RAILS_ENV=production" \
		-e "TUPRESS_DB_HOST=$(TUPRESS_DB_HOST)" \
		-e "TUPRESS_DB_NAME=$(TUPRESS_DB_NAME)" \
		-e "TUPRESS_DB_USER=$(TUPRESS_DB_USER)" \
		-e "TUPRESS_DB_PASSWORD=$(TUPRESS_DB_PASSWORD)" \
		-e "K8=yes" \
		--rm -it \
				$(HARBOR)/$(IMAGE):$(VERSION)

shell:
	@docker run --rm -it \
		--entrypoint=sh --user=root \
		$(HARBOR)/$(IMAGE):$(VERSION)

CI ?= false

scan:
	@if [ $(CLEAR_CACHES) == yes ]; \
		then \
			trivy image -c $(HARBOR)/$(IMAGE):$(VERSION); \
		fi
	@if [ $(CI) == false ]; \
		then \
			trivy $(HARBOR)/$(IMAGE):$(VERSION); \
		fi

deploy: scan
	@docker push $(HARBOR)/$(IMAGE):$(VERSION) \
	# This "if" statement needs to be a one liner or it will fail.
	# Do not edit indentation
	@if [ $(VERSION) != latest ]; \
		then \
			docker push $(HARBOR)/$(IMAGE):latest; \
		fi
