# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "opensuse/openSUSE-42.1-x86_64"
  config.vm.box_check_update = true
  config.ssh.insert_key = false

  config.vm.define "alice", primary: true do |machine|
    machine.vm.hostname = "alice"

    machine.vm.network :forwarded_port,
      host_ip: ENV['VAGRANT_INSECURE_FORWARDS'] =~ /^(y(es)?|true|on)$/i ?
        '*' : '127.0.0.1',
      guest: 7630,
      host: 7630

    machine.vm.network :private_network,
      ip: "10.13.38.10"

    machine.vm.provision "shell", path: "chef/suse-prepare.sh"

    machine.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ["chef/cookbooks"]
      chef.roles_path = ["chef/roles"]
      chef.custom_config_path = "chef/solo.rb"
      chef.synced_folder_type = "rsync"

      chef.add_role "base"
      chef.add_role "alice"
    end

    machine.vm.provider :virtualbox do |provider, override|
      provider.memory = 1024
      provider.cpus = 1
      provider.name = "alice"
    end

    machine.vm.provider :libvirt do |provider, override|
      provider.memory = 1024
      provider.cpus = 1
      provider.graphics_port = 9200
    end
  end

  1.upto(2).each do |i|
    config.vm.define "bob#{i}", autostart: false do |machine|
      machine.vm.hostname = "node#{i}"

      machine.vm.network :forwarded_port,
        host_ip: ENV['VAGRANT_INSECURE_FORWARDS'] =~ /^(y(es)?|true|on)$/i ?
          '*' : '127.0.0.1',
        guest: 7630,
        host: 7630 + i

      machine.vm.network :private_network,
                         ip: "10.13.38.#{10 + i}"

      machine.vm.provision "shell", path: "chef/suse-prepare.sh"

      machine.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = ["chef/cookbooks"]
        chef.roles_path = ["chef/roles"]
        chef.custom_config_path = "chef/solo.rb"
        chef.synced_folder_type = "rsync"

        chef.add_role "base"
        chef.add_role "bob"
      end

      machine.vm.provider :virtualbox do |provider, override|
        provider.memory = 512
        provider.cpus = 1
        provider.name = "bob#{i}"
      end

      machine.vm.provider :libvirt do |provider, override|
        provider.memory = 512
        provider.cpus = 1
        provider.graphics_port = 9200 + i
      end
    end
  end

  config.vm.provider :libvirt do |provider, override|
    provider.storage_pool_name = "default"
    provider.management_network_name = "vagrant"
  end
end
