Installation
============

openSUSE Tumbleweed
-------------------

The absolutely easiest way to try out Hawk is to run openSUSE
Tumbleweed or openSUSE Leap, since a recent version of Hawk is
available in the repositories::

  $ zypper install hawk2

Once installed, start Hawk by running::

  $ chkconfig hawk on
  $ service hawk start 

Vagrant
-------

Another way of trying out Hawk is to use Vagrant. In the Hawk source
code repository we have included a Vagrantfile which describes a
four-node cluster.

Make sure that you have a fairly recent version of Vagrant installed
together with either VirtualBox or libvirt as the VM host. To use
libvirt, you may need to install the bindfs plugin for vagrant.

Check out the Hawk source code from github::

  $ git clone git@github.com:ClusterLabs/hawk

Now let Vagrant configure a virtual machine running Hawk::

  $ cd hawk
  $ vagrant up webui

If everything goes as it should, a VM running Pacemaker and Hawk
should start up. Currently, the vagrant script installs Hawk 1, the
previous version of Hawk. To install Hawk 2, SSH to the cluster node
and install ``hawk2``::

  $ vagrant ssh webui
  (webui) $ sudo zypper in hawk2

Answer yes when prompted to remove the ``hawk`` package to install the
``hawk2`` package.

Make sure hawk is started by running::

  $ chkconfig hawk on
  $ service hawk start

Verifying the installation
--------------------------

To view the Hawk web interface, open this URL in your
web browser: https://localhost:7630/

Connecting to port ``7630`` on ``localhost`` works for both of the
above described installation methods. If you installed Hawk on a
different machine than the one you are currently using, you will need
to connect to port ``7630`` on that machine instead.

You may see a prompt warning you about an unverified SSL
certificate. By default, Hawk generates and presents a self-signed
certificate which browsers are understandably sceptical about.

Once you have accepted the certificate, you will be faced with a
username and password prompt. Enter ``hacluster`` as the username and
``linux`` as the password. This is the default identity as configured by
the HA bootstrap script. Naturally, you would want to change this
password before exposing this cluster to the wider world.

