tag ?= latest
clean-cmd = docker compose down --remove-orphans --volumes

docker-image:
	IMAGE_TAG=$(tag) docker compose build prod

push-docker-image:
	IMAGE_TAG=$(tag) docker compose push prod

dev:
	docker compose up database -d
	sleep 3
	docker compose up --build dev database

prod:
	docker compose up --build prod

clean:
	$(clean-cmd)
	go clean

.PHONY: docker-image push-docker-image dev
