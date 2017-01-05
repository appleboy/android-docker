FROM ubuntu:14.04

MAINTAINER Bo-Yi Wu "appleboy.tw@gmail.com"

# Define dependencies
# SDK Tools revisions: https://developer.android.com/studio/releases/sdk-tools.html
# SDK Build Tools revisions: https://developer.android.com/studio/releases/build-tools.html
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.4-linux.zip" \ 
    ANDROID_SDK_PLATFORMS="android-21,android-22,android-23,android-24,android-25" \
    ANDROID_BUILD_TOOLS="build-tools-22.0.1,build-tools-24.0.0,build-tools-24.0.1,build-tools-24.0.2,build-tools-24.0.3,build-tools-25.0.0,build-tools-25.0.2" \ 
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
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools

# Install Android SDK
RUN cd /opt && wget --output-document=android-sdk.tgz --quiet ${ANDROID_SDK_URL} && \
  tar xzf android-sdk.tgz && \
  rm -f android-sdk.tgz && \
  chown -R root.root android-sdk-linux && \
  /opt/tools/android-accept-licenses.sh "android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,tools,${ANDROID_SDK_PLATFORMS},${ANDROID_BUILD_TOOLS},${ANDROID_EXTRAS},${ANDROID_IMAGES}"

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN which adb
RUN which android

# Create emulator
RUN echo "no" | android create avd \
  --force \
  --device "Nexus 5" \
  --name test \
  --target android-24 \
  --abi armeabi-v7a \
  --skin WVGA800 \
  --sdcard 512M

# Cleaning
RUN apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
