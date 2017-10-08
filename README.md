# Customized LXC templates for Proxmox
A set of customized LXC templates using the Debian Appliance Builder (DAB) provided by Proxmox. Currently this repo provides templates of Debian 8.x (Jessie), Debian 9.x (Stretch) and Ubuntu 16.04 (Xenial).

### Motivation

Proxmox already comes with a minimal Debian 8 & Ubuntu 16.04 template so why should one bother to create a customized Debian/Ubuntu template? Following are the reasons why I did it.

- Security (I don't have to rely on a template provided by a 3rd party)
- I use [Ansible](https://www.ansible.com/) as my CM tool of choice so I require a few things (e.g. Python2, SSH keys) to be set up front to get me started real quick.
- A secure and custom SSH config right from the beginning (customized to my network settings, basically a 10.0.0.0/16 subnet).
- A few packages and aliases on top of a minimal installation.
- The default Proxmox Debian LXC template uses sysvinit while I prefer to stick to the default (systemd).
- A modified VIM configuration.
- Unattended upgrades (security) active by default.
- Predefined IPs for the Ansible control machine, the DNS and the LDAP server.

Since the above mentioned requirements apply to all of my containers I decided to create a template that takes care of those things. The actual container configuration (users, apps, configuration etc.) will be done at a later point via the CM tool. If you don't use a CM tool you can of course customize the template according to your needs or even create multiple templates that cover specifics (e.g. preinstalled Java).

### systemd and Debian

Unfortunately DAB uses sysvinit instead of systemd and (at least for the moment) this is hardcoded (see [link1](https://github.com/proxmox/dab/blob/master/DAB.pm#L461) and [link2](https://github.com/proxmox/dab/blob/master/DAB.pm#L463)) in DAB. If you are looking for a Debian LXC teamplate with systemd you still have a few options to make it happen though.
- Use lxc-create to create a LXC template that uses systemd. All customizations will be lost so this is no real option (at least for me).
- Use debootstrap to create a LXC template. I've put the required steps in a [snippet](https://bitbucket.org/snippets/flybyte/GEpo8) for your convenience. However it is more work than using DAB (at least in this context when no script is created for the debootstrap steps) so again not my preferred approach.
- Use Ubuntu which comes with systemd out of the box. Nice try but we are looking for a Debian template, aren't we ;)
- Remove the exclusion in DAB temporarily, create a systemd enabled template and then revert the changes in DAB.

Since I don't create new templates all the time the last option is my preferred approach. It requires the least work of all approaches. I've put the required steps in another [snippet](https://bitbucket.org/snippets/flybyte/yjoMo) for your convenience if you want to try this approach. Please note that all Debian-based DAB templates in this repository require this  workaround since all include systemd as the preferred init script.

> Please note that when using Debian 8/9 with systemd the Spice web console might not work properly anymore. If you rely on this feature you better stick to syvinit or switch to Ubuntu.

### Install DAB
In order to start creating custom templates one has to install DAB first. Please note that this package is not available on regular Debian installations by default. For more information please refer to [https://pve.proxmox.com/wiki/Debian_Appliance_Builder](https://pve.proxmox.com/wiki/Debian_Appliance_Builder).

    apt update && apt install dab

### Clone repository

Once DAB is installed just clone the GIT repository to get the required files.

    git clone https://bitbucket.org/flybyte/dab-templates.git
    cd dab-templates/...

### Make changes to the config files

Next customize the Makefile and dab.conf files in the template folders according to your needs. While most of the stuff should be fine for most people you may want to take a closer look at the following configurations:

* SSH root login is forbidden except with private key from a 10.0.0.0/16 subset and 127.0.0.1. Check files/ssh/sshd_config if you want to have this changed.
* files/id_rsa & files/id_rsa.pub must be created (see the next section) or root login must be allowed or a local user must be created (either SSH config or Makefile).
* localtime is set to Europe/Berlin (Makefile)
* locale is set to en_GB.UTF-8 (Makefile)
* Python 2.7 & VIM (Makefile)
* Fixed IPs for several hosts (files/hosts).

If you require more information about the DAB makefile please visit the Proxmox [DAB wiki](https://pve.proxmox.com/wiki/Debian_Appliance_Builder), ask on the Proxmox [forum](https://forum.proxmox.com/) and check the DAB man pages.

### Create SSH public & private key

Before we can actually build the template we must create a private/public keyset. Just execute the following command (assuming /opt/dab-templates is the folder you cloned the GIT repository to).

    ssh-keygen -t rsa -b 2048 -C "ansible"
    Generating public/private rsa key pair.
    Enter file in which to save the key (/root/.ssh/id_rsa): /opt/dab-templates/files/id_rsa

### Create template

Creating a new LXC template is quite easy. Just execute the following command (inside the folder in which the Makefile and dab.conf file exists) and it will build everything that is required for the LXC template.

    make

To clean up the directory execute the following command. Please note that this will also remove the LXC template file so you may want to move the template to another location first (see the next section).

    make clean

### Post-processing

Usually the template will have a quite long file name. Since I always use minimal and 64bit templates I usually remove those parts from the file name. You however can choose any name you like. Once you are done with renaming the template move it to the Proxmox LXC template location so it can be used via the web console and CLI.

    mv debian-8.0-minimal_8.5_amd64.tar.gz /var/lib/vz/template/cache/debian-8.5.tar.gz

Enjoy.

