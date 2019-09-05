FROM archlinux/base:latest AS builder_env
LABEL maintainer="Jguer,joaogg3 at google mail"

ENV GO111MODULE=on
WORKDIR /app

RUN pacman -Syu --needed --noconfirm \
    gcc go git tar make awk pacman-contrib && paccache -rfk0

ADD go.mod .
ADD go.sum .

# Dependency for linting
RUN go get golang.org/x/lint/golint && mv /root/go/bin/golint /bin/

RUN go mod download


FROM builder_env AS builder

# Change to include packages individually. Helps caching
ADD . .
RUN make build

FROM archlinux/base:latest

RUN pacman -Syu --needed --noconfirm \
    git base-devel awk pacman-contrib && paccache -rfk0

# Gracefully removed from https://github.com/Cognexa/dockerfiles/blob/master/dockerfiles/archlinux
RUN useradd -m -s /bin/bash aur \
    && passwd -d aur \
    && echo 'aur ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/aur \
    && echo 'Defaults env_keep += "EDITOR"' >> /etc/sudoers.d/aur

ENV EDITOR vim

# set UTF-8 locale
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

WORKDIR /work/

COPY --from=builder /app/yay .
