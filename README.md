# Norvoter - Система учета показаний счетчиков воды

## Описание проекта
Веб-приложение для учета показаний счетчиков воды. Позволяет пользователям добавлять счетчики, вводить показания и отслеживать расход воды.

## Файловая структура проекта
lab1-project/
├── manage.py
├── requirements.txt
├── .env.example
├── .flake8
├── .pre-commit-config.yaml
├── pyproject.toml
├── docker-compose.yml
├── meters/ # Основное приложение
│ ├── models.py
│ ├── views.py
│ ├── urls.py
│ ├── migrations/
│ ├── static/
│ └── templates/
├── water_meters_project/ # Конфигурация проекта
│ ├── settings.py
│ ├── urls.py
│ └── wsgi.py
├── minio_data/ # Данные MinIO (игнорировать в git)
└── backups/ # SQL бэкапы
├── back.sql
├── backup.sql
└── backup6.sql

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
