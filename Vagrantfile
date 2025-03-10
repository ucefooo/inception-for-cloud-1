VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_HOME'] = '/goinfre/' + ENV['USER'] + '/.vagrant.d'
ENV['VAGRANT_VMWARE_CLONE_DIRECTORY'] = '/goinfre/' + ENV['USER'] + '/VirtualBox VMs'

required_plugins = %w(vagrant-hostmanager)
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = "ubuntu-s-2vcpu-4gb-amd-fra1-01"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 2
    vb.name = "wordpress-ansible-docker"
    vb.customize ["setproperty", "machinefolder", "/goinfre/" + ENV['USER'] + "/VirtualBox VMs"]
  end

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get upgrade -y
    apt-get install -y software-properties-common
    apt-add-repository --yes --update ppa:ansible/ansible
    apt-get install -y ansible python3-pip
    ansible-galaxy collection install community.digitalocean
    mkdir -p /etc/ansible
    chmod 600 /home/vagrant/.ssh/id_rsa
    chmod 644 /home/vagrant/.ssh/id_rsa.pub
    chown vagrant:vagrant /home/vagrant/.ssh/id_rsa*
    cp /vagrant/ansible.cfg /etc/ansible/
    cp /vagrant/inventory /etc/ansible/hosts
  SHELL

  config.vm.provision "shell", privileged: false, env: { "DO_API_TOKEN" => ENV['DO_API_TOKEN'] }, inline: <<-SHELL
    cd /vagrant && ANSIBLE_HOST_KEY_CHECKING=False DO_API_TOKEN=$DO_API_TOKEN ansible-playbook playbook.yml
  SHELL

  config.vm.post_up_message = <<-MESSAGE
    Your environment is ready!
    
    The Ansible playbook has been executed and should have:
    1. Created the DigitalOcean droplet
    2. Installed Docker and Docker Compose
    3. Deployed your application
    
    Local Environment Access:
    WordPress: http://192.168.56.10 or http://localhost:8080
    PHPMyAdmin: http://192.168.56.10:8080 or http://localhost:8081
    
    To SSH into the VM:
    $ vagrant ssh
    
    To run Ansible playbook again:
    $ vagrant ssh
    $ cd /vagrant && DO_API_TOKEN='your_token' ansible-playbook playbook.yml
    
    To stop the VM:
    $ vagrant halt
    
    To destroy the VM:
    $ vagrant destroy

    VM is stored in: /goinfre/#{ENV['USER']}/VirtualBox VMs
  MESSAGE
end 