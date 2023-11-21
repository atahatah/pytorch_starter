run: build up exec down
build: requirements.txt
	bash -c 'docker compose build --build-arg UID="`id -u`" --build-arg GID="`id -g`" --build-arg USERNAME="`id -un`" --build-arg GROUPNAME="`id -gn`"'
rebuild: requirements.txt down
	bash -c 'docker compose build --no-cache --build-arg UID="`id -u`" --build-arg GID="`id -g`" --build-arg USERNAME="`id -un`" --build-arg GROUPNAME="`id -gn`"'
up: requirements.txt
	bash -c 'docker compose up -d'
exec:
	bash -c 'docker compose exec pytorch_env zsh'
down:
	bash -c 'docker compose down'
restart: requirements.txt down up
requirements.txt:
	bash -c 'cp requirements.txt.sample requirements.txt'
freeze:
	bash -c 'docker compose exec -it pytorch_env bash -c "pip3 freeze > requirements.lock"'