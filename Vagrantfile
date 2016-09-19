Vagrant.configure("2") do |config|
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    config.ssh.forward_agent = true

    # Configure A Private Network IP
    config.vm.network :private_network, ip: "192.168.10.10"
    config.vm.provider :virtualbox do |vb|
      vb.name = "ubuntu-flexbox"
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    end

    # Configure The Box
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_version = ">= 0"
    config.vm.hostname = "flexbox"
    config.vm.synced_folder "./", "/vagrant", type: nil
    config.vm.provision "shell", path: "provision.sh"
end
