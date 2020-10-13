#!/bin/bash
set -e
set -m
echo "Started ENTRYPOINT script"

if [ $# -eq 0 ]; then
    echo -e "No Options Specified. Using Default Value: https = false, timeout = 60 (seconds)"
    rm -f /etc/nginx/sites-enabled/mlapp-tls.conf
else
    while [ -n "$1" ]; do
        case "$1" in 
        -https)
            https_value=$2
            if [ ${https_value} = "true" ]; then
                rm -f /etc/nginx/sites-enabled/mlapp.conf
                echo "USING HTTPS - Docker Compose Port 32768"
            elif [ ${https_value} = "false" ]; then
                rm -f /etc/nginx/sites-enabled/mlapp-tls.conf
                echo "NOT USING HTTPS - Docker Compose Port 32767"
            else
                echo "Invalid Option for https: $https_value" 
                exit 1
            fi
            shift
            ;;
        -timeout)
            timeout_value=$2
            if [ $timeout_value -lt 5 ] || [ $timeout_value -gt 1000 ]; then
                echo "Timeout must be between 5 to 1000 seconds"
                exit 1
            else 
                echo "Using timeout ${timeout_value} seconds"
                sed -i "s/keepalive_timeout 65/keepalive_timeout $timeout_value/g" /etc/nginx/nginx.conf
            fi
            shift
            ;;
        *)
            echo "Option Not Recognised"
            echo $1 $2
            #shift
            ;;
        esac   
        shift
    done
fi

# Remove nGinx Banner Grabbing
sed -i "s/# server_tokens off/server_tokens off/g" /etc/nginx/nginx.conf

# Link Logfiles to Console
ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
ln -sf /dev/stdout /home/mluser/app/mlapp-access.log && ln -sf /dev/stderr /home/mluser/app/mlapp-error.log

# Run Supervisord
supervisord
