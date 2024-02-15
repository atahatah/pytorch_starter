GPU = all
ARGS =

clean-docker:
	[ -L docker-compose.yml ] && unlink docker-compose.yml || true
	[ -L Dockerfile ] && unlink Dockerfile || true
	[ -L requirements.txt ] && unlink requirements.txt || true

docker-files:
	./bin/link-dockerfiles.sh

build: docker-files
	docker build -t pytorch_env .

run:
	docker run -it --rm --gpus '"device=$(GPU)"' --shm-size=16g -v $(PWD):/work pytorch_env zsh

classificate:
	docker run -it --rm --gpus '"device=$(GPU)"' --shm-size=16g -v $(PWD):/work pytorch_env python3 src/wandb/classificate/train.py $(ARGS)

classificate-%:
	docker run -it --rm --gpus '"device=$(GPU)"' --shm-size=16g -v $(PWD):/work pytorch_env python3 src/wandb/classificate/sweep.py --sweep_id ${@:classificate-%=%} $(ARGS)

classificate-sweep:
	docker run -it --rm --gpus '"device=$(GPU)"' --shm-size=16g -v $(PWD):/work pytorch_env python3 src/wandb/classificate/sweep.py $(ARGS)
