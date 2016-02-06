Creating a Resource
===================

To learn how to control resources in the cluster without having to
worry about an actual application, we can use the aptly named
``Dummy`` resource agent. In this section of the guide, we will create
a new dummy resource and look at the status and dashboard views of
Hawk, to see how we can start and stop the resource, reconfigure
parameters and monitor its location and status.


Add a resource
--------------

To add a resource, click ``Add a resource`` in the sidebar on the
left. This brings up a list of different types of resources we can
create. All basic resources that map to a resource agent or service
are called *Primitive resources*. Click the **Primitive** button on
this screen.

1. Name the resource ``test1``. No need to complicate things.

2. From the **Class** selection box, pick ``ocf``. The **Provider**
   selection box will default to ``heartbeat``. This is what we want
   in this case. Other resource agents may have different providers.

3. From the **Type** selection box, select ``Dummy``. To learn more
   about the Dummy resource agent and its parameters, you can click
   the blue *i* button below the selection boxes. This brings up a
   modal dialog describing the selected agent.

   .. image:: _static/resource-type.png

Parameters
^^^^^^^^^^

The Dummy agent does not require any parameters, but it does have two:
``fake`` and ``state``. In the selection box under *Parameters* it is
possible to select either one of these, and by clicking the plus next
to the selection box, the parameter can be configured with a value.

On the right-hand side of the screen, documentation for the parameter
is shown when highlighted.

For now, there is no need to set any value here. To remove a
parameter, click the minus button next to it.

Operations
^^^^^^^^^^

In order for Pacemaker to monitor the state of the resource, a
``monitor`` operation can be configured. Resources can have multiple
operations, and each operation can be configured with parameters such
as timeout and interval. Hawk has configured some reasonable default
operations, but in many cases you will need to modify the timeout or
interval of your resource.

If no ``monitor`` operation is configured, Pacemaker won't check to
see if the application it maps to is still running. Most resources
should have a ``monitor`` operation.

Meta Attributes
^^^^^^^^^^^^^^^

Meta attributes are parameters common to all resources. The most
commonly seen attribute is the ``target-role`` attribute, which
tells Pacemaker what state the resource ought to be in. To have
Pacemaker start the resource, the ``target-role`` attribute should be
set to ``Started``. By default, Hawk sets this attribute to
``Stopped``, so that any necessary constraints or other dependencies
can be applied before trying to start it.

In this case, there are no dependencies, so set the value of this
attribute to ``Started``.

Utilization
^^^^^^^^^^^

Utilization can be used to balance resources across different
nodes. Perhaps one of the nodes has more RAM or disk space than the
others, or perhaps there is a limit on how many resources can run on a
given node. The utilization values can be used to manage this. By
configuring utilization limits on the nodes themselves and configuring
utilization values on the resources, resources can be balanced across
the cluster according to the properties of nodes.

Finishing Up
^^^^^^^^^^^^

To complete the configuration of this dummy resource, click
Create. Hawk will post a notification showing if it completed the
operation successfully or not.

.. image:: _static/resource-post-create.png

Command Log
^^^^^^^^^^^

To see the command used to create the resource, go to the *Command
Log* in the sidebar to the left of the screen. Here you can see a list
of ``crm`` commands executed by Hawk, with the most recent command
listed first.

Status and Dashboard
--------------------

* Look at the resource in the status view.
* Look at the resource in the dashboard view.

Starting and Stopping
^^^^^^^^^^^^^^^^^^^^^

TODO

Migrating Resources
^^^^^^^^^^^^^^^^^^^

TODO

Managed and Unmanaged Resources
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TODO

Failcounts
^^^^^^^^^^

TODO

Recent Events
^^^^^^^^^^^^^

TODO

Editing resources
-----------------

TODO
