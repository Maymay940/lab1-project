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
├── meters/  
│   ├── models.py  
│   ├── views.py  
│   ├── urls.py  
│   ├── migrations/  
│   ├── static/  
│   └── templates/  
├── water_meters_project/  
│   ├── settings.py  
│   ├── urls.py  
│   └── wsgi.py  
├── minio_data/            
└── backups/               
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

### Запуск через Docker 

1. **Клонировать репозиторий**
   ```bash
   git clone <url-репозитория>
   cd project
   ```

2. **Перейти в папку с backend**
  ```bash
   cd backend
  ```

3. **Запустить все контейнеры**
  ```bash
   docker-compose up -d
  ```

4. **Проверить, что все контейнеры запустились**
  ```bash
   docker ps
  ```

5. **Открыть приложение в браузере**
- Главная страница: http://localhost
- Список заявок:	http://localhost/request_list.html
- API (список счетчиков): http://localhost:8000/api/meters/
- Adminer (управление БД):	http://localhost:8080
- MinIO Console:	http://localhost:9001
  

6. **Данные для входа в Adminer**
- Открыть в браузере: http://localhost:8080
- Система: PostgreSQL
- Сервер: postgres
- Пользователь: postgres2
- Пароль: 1qaz
- База данных: norvoter

7. **Данные для входа в MinIO**
- Открыть в браузере: http://localhost:9001
- Логин: minioadmin
- Пароль: minioadmin123

8. **Остановка всех контейнеров**
  ```bash
   docker-compose down
  ```

9. **Остановка с удалением всех данных (томов)**
  ```bash
   docker-compose down -v
  ```

### Запуск без Docker (локальная разработка)

1. **Создать виртуальное окружение**
  ```bash
   python -m venv .venv
  ```

2. **Активировать виртуальное окружение**
**Windows:**
  ```bash
   .venv\Scripts\activate
  ```

**Linux/Mac:**
  ```bash
   source .venv/bin/activate
  ```

3. **Установить зависимости**
  ```bash
   pip install -r requirements.txt
  ```

4. **Создать файл .env из .env.example**
  ```bash
   copy .env.example .env
  ```

5. **Применить миграции**
  ```bash
   python manage.py migrate
  ```

6. **Запустить сервер разработки**
  ```bash
   python manage.py runserver
  ```