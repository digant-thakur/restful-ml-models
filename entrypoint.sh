#!/bin/bash
set -e
set -m
echo "Started ENTRYPOINT script"
echo $@
if [ $# -eq 0 ]; then
    echo -e "Invalid CMD Override. \nVALID OPTIONS USAGE: \n\t-ssl {true/false} -timeout {integer}"
    rm -f /etc/nginx/sites-enabled/mlapp-tls.conf
else
    while [ -n "$1" ]; do
        case "$1" in 
        -ssl)
            ssl_value=$2
            if [ ${ssl_value} = "true" ]; then
                rm -f /etc/nginx/sites-enabled/mlapp.conf
                echo "USING HTTPS"
            elif [ ${ssl_value} = "false" ]; then
                rm -f /etc/nginx/sites-enabled/mlapp-tls.conf
                echo "NOT USING HTTPS"
            else
                echo "Invalid Option for SSL: $ssl_value" 
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

ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
supervisord
