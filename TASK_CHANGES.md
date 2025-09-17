



# Task Branch Changes

## Изменения по заданию

### 1. Создан единый workflow файл с двумя job
- **Файл**: `.github/workflows/ci-cd.yml`
- **Job `test`**: Тестирование, линтинг и сборка приложения
- **Job `docker`**: Публикация на DockerHub (только при git tag)

### 2. Настроена публикация на DockerHub по git tag
- Публикация происходит **только** при создании git tag с версией (например, `v1.0.0`)
- Условие: `if: github.event_name == 'push' && startsWith(github.ref, 'refs/tags/v')`
- Docker job зависит от успешного выполнения test job: `needs: test`

### 3. Удалены старые отдельные workflow файлы
- Удален `.github/workflows/docker-publish.yml`
- Удален `.github/workflows/test.yml`
- Остался только единый `.github/workflows/ci-cd.yml`

### 4. Добавлена документация
- **Файл**: `DOCKER_DEPLOYMENT.md` - инструкции по тестированию публикации на DockerHub

## Как протестировать
1. Создать git tag: `git tag v1.0.0 && git push origin v1.0.0`
2. Проверить выполнение workflow в GitHub Actions
3. Убедиться что образ появился на DockerHub с тегом `v1.0.0`