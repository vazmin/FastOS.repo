#!/bin/bash
set -e

MODULE_BASE_DIR=$1
REVISION=$2

[ -z "${MODULE_BASE_DIR}" ] && {
    echo 'Missing input "MODULE_BASE_DIR".';
    exit 1;
};

[ -z "${REVISION}" ] && {
    echo 'Missing input "REVISION".';
    exit 1;
};

MODULE_TMP_SUBSTVARS=substvars-$(echo $RANDOM | md5sum | head -c 12)

ORIGIN_SUBSTVARS=$MODULE_BASE_DIR/debian/substvars
if [ -f ${ORIGIN_SUBSTVARS} ]; then
    awk -F'=' 'FNR==NR {a[$1] = $2; next} $1 in a {print $1"="$2}'  substvars > /tmp/$MODULE_TMP_SUBSTVARS
    cp /tmp/$MODULE_TMP_SUBSTVARS $ORIGIN_SUBSTVARS
fi
cd $MODULE_BASE_DIR
dch --distribution unstable -v $REVISION -M "upgrade to $REVISION"
git add debian
git commit -m "gh actions: upgrade to $REVISION"
