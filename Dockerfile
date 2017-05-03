FROM ubuntu:14.04

MAINTAINER Bo-Yi Wu "appleboy.tw@gmail.com"

# SDK Tools revisions: https://developer.android.com/studio/releases/sdk-tools.html
# SDK Build Tools revisions: https://developer.android.com/studio/releases/build-tools.html
# Define dependencies
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.4-linux.zip" \ 
    ANDROID_SDK_PLATFORMS="android-21,android-22,android-23,android-24,android-25" \
    ANDROID_BUILD_TOOLS="build-tools-22.0.1,build-tools-24.0.0,build-tools-24.0.1,build-tools-24.0.2,build-tools-24.0.3,build-tools-25.0.0,build-tools-25.0.1,build-tools-25.0.2,build-tools-25.3.1" \ 
    ANDROID_EXTRAS="addon-google_apis_x86-google-21,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services" \ 
    ANDROID_IMAGES="sys-img-armeabi-v7a-android-24"

# Install java8
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl libqt5widgets5 && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy install tools
COPY tools /opt/sh-tools
ENV PATH ${PATH}:/opt/sh-tools

ENV ANDROID_HOME /opt/android-sdk-linux

RUN apt-get update && apt-get install unzip

# Install Android SDK
RUN cd /opt && wget -q ${ANDROID_SDK_URL} -O android-sdk-tools.zip && \
  unzip -q android-sdk-tools.zip && \
  rm -f android-sdk-tools.zip && \
  mkdir ${ANDROID_HOME} && \
  mv /opt/tools/ ${ANDROID_HOME}/ && \
  chown -R root.root android-sdk-linux && \
  /opt/sh-tools/android-accept-licenses.sh "${ANDROID_HOME}/tools/android update sdk --all --no-ui --filter platform-tools,tools,${ANDROID_SDK_PLATFORMS},${ANDROID_BUILD_TOOLS},${ANDROID_EXTRAS},${ANDROID_IMAGES}"

# Setup environment
ENV PATH ${PATH}:${ANDROID_HOME}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# accept the license agreements of the SDK components
RUN export ANDROID_LICENSES="$ANDROID_HOME/licenses" && \
    [ -d $ANDROID_LICENSES ] || mkdir $ANDROID_LICENSES && \
    [ -f $ANDROID_LICENSES/android-sdk-license ] || echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_LICENSES/android-sdk-license && \
    [ -f $ANDROID_LICENSES/android-sdk-preview-license ] || echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_LICENSES/android-sdk-preview-license && \
    [ -f $ANDROID_LICENSES/intel-android-extra-license ] || echo d975f751698a77b662f1254ddbeed3901e976f5a > $ANDROID_LICENSES/intel-android-extra-license && \
    unset ANDROID_LICENSES

RUN which android

# Cleaning
RUN apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
