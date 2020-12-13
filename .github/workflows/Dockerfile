ARG ARCH=x86-64
ARG VERSION=snapshot
FROM openwrtorg/rootfs:$ARCH:$VERSION

ADD entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
