# FastOS.repo for yum

the rpm packages in FastOS.repo include: libfastcommon, libserverframe, FastCFS etc.

```
git clone https://github.com/happyfish100/FastOS.repo
cd FastOS.repo
sudo cp yumrepo/FastOS.repo /etc/yum.repos.d/
sudo cp yumrepo/RPM-GPG-KEY-FastOS /etc/pki/rpm-gpg/
```

list one package (eg. libfastcommon) in FastOS.repo:

```
yum list libfastcommon
```
