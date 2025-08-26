# Stage 1: Unzipper Stage - Download and unzip Mediathekview
FROM alpine AS unzipper
WORKDIR /tmp
RUN apk add --no-cache wget unzip \
    && wget -O mtplayer.zip "https://github.com/xaverW/MTPlayer/releases/download/version-20/MTPlayer-20__2025.04.07.zip" \
    && unzip mtplayer.zip -d mtplayer

# Stage 2: Final Stage - Base image with GUI and dependencies
FROM jlesage/baseimage-gui:debian-12-v4

# Set application name and metadata directory
ENV APP_NAME=MTPlayer
# Use Berlin as default timezone and de_DE as language because MTPlayer is for German Television
ENV TZ=Europe/Berlin 
ENV LANG=de_DE.UTF-8
ENV MTPLAYER_AUTO=false
VOLUME ["/config", "/output"]

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/xaverW/MTPlayer/master/src/main/resources/de/p2tools/mtplayer/res/p2_logo_32.png && \
    install_app_icon.sh "$APP_ICON_URL"
    
# Install MTPlayer dependencies: ffmpeg, vlc, and firefox
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    ffmpeg \
    vlc \
    openjdk-17-jre \
    firefox-esr \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Metadata.
LABEL \
      org.label-schema.name="MTPlayer" \
      org.label-schema.description="Docker container for MTPlayer" \
      org.label-schema.version=1.0 \
      org.label-schema.vcs-url="https://github.com/Minegamer06/docker-mtplayer-webinterface" \
      org.label-schema.schema-version="1.0"

# Maximize only the main/initial window.
COPY src/main-window-selection.xml /etc/openbox/main-window-selection.xml

# Copy extracted MTPlayer files from the unzipper stage
COPY --from=unzipper /tmp/mtplayer/MTPlayer /app/mtplayer

# Copy and setup start script
COPY src/startapp.sh /startapp.sh
RUN chmod +x /startapp.sh