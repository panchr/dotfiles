FROM silex/emacs:30.2-debian

RUN  apt-get update \
  && apt-get install -y git bash zsh xclip fd-find \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /config
COPY ./ ./

RUN chmod +x ./bootstrap/*.sh
RUN bash ./bootstrap/init-doom.sh

ENV TERM=xterm-256color
ENTRYPOINT ["emacs", "-nw"]
