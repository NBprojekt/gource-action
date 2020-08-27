FROM utensils/opengl:stable

# Install all needed runtime dependencies.
RUN \
  set -xe; \
  apk --update add --no-cache --virtual .runtime-deps \
    bash \
    ffmpeg \
    git \
    gource \
    imagemagick \
    py3-pip \
    python3 \
  mkdir -p /gource; \
  mkdir -p /gource/logs; \
  mkdir -p /gource/output;

# Copy scripts into image.
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./gource.sh /usr/local/bin/gource.sh

# Add executable right to scripts
RUN \
  chmod +x /usr/local/bin/entrypoint.sh; \
  chmod +x /usr/local/bin/gource.sh;

# Copy assets
COPY ./assets /gource

# Set our working directory.
WORKDIR /gource
RUN ls -al

# Set our environment variables.
ENV \
    DISPLAY=":99" \
    GIT_URL="https://github.com/acaudwell/Gource.git" \
    GIT_TOKEN="" \
    LOGO_URL="https://avatars1.githubusercontent.com/u/44036562?s=280&v=4" \
    GLOBAL_FILTERS="" \
    GOURCE_TITLE="Software Development" \
    GOURCE_AUTO_SKIP_SECONDS="0.5" \
    GOURCE_BACKGROUND_COLOR="000000" \
    GOURCE_TEXT_COLOR="FFFFFF" \
    GOURCE_CAMERA_MODE="overview" \
    GOURCE_DIR_DEPTH="3" \
    GOURCE_FILENAME_TIME="2" \
    GOURCE_FILTERS="" \
    GOURCE_FONT_SIZE="48" \
    GOURCE_HIDE_ITEMS="usernames,mouse,date,filenames" \
    GOURCE_MAX_USER_SPEED="500" \
    GOURCE_SECONDS_PER_DAY="0.1" \
    GOURCE_TIME_SCALE="1.5" \
    GOURCE_USER_IMAGE_DIR="/gource/avatars" \
    GOURCE_USER_SCALE="1.5" \
    H264_CRF="23" \
    H264_LEVEL="5.1" \
    H264_PRESET="medium" \
    INVERT_COLORS="false" \
    OVERLAY_FONT_COLOR="0f5ca8" \
    TEMPLATE="border" \
    VIDEO_RESOLUTION="1080p" \
    XVFB_WHD="3840x2160x24" \
    GOURCE_FPS="60"

# Set our entrypoint.
ENTRYPOINT  ["bash", "/usr/local/bin/entrypoint.sh"]
