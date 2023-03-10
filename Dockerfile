FROM ubuntu:jammy

ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF

LABEL org.label-schema.schema-version = "1.0"
LABEL org.label-schema.name = "NSLCD-Sidecar"
LABEL org.label-schema.description = "NSLCD server in a container"
LABEL org.label-schema.url = ${VCS_URL}
LABEL org.label-schema.build-date = ${BUILD_DATE}
LABEL org.label-schema.vcs-url = ${VCS_URL}
LABEL org.label-schema.vcs-ref = ${VCS_REF}

COPY src/etc /etc
RUN mkdir -p /run/nslcd/ \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get \
    install nslcd libnss-ldapd gettext-base

COPY src /
RUN chown 999.999 /etc/nslcd.conf /run/nslcd/ \
 && chmod 0660 /etc/nslcd.conf \
 && chmod 0755 /usr/local/bin/*

ENV HOME /home
USER 999:999
VOLUME ["/templates", "/run/nslcd", "/run/credentials", "/run/tls"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
