FROM openjdk:8-jre

ARG user=katalon
ARG group=katalon
ARG uid=10000
ARG gid=10000
ARG KATALON_VERSION=6.1.5

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Katalon user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}

ENV KATALON_HOME=/home/${user}/Katalon \
    KATALON_VERSION=${KATALON_VERSION} \
    DISPLAY=:0 \
    XVFB_SCREEN_SIZE=1024x768x24

# katalon-studio
RUN wget -q -O /tmp/Katalon_Studio_Linux_64.tar.gz https://github.com/katalon-studio/katalon-studio/releases/download/v${KATALON_VERSION}/Katalon_Studio_Linux_64-${KATALON_VERSION}.tar.gz && \
    mkdir ${KATALON_HOME} && \
    tar -zxf /tmp/Katalon_Studio_Linux_64.tar.gz -C ${KATALON_HOME} --strip-components=1 && \
    rm -f /tmp/Katalon_Studio_Linux_64.tar.gz && \
    chown -R ${user}.${user} ${KATALON_HOME} && \
    chmod a+x ${KATALON_HOME}/katalon

# google-chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install google-chrome-stable -y

# firefox
RUN apt-get install firefox-esr -y

# xvfb
RUN apt-get install xvfb -y
COPY xvfb /etc/init.d/xvfb
RUN chmod +x /etc/init.d/xvfb

RUN apt-get update && apt-get upgrade -y

RUN firefox --version >> /version && google-chrome --version >> /version

WORKDIR /home/${user}

# entrypoint
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
