FROM beevelop/java

MAINTAINER Bo-Yi Wu "appleboy.tw@gmail.com"

# Define dependencies
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.3-linux.zip" \ 
    ANDROID_APIS="android-21,android-22,android-23,android-24,android-25" \
    ANDROID_BUILD_TOOLS="build-tools-22.0.1,build-tools-24.0.0,build-tools-24.0.1,build-tools-24.0.2,build-tools-24.0.3,build-tools-25.0.0,build-tools-25.0.2" \ 
    ANDROID_BUILD_TOOLS_VERSION=25.0.2 \
    ANDROID_EXTRAS="addon-google_apis_x86-google-21,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services" \ 
    ANDROID_IMAGES="sys-img-armeabi-v7a-android-24" \
    ANDROID_HOME="/opt/android" \    
    GRADLE_HOME="/usr/share/gradle"


# Copy install tools
COPY tools /opt/tools

# Setup environment
ENV PATH ${PATH}:/opt/tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$GRADLE_HOME/bin

WORKDIR /opt

# Install Deps
RUN dpkg --add-architecture i386 && \
  apt-get -qq update && \
  apt-get -qq install -y wget curl gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386

# Installs Android SDK
RUN mkdir -p android && cd android && \
  wget -O tools.zip ${ANDROID_SDK_URL} && \
  unzip tools.zip && rm tools.zip && \
  /opt/tools/android-accept-licenses.sh "android update sdk --all --no-ui --filter platform-tools,tools,${ANDROID_APIS},${ANDROID_BUILD_TOOLS},${ANDROID_EXTRAS},${ANDROID_IMAGES}" \
  chmod a+x -R $ANDROID_HOME && \
  chown -R root:root $ANDROID_HOME

RUN which adb && \
  which android

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
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
