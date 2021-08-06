
BUILD_DIR ?= build


export KEY_ID=$(if $(DEB_KEY_ID),$(DEB_KEY_ID),chwingwong@outlook.com)
# DPKG=debuild
export DPKG=dpkg-buildpackage

export libfastcommon_version = 1.0.53
export libserverframe_version = 1.1.10
export fastdir_version = 2.3.0
export faststore_version = 2.3.0
export fastcfs_version = 2.3.0

.PHONY: all
all: libfastcommon libserverframe fastcfs-auth-client fastdir faststore fastcfs

.PHONY: libfastcommon
libfastcommon: build-libfastcommon install-libfastcommon deploy-libfastcommon


.PHONY: libserverframe
libserverframe: build-libserverframe install-libserverframe deploy-libserverframe

# build-libserverframe:
# 	./mkdeb/mkdeb.sh $(BUILD_DIR) libserverframe $(libserverframe_version)

.PHONY: fastcfs-auth-client
fastcfs-auth-client: build-fastcfs-auth-client install-fastcfs-auth-client deploy-fastcfs-auth-client

build-fastcfs-auth-client:
	DPKG_OPTIONS=-Ppkg.auth.client \
	BUILD_DIR=${BUILD_DIR} \
	MODULE=fastcfs \
	SUB_MODULE=fastcfs-auth-client \
	./mkdeb/mkdeb.sh

.PHONY: fastdir
fastdir: build-fastdir install-fastdir deploy-fastdir

# build-fastdir:
# 	./mkdeb/mkdeb.sh $(BUILD_DIR) fastDIR $(fastcfs_version)

.PHONY: faststore
faststore: build-faststore install-faststore deploy-faststore

# build-faststore:
# 	./mkdeb/mkdeb.sh $(BUILD_DIR) faststore $(fastcfs_version)


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

