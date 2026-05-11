# Django Docker Project

This project runs a Django application using Docker with PostgreSQL and Redis.

## Overview

* Multi-stage Docker build is used to reduce image size and improve performance
* Alpine Linux is used for a lightweight environment
* The container runs with a non-root user for better security
* Health checks are included to monitor service status
* Services start in the correct order using depends_on
* Volumes are used to persist data outside containers

## Services

* **web**: Django application running with Gunicorn
* **db**: PostgreSQL database
* **redis**: Redis for caching

## Requirements

* Docker
* Docker Compose

## Setup

1. Create a `.env` file and add your environment variables:

```
POSTGRES_DB=your_db
POSTGRES_USER=your_user
POSTGRES_PASSWORD=your_password
```

2. Build and run the project:

```
docker-compose up --build -d
```

3. Apply migrations and collect static files (if not automated):

```
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py collectstatic --noinput
```

## Access

Open your browser and go to:

```
http://localhost:8000
```

## Notes

* Static and media files are stored using Docker volumes
* Database data is persisted even if containers are removed
* Do not include `.env` in version control for security reasons

---

