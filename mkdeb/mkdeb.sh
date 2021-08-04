#!/bin/bash

set -euo pipefail


BUILD_DIR=$1
MODULE=$2
TAGS=$3
VERSION=$4

DP_OPTS=${DPKG_OPTIONS:-}
MUDULE_DIR=${BUILD_DIR}/${MODULE}
mkdir -p ${MUDULE_DIR}


DIST=${MUDULE_DIR}/${MODULE}.tar.gz

if [ ! -f ${DIST} ]; then
  source_url=https://codeload.github.com/happyfish100/${MODULE}/tar.gz/refs/tags/${TAGS}
  echo "get ${source_url}"
  curl -o ${DIST} -sSL ${source_url}
fi

cd ${MUDULE_DIR}
tar -zxvf ${MODULE}.tar.gz
tar -czvf ${MODULE}_${VERSION}.orig.tar.gz ${MODULE}-${VERSION}
cd ${MODULE}-${VERSION}

if ls debian/*.ex >/dev/null 2>&1 ; then
  rm -rf debian
fi

if [ ! -d debian ]; then
  echo 'warning: get debian in pkg branch.'
  mkdir -p /tmp/${MODULE}
  curl -o /tmp/${MODULE}/pkg-debian.zip -sSL https://codeload.github.com/vazmin/${MODULE}/zip/refs/heads/pkg-debian
  unzip /tmp/${MODULE}/pkg-debian.zip -d /tmp/${MODULE}
  cp -r /tmp/${MODULE}/*/debian .
  rm -rf /tmp/${MODULE}
fi

chmod +x debian/rules
${DPKG} -b --no-sign ${DP_OPTS}