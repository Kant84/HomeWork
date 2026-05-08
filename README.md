# Домашнее задание «Что такое DevOps. CI/CD»
## Автор: Андрей Санакин

## Задание 1: Freestyle Project

Создан проект `go-test-build` в Jenkins.

Подключен репозиторий: `https://github.com/Kant84/sdvps-materials.git`

Выполняются команды:
- `go test .`
- `docker build . -t hello-world:v$BUILD_NUMBER`

**Настройки Git:**
![Настройки Git](https://github.com/Kant84/sdvps-materials/blob/main/screenshots/рисунок_1.png)

**Build Steps (скрипт сборки):**
![Build Steps](https://github.com/Kant84/sdvps-materials/blob/main/screenshots/рисунок_2.png)

**Результат сборки (Console Output):**
![Console Output](https://github.com/Kant84/sdvps-materials/blob/main/screenshots/рисунок_3.png)

Статус: **SUCCESS**

---

## Задание 2: Pipeline

Создан проект `go-test-pipeline` в Jenkins.

Declarative pipeline с этапами: Git → Test → Build Binary → Upload to Nexus

**Stage View (все этапы зелёные):**
![Stage View](https://github.com/Kant84/sdvps-materials/blob/main/screenshots/рисунок_4.png)

**Console Output (Docker build):**
![Docker Build](https://github.com/Kant84/sdvps-materials/blob/main/screenshots/рисунок_5.png)

Статус: **SUCCESS**

---

## Задание 3: Nexus + бинарный файл

Установлен Nexus на `http://192.168.101.146:8081`

Создан raw-hosted репозиторий `go-binaries`

Pipeline модифицирован:
- Сборка бинарного файла: `CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o app .`
- Загрузка в Nexus через `curl`

**Репозиторий Nexus с загруженным файлом:**
![Nexus Repository](https://github.com/Kant84/sdvps-materials/blob/main/screenshots/рисунок_6.png)

**Console Output — загрузка в Nexus (HTTP 201 Created):**
![Upload to Nexus](https://github.com/Kant84/sdvps-materials/blob/main/screenshots/рисунок_7.png)

Файл `app-v3` успешно загружен.

---

## Задание 4*: Версионирование

Используется переменная `BUILD_NUMBER`.

Файлы именуются: `app-v1`, `app-v2`, `app-v3`...

**Несколько версий в Nexus:**
![Версии в Nexus](https://github.com/Kant84/sdvps-materials/blob/main/screenshots/рисунок_8.png)
