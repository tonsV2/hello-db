tag ?= latest
clean-cmd = docker compose down --remove-orphans --volumes

build-docker-image:
	IMAGE_TAG=$(tag) docker compose --profile prod build prod

push-docker-image:
	IMAGE_TAG=$(tag) docker compose --profile prod push prod

dev:
	docker compose --profile dev up --build --watch database dev

prod:
	docker compose --profile prod up database prod

clean:
	$(clean-cmd)
	go clean

.PHONY: docker-image push-docker-image dev
