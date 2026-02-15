# Test_task_for_GetBlock

В этом докерфайле используется два образа,rust:1.75-slim необходим для сборки бинарников, 
debian:bookworm-slim для полноценного запуска контейнера с отладкой

### Команда для сборки и запуска контейнера

Вы должны находиться внутри скачанного репозитория рядом с dockerfile

```bash
docker build -t agave-yellowstone:v1.0.0 .
docker run --rm -it --entrypoint bash agave-yellowstone:v1.0.0
```

По итогам сборки конечный размер image 168MB

