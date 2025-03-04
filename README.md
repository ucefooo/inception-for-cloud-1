# WordPress Docker Setup

A Docker Compose setup for WordPress with MySQL and PHPMyAdmin, featuring automatic installation and configuration.

## Features

- WordPress latest version
- MySQL database
- PHPMyAdmin for database management
- Automatic WordPress installation
- Pre-configured admin account
- Twenty Twenty-Three theme pre-installed
- Persistent data storage

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1. Clone this repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Start the containers:
```bash
docker-compose up
```

3. Access the applications:
- WordPress: http://localhost:8080
- PHPMyAdmin: http://localhost:8081

## Default Credentials

### WordPress Admin
- Username: `admin`
- Password: `admin123`
- Email: admin@example.com

### MySQL
- Root Password: `root_password`
- Database: `wordpress`
- User: `wordpress`
- Password: `wordpress_password`

### PHPMyAdmin
- Username: `root`
- Password: `root_password`

## Directory Structure

```
.
├── docker-compose.yml
├── docker-entrypoint.sh
└── README.md
```

## Volumes

- `wordpress_data`: Stores WordPress files
- `mysql_data`: Stores MySQL database files

## Environment Variables

### WordPress
- `WORDPRESS_DB_HOST`: MySQL host
- `WORDPRESS_DB_USER`: Database user
- `WORDPRESS_DB_PASSWORD`: Database password
- `WORDPRESS_DB_NAME`: Database name
- `WORDPRESS_DEBUG`: Debug mode (1 for enabled)

### MySQL
- `MYSQL_ROOT_PASSWORD`: Root password
- `MYSQL_DATABASE`: Database name
- `MYSQL_USER`: Database user
- `MYSQL_PASSWORD`: Database password

### PHPMyAdmin
- `PMA_HOST`: MySQL host
- `MYSQL_ROOT_PASSWORD`: Root password

## Maintenance

### Stop the containers
```bash
docker-compose down
```

### Stop and remove volumes
```bash
docker-compose down -v
```

### Rebuild containers
```bash
docker-compose up --build
```

### View logs
```bash
docker-compose logs -f
```

## Troubleshooting

1. If WordPress can't connect to MySQL:
   - Ensure MySQL container is running
   - Check database credentials
   - Wait a few minutes for MySQL to initialize

2. If you can't access PHPMyAdmin:
   - Verify MySQL is running
   - Check if port 8081 is available
   - Verify root password

3. If WordPress installation fails:
   - Check container logs
   - Ensure all environment variables are set
   - Try rebuilding containers

## License

MIT License 