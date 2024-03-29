#!/bin/bash

if [[ ! -z $1 ]]; then
    if [[ "$1" == "server" ]]; then
        if [ -z "$(ls -A /etc/ssh/hostkeys)" ]; then
            echo "Generating host keys..."
            /usr/bin/ssh-keygen -A
            mv /etc/ssh/ssh_host_* /etc/ssh/hostkeys/
        else
            echo "Host keys exist, skipping generation."
        fi
        exec /usr/sbin/sshd -D -o "ClientAliveInterval=60"
    elif [[ "$1" == "client" ]]; then
        if [ -z "$(ls -A /home/sshuser/.ssh)" ]; then
            echo "Generating client keys..."
            /usr/bin/ssh-keygen -f /home/sshuser/.ssh/id_rsa -P ""
        else
            echo "Client keys exist, skipping generation."
        fi
        cat /home/sshuser/.ssh/id_rsa.pub

        if [ -z "$SSH_SERVER_HOST" ]; then
            echo "SSH_SERVER_HOST is not set!"
            exit 2
        fi

        if [ -z "$SSH_SERVER_PORT" ]; then
            echo "SSH_SERVER_PORT is not set!"
            exit 2
        fi

        if [ -z "$DISPATCHER_HOST" ]; then
            echo "DISPATCHER_HOST is not set!"
            exit 2
        fi

        if [ -z "$DISPATCHER_PORT" ]; then
            echo "DISPATCHER_PORT is not set!"
            exit 2
        fi

        exec /usr/bin/ssh -o "StrictHostKeyChecking=no" \
                          -o "ServerAliveInterval=60" \
                          -t -t \
                          -p $SSH_SERVER_PORT \
                          -R 8000:$DISPATCHER_HOST:$DISPATCHER_PORT \
                          sshuser@$SSH_SERVER_HOST
    fi
fi

echo "Please specify service name as the first argument."
exit 1
