tag ?= latest
clean-cmd = docker compose down --remove-orphans --volumes

build-docker-image:
	IMAGE_TAG=$(tag) docker compose --profile prod build prod

push-docker-image:
	IMAGE_TAG=$(tag) docker compose --profile prod push prod

dev:
	docker compose -f docker-compose.base.yml -f docker-compose.dev.yml up --build --watch

prod:
	docker compose -f docker-compose.base.yml -f docker-compose.prod.yml up -d

clean:
	$(clean-cmd)
	go clean

.PHONY: docker-image push-docker-image dev
