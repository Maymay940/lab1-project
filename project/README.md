# Norvoter - Система учета показаний счетчиков воды

## Описание проекта
Веб-приложение для учета показаний счетчиков воды. Позволяет пользователям добавлять счетчики, вводить показания и отслеживать расход воды.

## Файловая структура проекта
C:.
│   .env.example
│   .flake8
│   .gitignore
│   .pre-commit-config.yaml
│   back.sql
│   backup.sql
│   backup6.sql
│   docker-compose.yml
│   manage.py
│   pyproject.toml
│   README.md
│   requirements.txt
│
├───meters
│   │   models.py
│   │   urls.py
│   │   views.py
│   │
│   ├───migrations
│   │   │   0001_initial.py
│   │   │   __init__.py
│   │   │
│   │   └───__pycache__
│   │           0001_initial.cpython-311.pyc
│   │           0001_initial.cpython-313.pyc
│   │           __init__.cpython-311.pyc
│   │           __init__.cpython-313.pyc
│   │
│   ├───static
│   │   └───meters
│   │       ├───css
│   │       │       style.css
│   │       │
│   │       └───imagers
│   │               logo.png
│   │
│   ├───templates
│   │   └───meters
│   │           meter_detail.html
│   │           meter_list.html
│   │           request_detail.html
│   │           request_list.html
│   │
│   └───__pycache__
│           models.cpython-311.pyc
│           models.cpython-313.pyc
│           urls.cpython-311.pyc
│           urls.cpython-313.pyc
│           views.cpython-311.pyc
│           views.cpython-313.pyc
│
├───minio_data
│   ├───.minio.sys
│   │   │   format.json
│   │   │
│   │   ├───buckets
│   │   │   ├───.bloomcycle.bin
│   │   │   │       xl.meta
│   │   │   │
│   │   │   ├───.heal
│   │   │   │   └───mrf
│   │   │   │           list.bin
│   │   │   │
│   │   │   ├───.usage-cache.bin
│   │   │   │       xl.meta
│   │   │   │
│   │   │   ├───.usage-cache.bin.bkp
│   │   │   │       xl.meta
│   │   │   │
│   │   │   ├───.usage.json
│   │   │   │       xl.meta
│   │   │   │
│   │   │   └───meters
│   │   │       ├───.metadata.bin
│   │   │       │       xl.meta
│   │   │       │
│   │   │       ├───.usage-cache.bin
│   │   │       │       xl.meta
│   │   │       │
│   │   │       └───.usage-cache.bin.bkp
│   │   │               xl.meta
│   │   │
│   │   ├───config
│   │   │   ├───config.json
│   │   │   │       xl.meta
│   │   │   │
│   │   │   └───iam
│   │   │       ├───format.json
│   │   │       │       xl.meta
│   │   │       │
│   │   │       └───sts
│   │   │           └───Z89HKF0RD6QAPMHIU0ID
│   │   │               └───identity.json
│   │   │                       xl.meta
│   │   │
│   │   ├───multipart
│   │   ├───pool.bin
│   │   │       xl.meta
│   │   │
│   │   └───tmp
│   │       │   06d46f48-7911-43a2-a143-ae1c9a80066e
│   │       │
│   │       └───.trash
│   └───meters
│       ├───imagers
│       │   ├───photo1.jpeg
│       │   │       xl.meta
│       │   │
│       │   ├───photo2.png
│       │   │   │   xl.meta
│       │   │   │
│       │   │   └───92a28861-dcca-4b69-97fb-447b84bec3b1
│       │   │           part.1
│       │   │
│       │   ├───photo3.png
│       │   │   │   xl.meta
│       │   │   │
│       │   │   └───cc116c1e-bd09-4501-89ae-23aae08029e2
│       │   │           part.1
│       │   │
│       │   ├───photo4.png
│       │   │   │   xl.meta
│       │   │   │
│       │   │   └───bb46c3f7-3114-404a-8bbe-81d37a6261bc
│       │   │           part.1
│       │   │
│       │   ├───photo5.png
│       │   │   │   xl.meta
│       │   │   │
│       │   │   └───0294f53c-a4a3-44ff-ae5a-94ef53c04615
│       │   │           part.1
│       │   │
│       │   ├───photo6.png
│       │   │   │   xl.meta
│       │   │   │
│       │   │   └───ba0e1c63-3d98-4055-9fdb-0c808db56395
│       │   │           part.1
│       │   │
│       │   ├───photo7.png
│       │   │   │   xl.meta
│       │   │   │
│       │   │   └───3ef333e4-f33f-4631-9052-909ccbf2f3ef
│       │   │           part.1
│       │   │
│       │   └───photo8.png
│       │           xl.meta
│       │
│       └───video
│           └───video_water.mp4
│               │   xl.meta
│               │
│               └───5e5ca4e3-0e4b-40dc-95c2-18a110c0f440
│                       part.1
│
└───water_meters_project
    │   asgi.py
    │   settings.py
    │   urls.py
    │   wsgi.py
    │   __init__.py
    │
    └───__pycache__
            settings.cpython-311.pyc
            settings.cpython-313.pyc
            urls.cpython-311.pyc
            urls.cpython-313.pyc
            wsgi.cpython-311.pyc
            wsgi.cpython-313.pyc
            __init__.cpython-311.pyc
            __init__.cpython-313.pyc

## Технологии
- **Backend**: Django 4.2 (https://www.djangoproject.com/)
- **Database**: PostgreSQL 15 в Docker (https://www.postgresql.org/)
- **File Storage**: MinIO в Docker (https://min.io/)
- **Database Admin**: Adminer в Docker (http://localhost:8080)
- **Container**: Docker + Docker Compose (https://www.docker.com/)
- **Code Quality**:
  - Flake8 (линтер) (https://flake8.pycqa.org/)
  - Black (форматтер) (https://black.readthedocs.io/)
  - isort (сортировка импортов) (https://pycqa.github.io/isort/)
  - pre-commit (хуки) (https://pre-commit.com/)

## Установка и запуск

### Предварительные требования
- Установленный Docker Desktop
- Установленный Python 3.11+
- Git

### Запуск через Docker (рекомендуется)

1. **Клонировать репозиторий**
   ```bash
   git clone <url-репозитория>
   cd project