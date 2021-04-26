FROM ubuntu:20.04

EXPOSE 8080/tcp
EXPOSE 50000/tcp

RUN apt-get update \
 && apt-get install -y --no-install-recommends wget openjdk-11-jdk-headless gnupg2 \
 && rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -

RUN echo deb https://pkg.jenkins.io/debian-stable binary/ \
    > /etc/apt/sources.list.d/jenkins.list

RUN apt-get update \
 && apt-get install -y daemon jenkins net-tools psmisc

CMD service jenkins start && tail -F /var/log/jenkins/jenkins.log