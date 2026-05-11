Markdown
Copy
Code
Preview
# Домашнее задание к занятию «GitLab»

**Выполнил:** Андрей Санакин

---

## Задание 1: Развёртывание GitLab и регистрация Runner

### Инфраструктура
- **GitLab Server:** http://46.21.245.114
- **GitLab Runner:** 192.168.100.28 (Docker executor)
- **SonarQube:** http://93.77.184.24:9000

### Настройки Runner
![Runner в GitLab Admin Area](screenshots/runner-admin.png)

**Параметры Runner:**
- Имя: `551611672e23`
- Версия: `18.11.3`
- Executor: `docker`
- Теги: `docker`, `yc`
- Статус: **Online**

---

## Задание 2: CI/CD Pipeline

### Файл `.gitlab-ci.yml`

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
Успешная сборка Pipeline #7
screenshots/pipeline-passed.png
Результат:
Pipeline: #7 Passed
build_job: ✅ Успешно
test_job: ✅ Успешно
Время выполнения: 11 секунд
Задание 3* (Дополнительное): Оптимизация CI
Требования:
Этап сборки запускается сразу, не дожидаясь тестов
Тесты запускаются только при изменении файлов *.go
Решение:
yaml
Copy
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
Пояснение:
rules: changes: "*.go" — тесты запускаются только если изменились .go файлы
build_job запускается сразу (параллельно с другими jobs в stage build)
Инфраструктура (Terraform + Ansible)
Созданные ресурсы Yandex Cloud
Table
Ресурс	IP	Роль
gitlab-server	46.21.245.114	GitLab CE в Docker
gitlab-runner	192.168.100.28	GitLab Runner (Docker executor)
sonarqube-server	93.77.184.24	SonarQube + PostgreSQL
Ключевые файлы
terraform/main.tf — конфигурация инфраструктуры
terraform/terraform.tfvars — переменные
ansible/inventory.ini — inventory серверов
ansible/playbooks/install-all.yml — установка сервисов
.gitlab-ci.yml — CI/CD pipeline
Доступы
Table
Сервис	URL	Логин	Пароль
GitLab	http://46.21.245.114	root	R4ZKmbNK2ET0nazVSKEjnvtW/Iexx9mccflLJ+Ahpxc=
SonarQube	http://93.77.184.24:9000	admin	admin
