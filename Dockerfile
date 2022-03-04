FROM alpine:3.12
# Define software versions.
ARG TMM_VERSION=3.1.16.1

# Define software download URLs.
ARG TMM_URL=https://release.tinymediamanager.org/v3/dist/tmm_${TMM_VERSION}_linux.tar.gz

# Define working directory.
WORKDIR /tmp

#set timezone 
RUN apk add --no-cache tzdata
ENV TZ America/New_York

#add helper packages
COPY helpers/* /usr/local/bin/
COPY ./entrypoint.sh /mnt/entrypoint.sh
RUN chmod +x /usr/local/bin/add-pkg && chmod +x /usr/local/bin/del-pkg && chmod +x /mnt/entrypoint.sh
# Download TinyMediaManager
RUN \
    mkdir -p /defaults && \
    wget ${TMM_URL} -O /defaults/tmm.tar.gz

# Install dependencies.
RUN \
    add-pkg \
        openjdk8-jre \
        libmediainfo \
        bash \
        gettext

# Add files.
COPY rootfs/ /

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/media"]


ENTRYPOINT ["/mnt/entrypoint.sh"]
CMD ["/usr/sbin/crond", "-f", "-d", "0"] 

# Metadata.
LABEL \
      org.label-schema.name="tinymediamanagerCMD" \
      org.label-schema.description="Docker container for TinyMediaManager Command line cron scheduled" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/coolasice1999/crontest" \
      org.label-schema.schema-version="1.0"
