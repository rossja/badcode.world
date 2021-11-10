#!/bin/bash
# ==============================================
# Installs the littlest jupyterhub on ubuntu hosts
# ----------------------------------------------
# maintainer: Jason Ross <algorythm@gmail.com>
# ==============================================
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -q -y lsb-release curl ca-certificates

# ==============================================
# PARAMS:
#  1: DOMAIN - the domain name to use for this host
#  2: ADMINUSER - the username for the admin user
#  3: LEMAIL - email address to use for letsencrypt
# ==============================================
DOMAIN=${1:-'badcode.world'}
ADMINUSER=${2:-'rossja'}
LEMAIL=${3:-'algorythm@gmail.com'}

echo "SETTTING UP USING THE FOLLOWING: DOMAIN=${DOMAIN}, ADMINUSER=${ADMINUSER}, LEMAIL=${LEMAIL}"

# install prereqs
apt-get install -q -y python3 python3-dev git

pip3 install\
  beautifulsoup4\
  numpy\
  pandas\
  pymongo\
  pyyaml\
  pyInquirer\
  requests\
  sqlalchemy\

# install tljh
curl -L https://tljh.jupyter.org/bootstrap.py | sudo -E python3 - --admin $ADMINUSER

# HTTPS config
tljh-config set https.enabled true
tljh-config set https.letsencrypt.email $LEMAIL
tljh-config add-item https.letsencrypt.domains $DOMAIN
tljh-config add-item https.letsencrypt.domains www.$DOMAIN
tljh-config reload proxy

# Auth config
#tljh-config set auth.type nativeauthenticator.NativeAuthenticator
#tljh-config reload
