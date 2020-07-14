FROM openjdk:8u171-jdk-slim-stretch

MAINTAINER "Carlos Diaz"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install wget sysstat locales python2.7 -y --no-install-recommends && \
    apt-get autoclean && apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    sed -i -e '/^assistive_technologies=/s/^/#/' /etc/java-*-openjdk/accessibility.properties && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen


RUN set -x \
# Add cassandra user
    && groupadd -r cassandra --gid=999 \
    && useradd -m -d "/cqlsh-6.7.8" -r -g cassandra --uid=999 cassandra

COPY --chown=cassandra:cassandra cqlsh-6.7.8/ /


ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV PATH=/cqlsh-6.7.8/bin:$PATH

USER cassandra

ENTRYPOINT ["cqlsh"]
