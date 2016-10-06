FROM debian:jessie
MAINTAINER Robert Reihs <robert.reihs@medunigraz.at>

ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN chmod a+x *.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]