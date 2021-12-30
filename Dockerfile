FROM registry.access.redhat.com/ubi8/ubi-minimal

RUN microdnf install --setopt=install_weak_deps=0 --setopt=tsflags=nodocs \
        openssh-server openssh-clients && \
    microdnf clean all

RUN sed -i 's/#Port .*/Port 2200/g' /etc/ssh/sshd_config
RUN sed -i 's/PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -i 's/GSSAPIAuthentication .*/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin .*/PermitRootLogin no/g' /etc/ssh/sshd_config
RUN sed -i 's/X11Forwarding .*/X11Forwarding no/g' /etc/ssh/sshd_config
RUN sed -i 's/#GatewayPorts .*/GatewayPorts yes/g' /etc/ssh/sshd_config

# Separate dir for host keys to allow mounting as persistent volume
RUN mkdir /etc/ssh/hostkeys
RUN sed -i 's/HostKey \/etc\/ssh/HostKey \/etc\/ssh\/hostkeys/g' /etc/ssh/sshd_config

RUN adduser sshuser
# To run sshd as non-root
RUN chown -R sshuser:sshuser /etc/ssh

ADD entrypoint.sh /

USER sshuser

# Persistent
RUN mkdir /home/sshuser/.ssh
