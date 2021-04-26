FROM amazoncorretto:latest

EXPOSE 8080/tcp
EXPOSE 50000/tcp

RUN yum -y upgrade \
 && yum -y install wget initscripts \
 && yum clean all \
 && rm -rf /var/cache/yum

RUN wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

RUN rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

RUN yum -y upgrade \
 && yum install -y jenkins

CMD service jenkins start && sleep 1 && tail -F /var/log/jenkins/jenkins.log