FROM mono:4.2.3.4

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz /tmp/

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

RUN apt-get update \
        && apt-get install -y curl apt-utils \
        && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

RUN echo "deb http://download.mono-project.com/repo/debian wheezy/snapshots/4.2.3.4/. main" > /etc/apt/sources.list.d/mono-xamarin.list \
        && apt-get update \
	&& apt-get -y upgrade  \
        && apt-get -y install binutils procps mono-4.0-service adduser net-tools sudo nano openssh-server \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./linux32.tar /haasonline

ADD ./haasbot.sh /haasonline/haasbot.sh

ADD ./haasbot-setup.sh /haasonline/haasbot-setup.sh

WORKDIR /haasonline/bin

EXPOSE 8090 8092 2222

ENV MONO_FRAMEWORK_PATH=/usr/lib/mono

ENV DYLD_FALLBACK_LIBRARY_PATH=/haasonline:/usr/lib/mono/lib:/lib:/usr/lib

ENV PATH=/usr/lib/mono/bin:/usr/lib/mono/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV LISTEN_ON 8090

RUN cd /haasonline

RUN /haasonline/BetaUpdate.sh

RUN rm /haasonline/BetaUpdate.sh

RUN rm /haasonline/Update.sh

RUN mkdir /var/run/sshd

RUN echo 'root:haasbot' | chpasswd

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"

RUN echo "export VISIBLE=now" >> /etc/profile

CMD ["/usr/sbin/sshd", "-D"]

