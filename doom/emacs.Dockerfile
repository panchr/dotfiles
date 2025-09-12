FROM silex/emacs:30.2-debian

RUN  apt-get update \
  && apt-get install -y git bash zsh xclip fd-find golang \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /config
COPY ./ ./

RUN chmod +x ./bootstrap/*.sh
RUN bash ./bootstrap/init-doom.sh

# Install gopls for LSP support.
RUN go install golang.org/x/tools/gopls@latest
RUN cp /root/go/bin/gopls /bin/

ENV TERM=xterm-256color
ENTRYPOINT ["emacs", "-nw"]
