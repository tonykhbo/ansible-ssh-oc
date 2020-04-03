FROM       ubuntu:16.04

RUN apt-get update
RUN apt-get install -y curl

RUN curl -s -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.3/linux/oc.tar.gz && \
    tar -C /usr/local/bin -zxf /tmp/oc.tar.gz oc && \
    ln -s /usr/local/bin/oc /usr/local/bin/kubectl && \
    rm /tmp/oc.tar.gz

RUN apt-get install -y openssh-server

RUN mkdir /var/run/sshd

RUN echo 'root:password' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN chmod 0755 /var/run/sshd

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]