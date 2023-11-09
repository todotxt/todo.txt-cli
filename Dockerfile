FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y \
      build-essential

WORKDIR /srv/todo.txt

COPY . .

RUN make &&\
    make install \
      CONFIG_DIR=/etc \
      INSTALL_DIR=/usr/bin \
      BASH_COMPLETION=/usr/share/bash-completion/completions

CMD [ "tail", "-f", "/dev/null" ]
