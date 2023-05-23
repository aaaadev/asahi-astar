FROM menci/archlinuxarm:base-devel

COPY pacman.conf /etc/pacman.conf

RUN mkdir /app
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm --needed --overwrite '*' bash rustup git gcc llvm pkgconf distcc
RUN rustup default stable
WORKDIR /app
RUN git clone https://github.com/pacman-repo-builder/pacman-repo-builder.git
WORKDIR /app/pacman-repo-builder
RUN cargo build --bin=build-pacman-repo --release
RUN cp target/release/build-pacman-repo /usr/bin/build-pacman-repo
RUN chmod +x /usr/bin/build-pacman-repo

COPY run.bash /app/run.bash
RUN chmod +x /app/run.bash

RUN echo "BUILDENV=(distcc fakeroot color !ccache check !sign)" >> /etc/makepkg.conf
RUN echo "MAKEFLAGS=$MAKEFLAGS" >> /etc/makepkg.conf
RUN echo "DISTCC_HOSTS="$DISTCC_HOSTS"" >> /etc/makepkg.conf

WORKDIR /app
RUN export PATH="/usr/lib/ccache/bin:/usr/lib/distcc/bin:${PATH}"
ENTRYPOINT ["/bin/bash", "/app/run.bash"]