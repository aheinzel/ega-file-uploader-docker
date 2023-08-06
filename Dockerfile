FROM openjdk:22-jdk-bullseye

RUN apt-get update && \
   apt-get install curl

RUN groupadd ega && \
   useradd -m -s /bin/bash -g ega ega

USER ega

RUN TD=`mktemp -d` && \
   curl -L "https://d3gcli72yxqn2z.cloudfront.net/downloads/connect/latest/bin/ibm-aspera-connect_4.2.6.393_linux_x86_64.tar.gz" | \
   tar -C "$TD" -zxf - && \
   bash $TD/*sh && \
   rm -r "$TD"

RUN mkdir "/home/ega/.egacryptor" &&\
   cd "/home/ega/.egacryptor" && \
   TD=`mktemp -d` && \
   curl -L "https://ega-archive.org/files/EgaCryptor.zip" > "$TD/EgaCryptor.zip" && \
   unzip "$TD/EgaCryptor.zip" && \
   rm  -r "$TD" && \
   mv EGA-Cryptor-2.0.0/ega-cryptor-2.0.0.jar . && \
   rm -r "EGA-Cryptor-2.0.0"

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
