#!/bin/bash

set -euo pipefail

DIST_MODULE_DIR=$1
REMOTE_HOST=cfs
REMOTE_DEB_DIR=/home/vazmin/deb
REMOTE_REPO_BASEDIR=/usr/html/aptrepo/fastos
DISTRIBUTION=stable
passwd=/etc/mkrpm/passwd
EXP=/tmp/reprepro.exp

scp mkdeb/reprepro.exp ${REMOTE_HOST}:${EXP}

for debfile in ${DIST_MODULE_DIR}/*.deb; do 
    scp $debfile ${REMOTE_HOST}:${REMOTE_DEB_DIR}
    debf=$(basename "$debfile")
    ssh ${REMOTE_HOST} "SIGNING_PASSWORD=${passwd} ${EXP} -- -b $REMOTE_REPO_BASEDIR includedeb ${DISTRIBUTION} ${REMOTE_DEB_DIR}/${debf}"
done