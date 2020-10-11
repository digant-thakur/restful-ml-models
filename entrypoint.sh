#!/bin/bash
set -e
set -m
echo "Started ENTRYPOINT script"

if [ $# -eq 0 ]; then
    echo "No Options Specified, Using default values"
fi

while [ -n "$1" ]; do
    case "$1" in 
    -ssl)
        ssl_value="${2:-true}"
        if [ ${ssl_value} == "true" ]; then
            echo "SSL true"
        elif [ ${ssl_value} == "false" ]; then
            echo "SSL False"
        else
            echo "Invalid Option for SSL: $ssl_value" 
            exit 1
        fi
        shift
        ;;
    --timeout)
        timeout_value="${2:-60}"
        if [ $timeout_value -lt 5 ] || [ $timeout_value -gt 1000 ]; then
            echo "Timeout must be between 5 to 1000 seconds"
            exit 1
        else 
            echo "Using timeout ${timeout_value} seconds"
        fi
        ;;
    *)
        echo "Option Not Recognised"
        break
        ;;
    esac   
    shift
done

#ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
#supervisord
