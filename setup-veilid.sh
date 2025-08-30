#!/bin/bash

# Add groups
addgroup --system veilid
addgroup ubuntu
usermod -a -G ubuntu root
usermod -a -G ubuntu sys

# Add veilid user
adduser --disabled-password --gecos "veilid" --shell /bin/bash --ingroup veilid veilid
usermod -a -G users,admin veilid
echo 'veilid ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/veilid

# Add SSH key
mkdir -p /home/veilid/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDt+tQz7i6Egl61UeMrjgRoQxKFiNr0EJFE+8baQsg+I" >> /home/veilid/.ssh/authorized_keys
chown -R veilid:veilid /home/veilid/.ssh
chmod 700 /home/veilid/.ssh
chmod 600 /home/veilid/.ssh/authorized_keys

# Install Veilid
wget -O- https://packages.veilid.net/gpg/veilid-packages-key.public | gpg --dearmor -o /usr/share/keyrings/veilid-packages-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/veilid-packages-keyring.gpg] https://packages.veilid.net/apt stable main" | tee /etc/apt/sources.list.d/veilid.list >/dev/null
apt update
apt install -y veilid-server veilid-cli
systemctl enable --now veilid-server.service

# Disable root login and password auth
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

# Set up automatic updates
echo "0 5 * * * root /usr/bin/apt update -y" >> /etc/crontab
echo "5 5 * * * root DEBIAN_FRONTEND=noninteractive /usr/bin/apt install --only-upgrade veilid-server veilid-cli -y" >> /etc/crontab
