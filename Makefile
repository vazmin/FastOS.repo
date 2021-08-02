
BUILD_DIR ?= build


export KEY_ID=$(if $(DEB_KEY_ID),$(DEB_KEY_ID),chwingwong@outlook.com)
# DPKG=debuild
export DPKG=dpkg-buildpackage

libfastcommon_version = 1.0.53
libfastcommon_tags = V${libfastcommon_version}

libserverframe_version = 1.1.10
libserverframe_tags = V$(libserverframe_version)

fastcfs_version = 2.3.0
fastcfs_tags = V$(fastcfs_version)

.PHONY: all
all: libfastcommon libserverframe fastcfs-auth-client fastdir faststore fastcfs

.PHONY: libfastcommon
libfastcommon: build-libfastcommon deploy-libfastcommon

build-libfastcommon:
	./mkdeb/mkdeb.sh $(BUILD_DIR) libfastcommon ${libfastcommon_tags} $(libfastcommon_version)

.PHONY: libserverframe
libserverframe: build-libserverframe deploy-libserverframe

build-libserverframe:
	./mkdeb/mkdeb.sh $(BUILD_DIR) libserverframe ${libserverframe_tags} $(libserverframe_version)

.PHONY: fastcfs-auth-client
fastcfs-auth-client: build-fastcfs-auth-client

build-fastcfs-auth-client:
	DPKG_OPTIONS=-Ppkg.auth.client \
	./mkdeb/mkdeb.sh $(BUILD_DIR) FastCFS ${fastcfs_tags} $(fastcfs_version)

.PHONY: fastdir
fastdir: build-fastdir deploy-fastDIR

build-fastdir:
	./mkdeb/mkdeb.sh $(BUILD_DIR) fastDIR ${fastcfs_tags} $(fastcfs_version)

.PHONY: faststore
faststore: build-faststore deploy-faststore

build-faststore:
	./mkdeb/mkdeb.sh $(BUILD_DIR) faststore ${fastcfs_tags} $(fastcfs_version)


.PHONY: fastcfs
fastcfs: build-fastcfs deploy-FastCFS

build-fastcfs:
	DPKG_OPTIONS=-Ppkg.fastcfs.core \
	./mkdeb/mkdeb.sh $(BUILD_DIR) FastCFS ${fastcfs_tags} $(fastcfs_version)

deploy-%:
	./mkdeb/deploy.sh $(BUILD_DIR)/$*

clean-%:
	$(BUILD_DIR)/$*

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

