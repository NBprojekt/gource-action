FROM utensils/opengl:stable

# Install all needed runtime dependencies.
RUN \
  set -xe; \
  apk --update add --no-cache --virtual .runtime-deps \
    bash \
    ffmpeg \
    git \
    gource \
    imagemagick;

# Copy scripts into image
COPY ./entrypoint.sh ./gource.sh /usr/local/bin/

# Add executable right to scripts
RUN \
  chmod +x /usr/local/bin/entrypoint.sh; \
  chmod +x /usr/local/bin/gource.sh;

# Create working directories
RUN \
  mkdir /gource; \
  mkdir /gource/logs; \
  mkdir /gource/avatars; \
  mkdir /gource/git_repo; \
  mkdir /gource/git_repos; \
  mkdir /gource/output;

# Set working directory with full access
WORKDIR /gource
RUN chmod -R 777 /gource

# Set environment variables
ENV \
  DISPLAY=":99" \
  GLOBAL_FILTERS="" \
  GOURCE_FILTERS="" \
  GOURCE_USER_IMAGE_DIR="/gource/avatars" \
  H264_CRF="23" \
  H264_LEVEL="5.1" \
  H264_PRESET="medium" \
  INVERT_COLORS="false" \
  XVFB_WHD="3840x2160x24"

# Set our entrypoint.
ENTRYPOINT  ["bash", "/usr/local/bin/entrypoint.sh"]
