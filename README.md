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