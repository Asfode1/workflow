# Используем официальный образ Go для сборки
FROM golang:1.21-alpine AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем go.mod и go.sum
COPY go.mod go.sum ./

# Загружаем зависимости
RUN go mod download

# Копируем исходный код
COPY . .

# Собираем приложение
RUN CGO_ENABLED=1 GOOS=linux go build -a -installsuffix cgo -o main .

# Используем минимальный образ для запуска
FROM alpine:latest

# Устанавливаем SQLite
RUN apk --no-cache add ca-certificates sqlite

# Создаем пользователя для безопасности
RUN adduser -D -s /bin/sh appuser

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранное приложение
COPY --from=builder /app/main .

# Копируем базу данных (если есть)
COPY --from=builder /app/tracker.db* ./

# Меняем владельца файлов
RUN chown -R appuser:appuser /app

# Переключаемся на непривилегированного пользователя
USER appuser

# Открываем порт (если приложение будет работать как веб-сервис)
# EXPOSE 8080

# Запускаем приложение
CMD ["./main"]
