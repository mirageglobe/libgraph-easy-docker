FROM debian:bookworm-slim
LABEL maintainer "mirageglobe@gmail.com"

ENV \
  TERM=xterm \
  APPS=" \
        bash" \
  DEPS=" \
        apt-utils \
        build-essential \
        libgraph-easy-perl" \
  DEBIAN_FRONTEND=noninteractive

# update and upgrade all
RUN apt upgrade -y

# update and add build dependencies
RUN apt update && apt install -y --no-install-recommends $DEPS

# update and add runtime dependencies
RUN apt update && apt install -y --no-install-recommends $APPS

ENTRYPOINT ["graph-easy"]
