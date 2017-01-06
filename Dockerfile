FROM beevelop/java

MAINTAINER Bo-Yi Wu "appleboy.tw@gmail.com"

# Define dependencies
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.3-linux.zip" \ 
    ANDROID_APIS="android-21,android-22,android-23,android-24,android-25" \
    ANDROID_BUILD_TOOLS="build-tools-22.0.1,build-tools-24.0.0,build-tools-24.0.1,build-tools-24.0.2,build-tools-24.0.3,build-tools-25.0.0,build-tools-25.0.2" \ 
    ANDROID_BUILD_TOOLS_VERSION=25.0.2 \
    ANDROID_EXTRAS="addon-google_apis_x86-google-21,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services" \ 
    ANDROID_HOME="/opt/android" \    
    GRADLE_HOME="/usr/share/gradle"


# Setup environment
ENV PATH ${PATH}:/opt/tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$GRADLE_HOME/bin

# Install Deps
RUN dpkg --add-architecture i386 && \
  apt-get -qq update && \
  apt-get -qq install -y wget curl gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386

# Installs Android SDK
RUN curl -sL ${ANDROID_SDK_URL} | tar xz -C /opt && \
  echo y | android update sdk -a -u -t platform-tools,tools,${ANDROID_APIS},${ANDROID_BUILD_TOOLS},${ANDROID_EXTRAS} && \
  chmod a+x -R $ANDROID_HOME && \
  chown -R root:root $ANDROID_HOME

RUN which adb && \
  which android

# Cleaning
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
