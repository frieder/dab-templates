BASEDIR:=$(shell dab basedir)

all: info/init_ok
	dab bootstrap

	if [ -f "../files/sshd_config" ]; then cp ../files/sshd_config ${BASEDIR}/etc/ssh/sshd_config;  fi
	if [ -f "../files/id_rsa.pub" ]; then mkdir -p ${BASEDIR}/root/.ssh; cp ../files/id_rsa.pub ${BASEDIR}/root/.ssh/authorized_keys; fi

	echo "en_GB.UTF-8" > ${BASEDIR}/etc/locale
	echo "en_GB.UTF-8 UTF-8" > ${BASEDIR}/etc/locale.gen
	dab exec dpkg-reconfigure -f noninteractive locales

	dab exec echo "Europe/Berlin" > /etc/timezone
	dab exec cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
	dab exec dpkg-reconfigure -f noninteractive tzdata

	dab install ntpdate
	dab install python3
#	dab install software-properties-common

	dab install vim
	if [ -f "../files/.vimrc" ]; then cp ../files/.vimrc ${BASEDIR}/root/.vimrc; fi

	if [ -f "../files/bashrc_appendix" ]; then cat ../files/bashrc_appendix >> ${BASEDIR}/root/.bashrc; fi
	if [ -f "../files/hosts" ]; then cat ../files/hosts >> ${BASEDIR}/etc/hosts; fi

	dab install unattended-upgrades
	if [ -f "../files/20auto-upgrades" ]; then cp ../files/20auto-upgrades ${BASEDIR}/etc/apt/apt.conf.d/20auto-upgrades; fi
	if [ -f "../files/50unattended-upgrades" ]; then cp ../files/50unattended-upgrades ${BASEDIR}/etc/apt/apt.conf.d/50unattended-upgrades; fi
	dab exec unattended-upgrades --dry-run

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

