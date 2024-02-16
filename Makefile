GPU = all
ARGS =

classificate:
	docker run -it --rm --gpus '"device=$(GPU)"' --shm-size=16g -v $(PWD):/work pytorch_env python3 src/wandb/classificate/train.py $(ARGS)

classificate-%:
	docker run -it --rm --gpus '"device=$(GPU)"' --shm-size=16g -v $(PWD):/work pytorch_env python3 src/wandb/classificate/sweep.py --sweep_id ${@:classificate-%=%} $(ARGS)

classificate-sweep:
	docker run -it --rm --gpus '"device=$(GPU)"' --shm-size=16g -v $(PWD):/work pytorch_env python3 src/wandb/classificate/sweep.py $(ARGS)

PROJECT_NAME = pytorch_starter
DEV_IMAGE = $(PROJECT_NAME)_dev
DOCKER_OPTS = --gpus '"device=$(GPU)"' --shm-size=16g -v $(PWD):/work
DOCKER_RUN_OPTS = -it --rm $(DOCKER_OPTS)
SINGULARITY_IMAGE = container/prod/$(PROJECT_NAME).sif
DOCKER_URL = docker://ghcr.io/atahatah/pytorch_starter:main

build-dev:
	docker build -t $(DEV_IMAGE) -f container/dev/Dockerfile .

run-dev:
	docker run $(DOCKER_RUN_OPTS) $(DEV_IMAGE) zsh

up:
	docker run -dit $(DOCKER_OPTS) $(DEV_IMAGE) zsh

$(SINGULARITY_IMAGE):
	singularity build $(SINGULARITY_IMAGE) $(DOCKER_URL)

gpu-test: $(SINGULARITY_IMAGE)
	singularity exec --nv $(SINGULARITY_IMAGE) python3 -c "import torch; print(torch.cuda.is_available())"