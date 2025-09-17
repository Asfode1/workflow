# Docker Deployment Guide

## Как работает публикация на DockerHub

### Триггеры для публикации
Публикация на DockerHub происходит **только при создании git tag** с версией (например, `v1.0.0`, `v2.1.3`).

### Workflow структура
- **Job `test`**: Запускается при каждом push в main/develop и при PR
  - Устанавливает Go 1.21
  - Запускает линтер (golangci-lint)
  - Выполняет тесты
  - Собирает приложение
  - Проверяет что приложение запускается

- **Job `docker`**: Запускается **только** при push с git tag
  - Зависит от успешного выполнения job `test`
  - Собирает Docker образ для платформ linux/amd64 и linux/arm64
  - Публикует на DockerHub с тегами:
    - `username/parcel-tracker:latest` (если это default branch)
    - `username/parcel-tracker:v1.0.0` (версия из tag)
    - `username/parcel-tracker:1.0` (major.minor)

### Как протестировать публикацию

1. **Создайте git tag:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Проверьте в GitHub Actions:**
   - Перейдите в раздел "Actions" репозитория
   - Найдите workflow "CI/CD Pipeline"
   - Убедитесь что выполнились оба job: `test` и `docker`

3. **Проверьте на DockerHub:**
   - Перейдите в ваш DockerHub репозиторий
   - Убедитесь что появился новый образ с тегом `v1.0.0`

### Настройка секретов
Убедитесь что в настройках репозитория GitHub добавлены секреты:
- `DOCKERHUB_USERNAME` - ваш username на DockerHub
- `DOCKERHUB_TOKEN` - токен доступа к DockerHub

### Примеры тегов для тестирования
- `v1.0.0` - семантическая версия
- `v2.1.3` - патч версия
- `v1.0.0-beta` - пре-релиз версия


