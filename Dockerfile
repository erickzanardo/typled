FROM manjarolinux/base:20250309

RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
    dart \
    gtk3 \
    xorg-server-xvfb

RUN mkdir /typled

COPY . /typled

WORKDIR /typled

RUN cd typled_cli && \
  dart pub get && \
  dart bin/typled.dart upgrade

CMD /usr/bin/bash
