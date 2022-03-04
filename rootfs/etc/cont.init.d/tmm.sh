#!/usr/bin/with-contenv sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

log() {
    echo "[cont-init.d] $(basename $0): $*"
}

# Make sure mandatory directories exist.
mkdir -p /config/logs

if [ ! -f /config/tmm.jar ]; then
    cp -r /defaults/* /config/
    cd /config
    tar zxvf /config/tmm.tar.gz
fi

# Take ownership of the config directory content.
chown -R $USER_ID:$GROUP_ID /config/*
