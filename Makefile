tag ?= latest
clean-cmd = docker compose down --remove-orphans --volumes

docker-image:
	IMAGE_TAG=$(tag) docker compose build prod

push-docker-image:
	IMAGE_TAG=$(tag) docker compose push prod

dev:
	docker compose up --build dev database --watch

prod:
	docker compose up --build prod

clean:
	$(clean-cmd)
	go clean

.PHONY: docker-image push-docker-image dev
