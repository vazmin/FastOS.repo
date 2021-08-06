#!/bin/bash

set -eo pipefail


VERSION=$(printenv "${MODULE}_version")
TAGS="V${VERSION}"
echo "build module ${MODULE} $TAGS"
DP_OPTS=${DPKG_OPTIONS:-}


DIR=${SUB_MODULE:-${MODULE}}
MODULE_DIR=${BUILD_DIR}/${DIR}
mkdir -p ${MODULE_DIR}


echo "module dir: ${MODULE_DIR}"

cd ${MODULE_DIR}

DIST=${MODULE}.tar.gz

if [ ! -f ${DIST} ]; then
  source_url=https://codeload.github.com/happyfish100/${MODULE}/tar.gz/refs/tags/${TAGS}
  echo "get ${source_url}"
  curl -o ${DIST} -sSL ${source_url}

  tar -zxvf ${MODULE}.tar.gz
  # FastCFS-x.x.x to fastcfs-x.x.x
  for file in * ; do
    if [[ $file == *[[:upper:]]* ]]; then
      mv $file `echo $file | sed 's/\(.*\)/\L\1/'`
    fi
  done

  tar -czvf ${MODULE}_${VERSION}.orig.tar.gz ${MODULE}-${VERSION}
fi

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
