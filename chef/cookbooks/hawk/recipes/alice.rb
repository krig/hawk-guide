#
# Cookbook Name:: hawk
# Recipe:: alice
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

case node["platform_family"]
when "suse"
  include_recipe "zypper"

  zypper_repository node["hawk"]["zypper"]["alias"] do
    uri node["hawk"]["zypper"]["repo"]
    key node["hawk"]["zypper"]["key"]
    title node["hawk"]["zypper"]["title"]

    action [:add, :refresh]

    only_if do
      node["hawk"]["zypper"]["enabled"]
    end
  end
end

node["hawk"]["alice"]["packages"].each do |name|
  package name do
    action :install
  end
end

bash "hawk_init" do
  user "root"
  cwd "/vagrant"

  code node["hawk"]["alice"]["init_command"]

  only_if do
    Mixlib::ShellOut.new(
      node["hawk"]["alice"]["init_check"]
    ).run_command.error?
  end
end

group "haclient" do
  members %w(vagrant)
  append true

  action :manage
end

template node["hawk"]["alice"]["initial_cib"] do
  source "crm-initial.conf.erb"
  owner "root"
  group "root"
  mode 0600
end

execute "crm initial configuration" do
  user "root"
  command "crm configure load update #{node["hawk"]["alice"]["initial_cib"]}"
end

service "hawk" do
  action [:enable, :start]
end
