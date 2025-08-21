# Usa una imagen base MÁS NUEVA y ESPECÍFICA para GitPod
FROM gitpod/workspace-full:latest

# Instala ONLY las dependencias CRÍTICAS para evitar conflictos
RUN sudo apt-get update && \
    sudo apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils && \
    sudo rm -rf /var/lib/apt/lists/*

# Configura la variable de entorno para Java
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# ----- PASO CRÍTICO: Obtener las herramientas CORRECTAS de Android -----
# Descarga la versión MÁS NUEVA de las command-line tools desde la página oficial
# NOTA: La URL puede cambiar. Si falla, visita https://developer.android.com/studio#command-tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O /tmp/android-tools.zip && \
    mkdir -p /home/gitpod/android-sdk/cmdline-tools && \
    unzip -q /tmp/android-tools.zip -d /home/gitpod/android-sdk/cmdline-tools && \
    mv /home/gitpod/android-sdk/cmdline-tools/cmdline-tools /home/gitpod/android-sdk/cmdline-tools/latest && \
    rm /tmp/android-tools.zip

# Configura las variables de entorno del SDK de Android (ESENCIAL)
ENV ANDROID_SDK_ROOT=/home/gitpod/android-sdk
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

# Acepta las licencias de Android SDK de forma NO interactiva
RUN yes | sdkmanager --licenses

# Instala las herramientas y plataformas MÍNIMAS para compilar
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Crea un proyecto de Android vacío para probar
RUN cd /home/gitpod && \
    mkdir -p myapp && \
    cd myapp && \
    echo "✅ Entorno de Android configurado con éxito." > README.txt
