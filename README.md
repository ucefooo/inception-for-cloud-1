# Docker Deployment with Ansible on DigitalOcean

This repository contains Ansible playbooks and configuration files to automate the deployment of Docker and your application to DigitalOcean droplets.

## Prerequisites

1. Ansible installed on your local machine:
   ```bash
   pip install ansible
   ```

2. DigitalOcean account and API token
3. SSH key added to your DigitalOcean account
4. Python installed on your local machine

## Setup Instructions

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Update the inventory file with your droplet IPs:
   ```
   [droplets]
   droplet1 ansible_host=YOUR_DROPLET_IP
   ```

3. Ensure your SSH key is properly configured:
   - The default path is `~/.ssh/id_rsa`
   - If your key is in a different location, update `ansible.cfg`

4. Test the connection:
   ```bash
   ansible droplets -m ping
   ```

## Deployment

1. Run the playbook:
   ```bash
   ansible-playbook playbook.yml
   ```

This will:
- Install Docker and Docker Compose on your droplets
- Copy necessary files to the droplets
- Start the Docker service
- Deploy your application using docker-compose

## File Structure

```
.
├── ansible.cfg           # Ansible configuration
├── inventory            # Inventory file with droplet IPs
├── playbook.yml         # Main Ansible playbook
├── docker-compose.yml   # Docker Compose configuration
└── docker-entrypoint.sh # Entrypoint script for containers
```

## Maintenance

- To update your application:
  ```bash
  ansible-playbook playbook.yml --tags update
  ```

- To check status:
  ```bash
  ansible droplets -a "docker-compose -f /opt/app/docker-compose.yml ps"
  ```

## Troubleshooting

1. If you can't connect to your droplets:
   - Verify the IP addresses in the inventory file
   - Check your SSH key permissions
   - Ensure the droplet's firewall allows SSH (port 22)

2. If Docker Compose fails:
   - Check the logs: `ansible droplets -a "docker-compose -f /opt/app/docker-compose.yml logs"`
   - Verify all required files are present in /opt/app/

## Security Notes

- The playbook uses root access by default
- Consider implementing additional security measures:
  - UFW firewall rules
  - Non-root user for Docker
  - Custom SSH port
  - Rate limiting

# WordPress Docker Development Environment

This repository contains a Vagrant configuration for running WordPress with Docker and Docker Compose.

## Prerequisites

1. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Vagrant](https://www.vagrantup.com/downloads)

## Quick Start

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Start the VM:
   ```bash
   vagrant up
   ```

That's it! The setup will:
- Create an Ubuntu 20.04 VM with 4GB RAM and 2 CPUs
- Install Docker and Docker Compose
- Set up WordPress and MySQL
- Configure networking and port forwarding

## Accessing the Services

- WordPress: http://localhost:8080
- PHPMyAdmin: http://localhost:8081

## Default Credentials

### WordPress Admin
- Username: admin
- Password: admin123

### Database
- Root Password: root_password
- Database: wordpress
- User: wordpress
- Password: wordpress_password

## Vagrant Commands

- Start the VM: `vagrant up`
- SSH into the VM: `vagrant ssh`
- Stop the VM: `vagrant halt`
- Destroy the VM: `vagrant destroy`
- Rebuild the VM: `vagrant destroy && vagrant up`

## Directory Structure

The project directory is synced to `/opt/app` in the VM. Any changes you make to the files locally will be reflected in the VM automatically.

## Customization

You can modify the following in the Vagrantfile:
- VM resources (RAM, CPU)
- Port forwarding
- Network configuration
- Provisioning scripts

## Troubleshooting

1. If ports are already in use:
   - Change the host ports in the Vagrantfile
   - Run `vagrant reload`

2. If VM fails to start:
   - Ensure VirtualBox is properly installed
   - Check if virtualization is enabled in BIOS
   - Try `vagrant destroy` and then `vagrant up`

3. If services don't start:
   - SSH into the VM: `vagrant ssh`
   - Check Docker status: `sudo systemctl status docker`
   - Check logs: `docker-compose logs` 