# kube-ssh-proxy

Reverse proxy to access kubernetes services in cluster behind NAT. Using reverse SSH to public cluster.

## How it works

![](/diagram.png)

## Local usage

    # Terminal 1
    docker-compose build
    docker-compose up

    # Terminal 2
    # Add to authorized keys on server
    docker cp kube-ssh-proxy-client:/home/sshuser/.ssh/id_rsa.pub /tmp
    docker cp /tmp/id_rsa.pub kube-ssh-proxy-server:/home/sshuser/.ssh/authorized_keys

    # Copy dispatcher configuration from git and reload
    docker cp ./dispatcher.conf kube-ssh-proxy-client-dispatcher:/etc/nginx/conf.d/default.conf
    docker exec -it kube-ssh-proxy-client-dispatcher nginx -s reload

    curl http://localhost:8000/svc-1 # Proxies to local-svc-mock-1
    curl http://localhost:8000/svc-2 # Proxies to local-svc-mock-2

## Release (multi-arch)

    docker buildx build --platform linux/amd64,linux/arm64 --push -t jdobes/kube-ssh-proxy:latest -t jdobes/kube-ssh-proxy:0.1 .
