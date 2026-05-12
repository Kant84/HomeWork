<img width="1929" height="1080" alt="Снимок экрана (979)" src="https://github.com/user-attachments/assets/8079416d-4514-47aa-8972-5ffbb1a40025" />


Домашнее задание «GitLab CI/CD»
Выполнил: Андрей Санакин
---
📋 Содержание
Инфраструктура


Задание 1: Развёртывание GitLab и регистрация Runner


Задание 2: CI/CD Pipeline


Задание 3: Оптимизация CI (дополнительное)


Ключевые файлы
Проблемы и решения
Доступы
---
🏗️ Инфраструктура
Ресурс	IP-адрес	Роль
`gitlab-server`	`46.21.245.114`	GitLab CE в Docker
`gitlab-runner`	`192.168.100.28`	GitLab Runner (Docker executor)
`sonarqube-server`	`93.77.184.24`	SonarQube + PostgreSQL
Провайдер: Yandex Cloud  
Инструменты: Terraform + Ansible + Docker
---
Задание 1: Развёртывание GitLab и регистрация Runner

<img width="1905" height="1080" alt="Снимок экрана (980)" src="https://github.com/user-attachments/assets/220fe3a7-9161-42c5-9319-c701436c49a2" />



GitLab Server
URL: http://46.21.245.114
Развёртывание: Docker-контейнер с GitLab CE
Настройка: `external_url` в `/etc/gitlab/gitlab.rb` привязан к внешнему IP
GitLab Runner
IP: 192.168.100.28
Executor: Docker
Теги: `docker`, `yc`
Статус: Online ✅
Параметр	Значение
Имя	`551611672e23`
Версия	`18.11.3`
Executor	`docker`
Теги	`docker`, `yc`
> 💡 **Особенность:** Runner размещён во внутренней сети без внешнего IP. Для доступа к интернету используется NAT Gateway. SSH-доступ осуществляется через GitLab Server (ProxyCommand).
---
Задание 2: CI/CD Pipeline
<img width="1924" height="1080" alt="Снимок экрана (987)" src="https://github.com/user-attachments/assets/24e7ca1b-4672-4b9c-8792-5d7adf8fe9ec" /><img 



Файл `.gitlab-ci.yml`
```yaml
stages:
  - build
  - test

build_job:
  stage: build
  tags:
    - docker
  script:
    - echo "Building application..."
    - docker --version

test_job:
  stage: test
  tags:
    - docker
  script:
    - echo "Running tests..."
    - echo "All tests passed!"
```
Результат
Pipeline	build_job	test_job
#7	✅ Успешно	✅ Успешно
> **Статус:** Pipeline #7 Passed 🎉
---
Задание 3: Оптимизация CI (дополнительное)
Требования
Этап сборки запускается сразу, не дожидаясь результатов тестов
Тесты запускаются только при изменении файлов с расширением `*.go`
Решение
```yaml
stages:
  - build
  - test

build_job:
  stage: build
  tags:
    - docker
  script:
    - echo "Building application..."
    - docker --version

test_job:
  stage: test
  tags:
    - docker
  rules:
    - changes:
        - "*.go"
  script:
    - echo "Running tests..."
    - echo "All tests passed!"
```
Пояснение
Правило	Описание
`rules: changes: "*.go"`	Тесты запускаются только при изменении `.go` файлов
`build_job`	Выполняется сразу — jobs внутри одного stage работают параллельно
Без `needs`	Зависимости между stages сохраняются, но внутри stage — параллельно
---
📁 Ключевые файлы
Файл	Назначение
`terraform/main.tf`	Конфигурация инфраструктуры Yandex Cloud
`terraform/terraform.tfvars`	Переменные (`cloud_id`, `folder_id`, образ Ubuntu)
`ansible/inventory.ini`	Inventory серверов с группами `[gitlab]`, `[gitlab_runner]`, `[sonarqube]`
`ansible/playbooks/install-all.yml`	Установка Docker, GitLab, Runner, SonarQube
`.gitlab-ci.yml`	CI/CD pipeline
---


Runner без интернета	Создан NAT Gateway в Yandex Cloud. Без него Runner не мог установить Docker и скачивать образы
GitLab external_url	Настроен на внешний IP `http://46.21.245.114`. Иначе Runner использовал hostname контейнера и не мог клонировать репозиторий
SonarQube права	Исправлены права на `/srv/sonarqube/data` (`chown 1000:1000`). Контейнер SonarQube работает от UID 1000, иначе Elasticsearch не создавал директорию конфигурации


Ansible inventory для Runner	Добавлен `ProxyCommand` (SSH через GitLab сервер), так как Runner во внутренней сети без внешнего IP
Чувствительные данные в Git	Файлы `terraform.tfvars` и `key.json` исключены из Git через `.gitignore`


---


🔐 Доступы
Сервис	URL	Логин	Пароль
GitLab	http://46.21.245.114	`root`	(запросить у автора)
SonarQube	http://93.77.184.24:9000	`admin`	(стандартный, сменить при первом входе)
---
🛠️ Технологический стек
<p align="left">
  <img src="https://img.shields.io/badge/GitLab-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white" alt="GitLab"/>
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker"/>
  <img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
  <img src="https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white" alt="Ansible"/>
  <img src="https://img.shields.io/badge/Yandex_Cloud-5282FF?style=for-the-badge&logo=yandex&logoColor=white" alt="Yandex Cloud"/>
  <img src="https://img.shields.io/badge/SonarQube-4E9BCD?style=for-the-badge&logo=sonarqube&logoColor=white" alt="SonarQube"/>
</p>
---
> 📌 **Примечание:** Проект выполнен в рамках домашнего задания по GitLab CI/CD. Вся инфраструктура развёрнута в Yandex Cloud с использованием IaC-подхода (Terraform + Ansible).
