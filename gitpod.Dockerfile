FROM gitpod/workspace-base

RUN sudo apt-get update && \
    sudo apt-get install -y \
    libc6-dev \
    libgtk-3-dev \
    libnss3-dev \
    libasound2-dev \
    libx11-dev \
    fonts-noto \
    openjdk-17-jdk \
    wget \
    unzip && \
    sudo rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/android-tools.zip && \
    mkdir -p /home/gitpod/android-sdk/cmdline-tools && \
    unzip -q /tmp/android-tools.zip -d /home/gitpod/android-sdk/cmdline-tools && \
    mv /home/gitpod/android-sdk/cmdline-tools/cmdline-tools /home/gitpod/android-sdk/cmdline-tools/latest && \
    rm /tmp/android-tools.zip

ENV ANDROID_SDK_ROOT=/home/gitpod/android-sdk
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

RUN cd /home/gitpod && \
    mkdir -p myapp && \
    cd myapp && \
    gradle init --type basic --dsl kotlin --project-name myapp --package myapp && \
    echo "✅ Proyecto base de Gradle creado."
