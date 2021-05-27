FROM node:14

ENV DEBIAN_FRONTEND="noninteractive"
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"

# Set locale
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"

# Configure locale
RUN wget -qO - https://raw.githubusercontent.com/yarnpkg/releases/gh-pages/debian/pubkey.gpg | apt-key add -
RUN apt-get clean \
    && apt-get update \
    && apt-get install -y apt-utils locales \
    && locale-gen ${LANG} \
    && localedef -i en_US -f UTF-8 en_US.UTF-8

# Installing packages
RUN apt-get install -y \
        build-essential \
        autoconf \
        libtool \
        nasm \
        automake \
        curl \
        git \
        file \
        less \
        gpg-agent \
        lib32stdc++6 \
        lib32z1 \
        lib32z1-dev \
        lib32ncurses5 \
        libc6-dev \
        libgmp-dev \
        libmpc-dev \
        libmpfr-dev \
        libxslt-dev \
        libxml2-dev \
        libpng-dev \
        m4 \
        ncurses-dev \
        ocaml \
        openjdk-8-jdk \
        openssh-client \
        pkg-config \
        software-properties-common \
        software-properties-common \
        unzip \
        wget \
        zip \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

# Installing cordova
RUN npm install -g cordova \
    && npm rebuild node-sass \
    && cordova telemetry off \
    && npm cache clean --force \
    && rm -rf /tmp/* /var/tmp/*

# Installing Android NDK and Tools
ARG ANDROID_NDK_VERSION="21"
ARG ANDROID_BUILD_TOOLS_VERSION="29.0.2"
ARG ANDROID_SDK_TOOLS_VERSION="7302050"

ENV ANDROID_SDK_ROOT="/opt/android-sdk"
ENV ANDROID_NDK="/opt/android-ndk"
ENV ANDROID_SDK_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip"
ENV ANDROID_NDK_HOME="${ANDROID_NDK}/android-ndk-r${ANDROID_NDK_VERSION}"
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_NDK}"

RUN mkdir -p "${ANDROID_SDK_ROOT}" \
    && cd "${ANDROID_SDK_ROOT}" \
    && curl -o sdk.zip ${ANDROID_SDK_TOOLS_URL} \
    && unzip sdk.zip -d /tmp \
    && rm sdk.zip \
    && mkdir cmdline-tools \
    && mv /tmp/cmdline-tools cmdline-tools/tools \
    && mkdir "${HOME}/.android" \
    && echo '### User Sources for Android SDK Manager' > "${HOME}/.android/repositories.cfg" \
    && yes | sdkmanager --licenses \
    && echo "Installing build tools " \
    && yes | sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"

# Installing gradle
ARG GRADLE_VERSION="6.5"
ENV GRADLE_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
ENV PATH="${PATH}:/opt/gradle/bin"

RUN cd /opt \
    && wget ${GRADLE_URL} -O gradle.zip \
    && unzip gradle.zip \
    && mv gradle-${GRADLE_VERSION} gradle/ \
    && rm gradle.zip \
    && cd gradle \
    && bin/gradle wrapper --distribution-type all \
    && ./gradlew build

WORKDIR /app

