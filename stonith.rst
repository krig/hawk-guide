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
manually to make sure it works. We can reboot one of the Bobs from
Alice using the ``stonith`` command::

  $ stonith -t external/libvirt \
      hostlist="alice,bob1,bob2" \
      hypervisor_uri="qemu+ssh://10.13.38.1/system" \
      -T reset bob1

If this fails, the problem is most likely that the virtual machines
have different names than those specificed above. To check the actual
names of your virtual machines, use ``virsh list`` on the
hypervisor. If the names of the virtual machines don't match the
actual hostnames, you will need to use a slightly different syntax for
the ``hostlist`` parameter::

  hostlist="alice:<alice-vm-name>,bob1:<bob1-vm-name>,..."

Replace ``<alice-vm-name>`` with the actual name of the virtual
machine known as ``alice`` in the cluster.

The other likely source of problems is the name of the hypervisor
node. Make sure to use whatever hostname or IP address is correct for
your environment.

Now we can use Hawk to configure the fencing resource in the cluster.

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

A note of caution: When things go wrong while configuring fencing, it
can be a bit of a hassle. Since we're configuring a means of which
Pacemaker can reboot its own nodes, if we aren't careful it might
start doing just that. In a two-node cluster, a misconfigured fencing
resource can easily lead to a reboot loop where two cluster nodes
repeatedly fence each other. This is less likely with three nodes, but
be careful. Also, make sure to remove the ``stonith:null`` fencing
resource that was created by Vagrant once the new fencing resource has
been started.

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
