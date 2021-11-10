#!/bin/bash
# ==============================================
# configures sshd with more secure features
# ----------------------------------------------
# maintainer: Jason Ross <algorythm@gmail.com>
# ==============================================
export DEBIAN_FRONTEND=noninteractive

# ==============================================
# PARAMS:
#  1: PORT - port sshd should listen on
#  2: SSHPUBKEY - public key to add
# ==============================================
PORT=${1:-'1312'}
SSHPUBKEY=${2:-'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKhaNPIu9cLzJ8JHITlHb3e/CMasm2zs3vkNbTHL86P'}

mkdir -p ~/.ssh
cat >> ~/.ssh/authorized_keys << EOF
${SSHPUBKEY}
EOF

mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
cat > /etc/ssh/sshd_config << EOF
Port 1312
PermitRootLogin prohibit-password
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
AcceptEnv LANG LC_*
PrintMotd no
Subsystem	sftp	/usr/lib/openssh/sftp-server
UsePAM yes
X11Forwarding yes
EOF


# sed -i -e 's/\#?Port /Port 1312/' /etc/ssh/sshd_config
# sed -i -e 's/.*PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
# sed -i -e 's/.*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
# sed -i -e 's/.*PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
# sed -i -e 's/.*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
systemctl restart ssh
