FROM nvidia/cuda:11.7.1-base-ubuntu22.04

RUN apt update && apt install -y \
    python3 \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN adduser --disabled-password --gecos '' --shell /bin/bash user
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

ENV HOME=/home/user

WORKDIR /work

ENV PATH $PATH:/home/user/.local/bin
COPY container/prod/requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

CMD [ "/bin/bash" ]