Basic Concepts
==============

Before we get started, we need to establish some basic concepts and
terminology used in High Availability.

Cluster
  A cluster in the sense used in High Availability consists of one or
  more communicating computers, either virtual machines or physical
  hardware. It's possible to mix and match virtual and physical
  machines.

Node
  A node is a single machine participating in a cluster. Nodes
  invariably fail or experience malfunction. The HA software provides
  reliable operations by connecting multiple nodes together, each
  monitoring the state of the others, coordinating the allocation of
  resources across all healthy nodes.

Resource
  Anything that can be managed by the cluster is a resource. Pacemaker
  knows how to manage software using LSB init scripts, systemd service
  units or OCF resource agents. OCF is a common standard for HA
  clusters providing a configurable interface to many common
  applications. The OCF agents are adapted for running in a clustered
  environment, and provide configurable parameters and monitoring
  functionality.

Constraint
  Constraints are rules that Pacemaker uses to determine where and how
  to start and stop resources. Using constraints, you can limit a
  resource to run only on a certain subset of nodes or set a
  preference for where a resource should normally be running. You can
  also use more complex rule expressions to move resources between
  nodes according to the time of day or date, for example. This guide
  won't go into all the details of what can be done with constraints,
  but later on we will create and test constraints using Hawk.

CIB
  Cluster Information Base. This is the configuration of the cluster,
  which is configured in a single location and automatically
  synchronised across the cluster. The format of the configuration is
  XML, but usually there is no need to look at the XML directly. The
  CRM Shell provides a line-based syntax which is easier to work with
  from the command line, and Hawk provides a graphical interface with
  which to work with the configuration.

CRM Shell
  Behind the scenes, Hawk uses the CRM command shell to interact with
  the cluster. The CRM shell can be used directly from the command
  line via the command ``crm``. The command shell is very powerful and
  can for example be used as a tool in configuration management
  recipes.

