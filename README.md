# Customized LXC templates for Proxmox
A set of customized LXC templates using the Debian Appliance Builder (DAB) provided by Proxmox. Currently this repo provides templates of Debian 10 (Buster) and Ubuntu 20.04 (Focal).

### Motivation

Proxmox already comes with a minimal Debian & Ubuntu template so why should one bother to create a customized Debian/Ubuntu template? Following are the reasons why I did it.

- Security (I don't have to rely on a template provided by a 3rd party)
- I have control over what packages get installed on top of a minimal installation.
- I can make changes to the configuration right from the beginning (e.g. ssh).
- Unattended upgrades (security) active by default.

### Install DAB
In order to start creating custom templates one has to install DAB first. Please note that this package is not available on regular Debian installations by default. For more information please refer to [https://pve.proxmox.com/wiki/Debian_Appliance_Builder](https://pve.proxmox.com/wiki/Debian_Appliance_Builder).

    apt update && apt install dab

### Clone repository

Once DAB is installed just clone the GIT repository to get the required files.

    git https://github.com/frieder/dab-templates.git
    cd dab-templates/...

### Make changes to the config files

Next customize the Makefile and dab.conf files in the template folders according to your needs. While most of the stuff should be fine for most people you may want to take a closer look at the following configurations:

* SSH root login is forbidden except with private key from a defined subnet. Check `files/ssh/sshd_config` if you want to have this changed.
* `files/id_rsa` & `files/id_rsa.pub` must be created (see the next section) or root login must be allowed or a local user must be created (either SSH config or Makefile). If absent it will be skipped.
* localtime is set to Europe/Berlin (Makefile)
* locale is set to en_GB.UTF-8 (Makefile)
* Python3 & vim (Makefile)
* Fixed IPs for several hosts (files/hosts).

If you require more information about the DAB makefile please visit the Proxmox [DAB wiki](https://pve.proxmox.com/wiki/Debian_Appliance_Builder), ask on the Proxmox [forum](https://forum.proxmox.com/) and check the DAB man pages.

### Create SSH public & private key

Before we can actually build the template we must create a private/public keyset. Just execute the following command (assuming /opt/dab-templates is the folder you cloned the GIT repository to).

    ssh-keygen -t rsa -b 4096 -C "user@workstation"
    Generating public/private rsa key pair.
    Enter file in which to save the key (/root/.ssh/id_rsa): /opt/dab-templates/files/id_rsa

When skipping the creation of the ssh keys the makefile will skip copying the pub file into the container.

### Create template

Creating a new LXC template is quite easy. Just execute the following command (inside the folder in which the Makefile and dab.conf file exists) and it will build everything that is required for the LXC template.

    make

To clean up the directory execute the following command. Please note that this will also remove the LXC template file so you may want to move the template to another location first (see the next section).

    make clean

### Post-processing

Usually the template will have a quite long file name. Since I always use minimal and 64bit templates I usually remove those parts from the file name. You however can choose any name you like. Once you are done with renaming the template move it to the Proxmox LXC template location so it can be used via the web console and CLI.

    mv debian-10.0-minimal_10.0_amd64.tar.gz /var/lib/vz/template/cache/debian-10.tar.gz

Enjoy.

