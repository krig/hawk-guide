Configuring fencing
===================

STONITH, or fencing [#fencing]_, is the mechanism by which Pacemaker makes sure
that nodes that misbehave don't cause any additional problems. If a
node that was running a given resource stops communicating with the
other nodes in the cluster, there is no way to know if that node is
still running the resource and for whatever reason is just unable to
communicate, or if it has crashed completely and the resource needs to
be restarted elsewhere.

In order to make certain what is uncertain, the other nodes can use an
external fencing mechanism to cut power to the misbehaving node, or in
some other way ensure that it is no longer running anything.

There are many different fencing mechanisms, and which agent to use
depends strongly on the type of nodes that are part of the cluster.

For most virtual machine hosts there is a fencing agent which
communicates with the hypervisor, for example the ``fence_vbox`` or
``external/libvirt`` agents. See below for examples on how to
configure fencing using the ``external/libvirt`` agent.

external/libvirt
----------------

There are several different fencing agents available that can
communicate with a libvirt-based hypervisor through the ``virsh``
command line tool. In this example, fencing device of choice is the
``stonith:external/libvirt`` agent. This ships as part of the
``cluster-glue`` package on openSUSE, and is already installed on the
cluster nodes.

To ensure that communication between the cluster nodes and the
hypervisor is authenticated, we need an SSH key. In the example
cluster, Vagrant has already created a key but for completeness the
steps below can be used. To see if a key has already been created for
your nodes, check if ``/root/.ssh/id_rsa`` exists (as ``root``). If
you already have this file, skip step 1 below.

1. Execute ``ssh-keygen -t rsa`` as ``root`` on one of the cluster
   nodes. Accept the default answers for all questions.

2. Execute ``ssh-copy-id ~/.ssh/id_rsa.pub 10.13.38.1`` to copy the
   SSH public key to the hypervisor. The IP address used is the one
   configured in the example Vagrant setup. If your hypervisor is
   available under a different IP address, make sure to use that
   instead.

3. Repeat step 1 (if necessary) and step 2 on the other nodes in the
   cluster.

Before configuring the cluster resource, lets test the fencing device
manually to make sure it works. To do this, we need values for two
parameters: ``hypervisor_uri`` and ``hostlist``.

For ``hypervisor_uri``, the value should look like the following::

  qemu+ssh://<hypervisor>/system

Replace ``<hypervisor>`` with the hostname or IP address of the
hypervisor. Make sure that the hostname resolves correctly from each
cluster node.

Configuring the ``hostlist`` is slightly more complicated. Most
likely, the virtual machines have different names than their
hostnames. In my case, the virtual machine names are of the form
``hawk_guide-alice``, ``hawk_guide-bob1``...

To check the actual names of your virtual machines, use ``virsh list``
as a privileged user on the hypervisor. If the names of the virtual
machines don't match the actual hostnames, you will need to use the
longer syntax for the ``hostlist`` parameter::

  hostlist="alice[:<alice-vm-name>],bob1[:<bob1-vm-name>],..."

Replace ``<alice-vm-name>`` with the actual name of the virtual
machine known as ``alice`` in the cluster. If the virtual machines
happen to have the same name as the hostname of each machine, the
``:<vm-name>`` part is not necessary.

With this information, we can reboot one of the Bobs from
Alice using the ``stonith`` command::

  $ stonith -t external/libvirt \
      hostlist="alice:hawk_guide-alice,bob1:hawk_guide-bob1,bob2:hawk_guide-bob2" \
      hypervisor_uri="qemu+ssh://10.13.38.1/system" \
      -T reset bob1

Once the fencing configuration is confirmed to be working, we can use
Hawk to configure the actual fencing resource in the cluster.

1. Open Hawk, and select "Add a resource" from the sidebar on the left.

2. Click "Primitive" to create a new primitive resource.

3. Name the resource ``libvirt-fence`` and in the selection box for
   Class, choose ``stonith``. The Provider selection box will become
   disabled. Now choose ``external/libvirt`` in the Type selection
   box.

   .. image:: _static/stonith-type.png

4. For the ``hostlist`` and ``hypervisor_url`` parameters, enter the
   same values as were used when testing the agent manually above.

5. Change the ``target-role`` meta attribute to ``Started``.

   .. image:: _static/stonith-params.png

6. Click the Create button to create the fencing agent.

7. Go to the *Cluster Configuration* screen in Hawk, by selecting it
   from the sidebar. Enable fencing by setting ``stonith-enabled`` to
   ``true``.

A note of caution: When things go wrong while configuring fencing, it
can be a bit of a hassle. Since we're configuring a means of which
Pacemaker can reboot its own nodes, if we aren't careful it might
start doing just that. In a two-node cluster, a misconfigured fencing
resource can easily lead to a reboot loop where two cluster nodes
repeatedly fence each other. This is less likely with three nodes, but
be careful.

fence_vbox (VirtualBox) [TODO]
------------------------------

The fence agent for clusters using VirtualBox to host the virtual
machines is called ``fence_vbox``, and ships in the ``fence-agents``
package.

TODO


external/ec2 (Amazon EC2) [TODO]
--------------------------------

The ``external/ec2`` fence agent provides fencing that works for
cluster nodes running in the Amazon EC2 public cloud.

TODO

SBD [TODO]
----------

SBD [#sbd]_ can be used in any situation where a shared storage device
such as a SAN or iSCSI is available. It has proven to be more reliable
than many firmware fencing devices, and is the recommended method for
fencing physical hardware nodes.

TODO


.. rubric:: Footnotes
.. [#fencing] The two terms come from the merging of two different
              cluster projects: The Linux HA project traditionally
              uses the term STONITH, while the Red Hat cluster suite
              uses fencing to denote the same concept. 
.. [#sbd] Shared-storage Based Death. https://github.com/l-mb/sbd
