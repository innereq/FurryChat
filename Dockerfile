FROM ubuntu:18.04

ENV ANDROID_HOME="/opt/android-sdk" \  
    PATH="/opt/android-sdk/tools/bin:/home/inex/flutter/bin:/home/inex/flutter/bin/cache/dart-sdk/bin:$PATH" \
    PUB_CACHE="/home/inex/.pub-cache"

RUN apt-get update > /dev/null \
    && apt-get -y install --no-install-recommends curl git lib32stdc++6 openjdk-8-jdk-headless cmake unzip ninja-build usbutils android-tools-adb > /dev/null \
    && apt-get --purge autoremove > /dev/null \
    && apt-get autoclean > /dev/null \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b dev https://github.com/flutter/flutter.git /home/inex/flutter

RUN curl -s -O https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
    && mkdir /opt/android-sdk \
    && unzip sdk-tools-linux-4333796.zip -d /opt/android-sdk > /dev/null \
    && rm sdk-tools-linux-4333796.zip

RUN mkdir ~/.android \
    && echo 'count=0' > ~/.android/repositories.cfg \
    && yes | sdkmanager --licenses > /dev/null \
    && sdkmanager "tools" "build-tools;29.0.0" "platforms;android-29" "platform-tools" "ndk-bundle" \
    && yes | sdkmanager --licenses > /dev/null \
    && flutter doctor -v
 #   && chown -R root:root /opt

 EXPOSE 41905