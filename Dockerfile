FROM utensils/opengl:stable

# Install all needed runtime dependencies.
RUN \
  set -xe; \
  apk --update add --no-cache --virtual .runtime-deps \
    bash \
    ffmpeg \
    git \
    gource \
    imagemagick; \
  mkdir -p /gource; \
  mkdir -p /gource/logs; \
  mkdir -p /gource/avatars; \
  mkdir -p /gource/git_repo; \
  mkdir -p /gource/git_repos; \
  mkdir -p /gource/output;

# Copy scripts into image.
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./gource.sh /usr/local/bin/gource.sh

# Add executable right to scripts
RUN \
  chmod +x /usr/local/bin/entrypoint.sh; \
  chmod +x /usr/local/bin/gource.sh;

# Set our working directory.
WORKDIR /gource
RUN chmod -R 777 /gource

# Set our environment variables.
ENV \
  DISPLAY=":99" \
  GLOBAL_FILTERS="" \
  GOURCE_FILTERS="" \
  GOURCE_USER_IMAGE_DIR="/gource/avatars" \
  H264_CRF="23" \
  H264_LEVEL="5.1" \
  H264_PRESET="medium" \
  INVERT_COLORS="false" \
  OVERLAY_FONT_COLOR="0f5ca8" \
  XVFB_WHD="3840x2160x24" \
  GOURCE_FPS="60"

# Set our entrypoint.
ENTRYPOINT  ["bash", "/usr/local/bin/entrypoint.sh"]
