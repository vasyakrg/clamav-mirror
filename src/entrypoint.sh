#!/bin/bash
set -eo pipefail

CVD_DIR="${CVD_DIR:=/mnt/cvdupdate}"

# Configuration Functions
check_config() {
    if [ ! -e $CVD_DIR/config.json ]; then
        echo "Missing CVD configuration. Creating..."
        cvd config set --config $CVD_DIR/config.json --dbdir $CVD_DIR/databases --logdir $CVD_DIR/logs
        echo "CVD configuration created..."
    fi
}

show_config() {
    echo "CVD-Update configuration..."
    cvd config show --config $CVD_DIR/config.json
    echo "Current contents in $CVD_DIR/databases directory..."
    ls -al $CVD_DIR/databases
}

# CVD Database Functions
check_database() {
    if [ ! -e $CVD_DIR/databases ]; then
        echo "Missing CVD database directory. Attempting to update..."
        check_config
        show_config
        update_database
    fi
}

serve_database() {
    if [ -e $CVD_DIR/databases ]; then
        echo "Hosting ClamAV Database..."
        if [ -e /mnt/Caddyfile ]; then
            echo "Add cron with ${CRONTAB_TIME}"
            echo "${CRONTAB_TIME} /opt/app-root/src/entrypoint.sh update >> /var/log/clamv-update.log" | /usr/bin/crontab -
            echo "Using mounted Caddyfile config..."
            crond -f &
            exec caddy run --config ./Caddyfile --adapter caddyfile
        else
            echo "Add cron with ${CRONTAB_TIME}"
            echo "${CRONTAB_TIME} /opt/app-root/src/entrypoint.sh update >> /var/log/clamv-update.log" | /usr/bin/crontab -
            echo "Using default Caddyfile config..."
            crond -f &
            exec caddy run --config ./Caddyfile --adapter caddyfile
        fi
    else
        echo "CVD database is missing..."
        exit 1
    fi
}

update_database() {
    echo "Updating ClamAV Database..."
    cvd update --config $CVD_DIR/config.json
    echo "ClamAV Database updated..."
}

# Argument Handler
case "$1" in
    status)
        check_config
        show_config
    ;;

    update)
        check_config
        show_config
        update_database
    ;;

    serve|*)
        check_database
        serve_database
    ;;
esac
