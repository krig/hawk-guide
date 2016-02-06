#
# Cookbook Name:: hawk
# Attributes:: alice
#
# Copyright 2014, SUSE LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default["hawk"]["alice"]["packages"] = [
  "hawk2",
  "fence-agents",
  "ha-cluster-bootstrap",
  "w3m",
  "apache2",
]

default["hawk"]["alice"]["apache_port"] = "sed -i 's/^Listen 80$/Listen 8000/g' /etc/apache2/listen.conf"
default["hawk"]["alice"]["init_command"] = "ha-cluster-init -i eth1 -y"
default["hawk"]["alice"]["init_check"] = "systemctl -q is-active corosync.service"
default["hawk"]["alice"]["initial_cib"] = "/root/crm-initial.conf"
default["hawk"]["alice"]["apache_index"] = "/srv/www/htdocs/index.html"
