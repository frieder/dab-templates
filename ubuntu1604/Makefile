BASEDIR:=$(shell dab basedir)

all: info/init_ok
	dab bootstrap
	
	cp ../files/ssh/sshd_config ${BASEDIR}/etc/ssh/sshd_config
	mkdir -p ${BASEDIR}/root/.ssh
	cp ../files/ssh/id_rsa.pub ${BASEDIR}/root/.ssh/authorized_keys

	echo "en_GB.UTF-8" > ${BASEDIR}/etc/locale
	echo "en_GB.UTF-8 UTF-8" > ${BASEDIR}/etc/locale.gen
	dab exec dpkg-reconfigure -f noninteractive locales

	dab exec echo "Europe/Berlin" > /etc/timezone
	dab exec cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
	dab exec dpkg-reconfigure -f noninteractive tzdata

	dab install ntpdate
	dab install python
	dab install software-properties-common

	dab install vim
	cp ../files/vim/.vimrc ${BASEDIR}/root/.vimrc
	mkdir -p ${BASEDIR}/root/.vim/ftplugin
	cp -R ../files/vim/ftplugin/* ${BASEDIR}/root/.vim/ftplugin/

	cat ../files/bashrc_appendix >> ${BASEDIR}/root/.bashrc
	cat ../files/hosts >> ${BASEDIR}/etc/hosts

	dab install unattended-upgrades

	dab finalize

info/init_ok: dab.conf
	dab init
	touch $@

.PHONY: clean
clean:
	dab clean
	rm -f *~

.PHONY: dist-clean
dist-clean:
	dab dist-clean
	rm -f *~
