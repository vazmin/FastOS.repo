
BUILD_DIR ?= build


export KEY_ID=$(if $(DEB_KEY_ID),$(DEB_KEY_ID),chwingwong@outlook.com)
# DPKG=debuild
export DPKG=dpkg-buildpackage
# G: git clone; T: download by TAG 
export SOURCES_FORM=G

export libfastcommon_version = 1.0.55
export libserverframe_version = 1.1.12
export libdiskallocator_version = 1.0.1
export libfdirstorage_version = 1.0.1
export fastdir_version = 3.1.0
export faststore_version = 3.1.0
export fastcfs_version = 3.1.0

.PHONY: all
all: libfastcommon libserverframe libdiskallocator fastcfs-auth-client fastdir-client libfdirstorage fastdir faststore fastcfs

.PHONY: libfastcommon
libfastcommon: build-libfastcommon install-libfastcommon deploy-libfastcommon

.PHONY: libserverframe
libserverframe: build-libserverframe install-libserverframe deploy-libserverframe

.PHONY: libdiskallocator
libserverframe: build-libdiskallocator install-libdiskallocator deploy-libdiskallocator

.PHONY: fastcfs-auth-client
fastcfs-auth-client: build-fastcfs-auth-client install-fastcfs-auth-client deploy-fastcfs-auth-client

build-fastcfs-auth-client:
	DPKG_OPTIONS=-Ppkg.auth.client \
	BUILD_DIR=${BUILD_DIR} \
	MODULE=fastcfs \
	SUB_MODULE=fastcfs-auth-client \
	./mkdeb/mkdeb.sh

.PHONY: fastdir-client
fastdir-client: build-fastdir-client install-fastdir-client deploy-fastdir-client

build-fastdir-client:
	DPKG_OPTIONS=-Ppkg.client \
	BUILD_DIR=${BUILD_DIR} \
	MODULE=fastdir \
	SUB_MODULE=fastdir-client \
	./mkdeb/mkdeb.sh

.PHONY: libfdirstorage
libserverframe: build-libfdirstorage install-libfdirstorage deploy-libfdirstorage

.PHONY: fastdir
fastdir: build-fastdir install-fastdir deploy-fastdir

build-fastdir:
	DPKG_OPTIONS=-Ppkg.server \
	BUILD_DIR=${BUILD_DIR} \
	MODULE=fastdir \
	./mkdeb/mkdeb.sh

.PHONY: faststore
faststore: build-faststore install-faststore deploy-faststore

.PHONY: fastcfs
fastcfs: build-fastcfs install-fastcfs deploy-fastcfs

build-fastcfs:
	DPKG_OPTIONS=-Ppkg.fastcfs.core \
	BUILD_DIR=${BUILD_DIR} \
	MODULE=fastcfs \
	./mkdeb/mkdeb.sh

build-%:
	BUILD_DIR=${BUILD_DIR} \
	MODULE=$* \
	./mkdeb/mkdeb.sh

deploy-%:
	./mkdeb/deploy.sh $(BUILD_DIR)/$*

install-%:
	for f in $(BUILD_DIR)/$*/*.deb; do sudo dpkg --force-all -i $$f; done;

remove-%:
	sudo apt remove $*

clean-%:
	$(BUILD_DIR)/$*

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

