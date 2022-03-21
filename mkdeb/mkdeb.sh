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

  if [[ ${MODULE} == "libfdirstorage" ]] || [[ ${SOURCES_FORM} == "G" ]]; then
    if [[ ${MODULE} == "libfdirstorage" ]];then
      git clone git@gitee.com:fastdfs100/libfdirstorage.git
    else
      git clone git@github.com:happyfish100/${MODULE}.git
    fi
    mv ${MODULE} ${MODULE}-${VERSION}
    tar -czvf ${MODULE}.tar.gz --exclude-vcs ${MODULE}-${VERSION}
  else
    source_url=https://codeload.github.com/vazmin/${MODULE}/tar.gz/refs/tags/${TAGS}
    echo "get ${source_url}"
    curl -o ${DIST} -sSL ${source_url}
    tar -zxvf ${MODULE}.tar.gz
  fi
  
  # FastCFS-x.x.x to fastcfs-x.x.x
  for file in * ; do
    if [[ $file == *[[:upper:]]* ]]; then
      mv $file `echo $file | sed 's/\(.*\)/\L\1/'`
    fi
  done

  tar -czvf ${MODULE}_${VERSION}.orig.tar.gz --exclude-vcs ${MODULE}-${VERSION}
fi

cd ${MODULE}-${VERSION}

chmod +x debian/rules
${DPKG} -b --no-sign ${DP_OPTS}
