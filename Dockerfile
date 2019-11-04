FROM balenalib/rpi-raspbian
MAINTAINER muallin@gmail.com

WORKDIR /src
WORKDIR git

# Update system
RUN apt-get update && \
    apt-get -y install git qt5-default libpoppler-qt5-dev libpoppler-qt5-1 wget unzip libqt5sql5-sqlite libqt5sql5 sqlite3 libqt5network5 libqt5gui5 libqt5core5a build-essential qt5-qmake desktop-file-utils qtbase5-dev qtmultimedia5-dev libpoppler-qt5-dev qtscript5-dev libqt5opengl5-dev libglu1-mesa-dev qtdeclarative5-dev make g++ mercurial
RUN git clone https://github.com/YACReader/yacreader.git . && \
    git checkout 9.6.2
RUN cd compressed_archive/unarr/ && \
    wget github.com/selmf/unarr/archive/master.zip &&\
    unzip master.zip  &&\
    rm master.zip &&\
    cd unarr-master/lzmasdk &&\
    ln -s 7zTypes.h Types.h
RUN cd /src/git/YACReaderLibraryServer && \
    qmake YACReaderLibraryServer.pro && \
    make  && \
    make install
RUN cd /     && \
    rm -rf /src && \
    rm -rf /var/cache/apt &&\
    apt-get purge -y git wget build-essential && \
    apt-get -y autoremove
ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/

VOLUME /comics

EXPOSE 8080

ENV LC_ALL=C.UTF8

ENTRYPOINT ["YACReaderLibraryServer","start"]
