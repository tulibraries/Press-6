build:
	docker build --build-arg RAILS_ENV=production --tag harbor.k8s.temple.edu/tulibraries/tupress:latest --file .docker/Dockerfile --no-cache .
