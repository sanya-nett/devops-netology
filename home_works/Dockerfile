FROM httpd:alpine

LABEL maintainer="scherba.alexander@gmail.com"
LABEL description="Apache Web Server with custom statics"
LABEL version="0.1-snapshot"

COPY ./index.html /usr/local/apache2/htdocs/

RUN nohup sh -c "httpd-foreground"

CMD ["shell"]




