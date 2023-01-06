FROM ubuntu:latest

ARG obsidianVersion=1.1.9
ARG nodeVersion=18
RUN apt-get update && \
  apt-get install -yq tzdata && \
  ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata
ENV TZ="America/Chicago"

RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  gconf-service \
  gconf2 \
  gnome-keyring \
  libappindicator1 \
  libasound2 \
  libatomic1 \
  libc++1 \
  libcanberra-gtk3-module \
  libcap2 \
  libdrm2 \
  libgconf-2-4 \
  libgbm1 \
  libgtk-3-0 \
  libnotify4 \
  libnspr4 \
  libnss3 \
  libpulse0 \
  libx11-xcb1 \
  libxkbfile1 \
  libxss1 \
  libxtst6 \
  xdg-utils \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get autoclean

RUN curl -fsSL https://deb.nodesource.com/setup_${nodeVersion}.x | bash - \
  && apt-get update && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*  \
  && npm install -g electron

RUN groupadd obsidian \
  && useradd -g obsidian -m -d /home/obsidian obsidian


RUN curl -sLo /obsidian.tgz https://github.com/obsidianmd/obsidian-releases/releases/download/v${obsidianVersion}/obsidian-${obsidianVersion}.tar.gz \
  && tar -C / -xf /obsidian.tgz \
  && rm /obsidian.tgz \
  && ln -s /obsidian-${obsidianVersion} /obsidian

RUN chown root:root /usr/lib/node_modules/electron/dist/chrome-sandbox  \
  && chmod 4755 /usr/lib/node_modules/electron/dist/chrome-sandbox

USER obsidian
WORKDIR /home/obsidian
ENTRYPOINT [ "/usr/bin/electron", "--enable-features=UseOzonePlatform", "--ozone-platform=wayland", "/obsidian/resources/app.asar" ]
