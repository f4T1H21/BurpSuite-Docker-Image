# Written by Şefik Efe aka f4T1H
# Licensed under the GNU General Public License v3.0
# See https://github.com/f4T1H21/BurpSuite-Docker-Image for more details

# Use latest Debian image release.
FROM debian:latest

# Set default shell for both buildtime and runtime.
SHELL ["/bin/bash", "-c"]

# Because frontend dialog does not exists,
# ignore interactive config for packages with
# interactive config enabled on their defaults.
ARG DEBIAN_FRONTEND=noninteractive

# Update package lists and install packages.
RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get install -y iputils-ping unzip nano \
                       dbus-x11 packagekit-gtk3-module \
                       libcanberra-gtk3-module openjdk-11-jdk \
                       xclip iproute2 netcat curl wget fonts-roboto
RUN apt-get clean

# Copy Burp Suite file.
RUN mkdir -p /root/burpsuite
WORKDIR /root/burpsuite
COPY burpsuite.zip .
RUN unzip -P 12345 burpsuite.zip

# Download and Install JetBrains Mono fonts.
WORKDIR /root
RUN wget https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip
RUN mkdir /usr/share/fonts/ttf
RUN unzip -j JetBrainsMono-2.242.zip fonts/ttf/* -d /usr/share/fonts/ttf/
RUN rm JetBrainsMono-2.242.zip

# Generate machine UUID.
RUN  dbus-uuidgen > /etc/machine-id

# Create handy aliases.
RUN echo "alias burpsuite='java -jar -Xmx4g /root/burpsuite/burpsuite_pro.jar'" \
                          >> /root/.bashrc

RUN echo "alias c=\"echo -e '\033[0m'\" # Reset terminal color" >> /root/.bashrc
RUN echo "alias cls='clear'" >> /root/.bashrc
RUN echo "alias ee='exit'" >> /root/.bashrc

# Fire up Burp Suite whenever bash runs (.bashrc file gets executed).
RUN echo 'burpsuite &' >> /root/.bashrc