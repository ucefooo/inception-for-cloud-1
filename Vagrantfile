# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# Check for required plugins
required_plugins = %w(vagrant-hostmanager)
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Use Ubuntu 20.04 LTS
  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = "ubuntu-s-2vcpu-4gb-amd-fra1-01"

  # VM Configuration
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"  # 4GB RAM
    vb.cpus = 2         # 2 CPUs
    vb.name = "wordpress-ansible-docker"
  end

  # Network Configuration
  config.vm.network "private_network", ip: "192.168.56.10"
  config.vm.network "forwarded_port", guest: 80, host: 8080    # WordPress
  config.vm.network "forwarded_port", guest: 8080, host: 8081  # PHPMyAdmin

  # Sync the project directory
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  # Install Ansible and requirements
  config.vm.provision "shell", inline: <<-SHELL
    # Update system
    apt-get update
    apt-get upgrade -y

    # Install Ansible and requirements
    apt-get install -y software-properties-common
    apt-add-repository --yes --update ppa:ansible/ansible
    apt-get install -y ansible python3-pip
    
    # Install DigitalOcean Ansible collection
    ansible-galaxy collection install community.digitalocean

    # Create directory for Ansible files
    mkdir -p /etc/ansible
    
    # Copy Ansible files to appropriate locations
    cp /vagrant/ansible.cfg /etc/ansible/
    cp /vagrant/inventory /etc/ansible/hosts
    
    echo "Running Ansible playbook..."
    cd /vagrant && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yml
  SHELL

  # Show post-setup message
  config.vm.post_up_message = <<-MESSAGE
    Your environment is ready!
    
    Access the services at:
    WordPress: http://192.168.56.10 or http://localhost:8080
    PHPMyAdmin: http://192.168.56.10:8080 or http://localhost:8081
    
    To SSH into the VM:
    $ vagrant ssh
    
    To run Ansible playbook manually:
    $ vagrant ssh
    $ cd /vagrant
    $ ansible-playbook playbook.yml
    
    To stop the VM:
    $ vagrant halt
    
    To destroy the VM:
    $ vagrant destroy
  MESSAGE
end 