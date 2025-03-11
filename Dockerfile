FROM manjarolinux/base:20250309

RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
    dart

RUN mkdir /typled

COPY . /typled

WORKDIR /typled

RUN cd typled_cli && \
  dart pub get

CMD /usr/bin/bash
