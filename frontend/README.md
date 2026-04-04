# Norvoter Frontend (HTML/CSS/JS + Nginx)

## Описание
Статический фронтенд для системы учёта показаний счётчиков воды. Загружает данные через API бэкенда и отображает их.

## Технологии
- [HTML5](https://developer.mozilla.org/ru/docs/Web/HTML)
- [CSS3](https://developer.mozilla.org/ru/docs/Web/CSS)
- [JavaScript (Fetch API)](https://developer.mozilla.org/ru/docs/Web/API/Fetch_API)
- [Nginx](https://nginx.org/ru/docs/)

## Структура
frontend/  
├── static/                       
│   └── meters/  
│       ├── css/  
│       └── imagers/  
├── templates/                  
│   └── meters/  
├── Dockerfile  
└── nginx.conf
## Запуск (через Docker)
```bash
 cd backend
 docker-compose up -d
```
## Особенности
- Все данные загружаются через fetch('/api/...').
- Nginx проксирует запросы /api/ на бэкенд.
- Статика отдаётся через /static/.

## Примечания
- Фронтенд работает только при запущенном бэкенде.
- CSS и HTML полностью статические, без шаблонизаторов.