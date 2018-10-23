FROM debian
ENV USER_NAME petr
ENV USER_UID 1000
ENV USER_GID 1000

# Update
RUN apt-get update && apt-get upgrade -y

# Dependencies
RUN apt-get install -y git cmake build-essential libgcrypt11-dev libyajl-dev libboost-all-dev libcurl4-openssl-dev libexpat1-dev libcppunit-dev binutils-dev debhelper zlib1g-dev dpkg-dev pkg-config debhelper

# Download sources
RUN cd /root && git clone https://github.com/vitalif/grive2

RUN cd /root/grive2 && dpkg-buildpackage -j8 && cd .. && \
  file=`ls grive_*deb` && dpkg -i $file && \
  echo "+----------------------------------------------------------------------------------------+" && \
  echo "| sudo docker run -it --rm --name grive2 -v /home/petr/google-drive:/google-drive grive2 |" && \
  echo "+----------------------------------------------------------------------------------------+"

RUN mkdir /google-drive && \
  useradd -d /google-drive -s /bin/bash -u $USER_UID $USER_NAME && \
  chown petr:petr /google-drive

ENTRYPOINT file=`ls /root/grive_*deb` && \
  echo "Copy file $file from container to host, i.e.:" && \
  echo "  sudo docker cp grive2:$file ./" && \
  echo "After that exit this container (CTRL+D)" && \
  su - $USER_NAME && /bin/bash

