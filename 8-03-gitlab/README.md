# Домашнее задание к занятию «GitLab»

**Выполнил:** Андрей Санакин

---

## Задание 1: Развёртывание GitLab и регистрация Runner
бдл
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

Задание 3* (Дополнительное): Оптимизация CI
Требования:
Этап сборки запускается сразу, не дожидаясь результатов тестов
Тесты запускаются только при изменении файлов с расширением *.go
Решение:
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
Без needs jobs внутри одного stage выполняются параллельно

Инфраструктура (Terraform + Ansible)
Созданные ресурсы Yandex Cloud
| Ресурс           | IP             | Роль                            |
| ---------------- | -------------- | ------------------------------- |
| gitlab-server    | 46.21.245.114  | GitLab CE в Docker              |
| gitlab-runner    | 192.168.100.28 | GitLab Runner (Docker executor) |
| sonarqube-server | 93.77.184.24   | SonarQube + PostgreSQL          |

Ключевые файлы
terraform/main.tf — конфигурация инфраструктуры
terraform/terraform.tfvars — переменные (cloud_id, folder_id, образ Ubuntu)
ansible/inventory.ini — inventory серверов с группами [gitlab], [gitlab_runner], [sonarqube]
ansible/playbooks/install-all.yml — установка Docker, GitLab, Runner, SonarQube
.gitlab-ci.yml — CI/CD pipeline

Примечания по запуску 
Что было сделано для работоспособности:
SSH-ключи: Сгенерирован ED25519 ключ (~/.ssh/id_ed25519) — стандартный RSA не работал с Ubuntu 22.04 в Yandex Cloud из-за обновления OpenSSH 8.8+
Пользователь VM: Используется ubuntu (не yc-user) — cloud-init в стандартных образах Ubuntu 22.04 создаёт именно пользователя ubuntu и кладёт ключ в /home/ubuntu/.ssh/authorized_keys
NAT Gateway: Создан в Yandex Cloud для GitLab Runner (без внешнего IP) — без него Runner не имел доступа к интернету для установки Docker и скачивания образов
GitLab external_url: Настроен на внешний IP http://46.21.245.114 в /etc/gitlab/gitlab.rb — иначе Runner использовал hostname контейера и не мог клонировать репозиторий
SonarQube права: Исправлены права на /srv/sonarqube/data (chown 1000:1000) — контейнер SonarQube работает от UID 1000, иначе Elasticsearch не мог создать директорию конфигурации
Ansible inventory: Для Runner добавлен ProxyCommand (SSH через GitLab сервер) — так как Runner находится во внутренней сети без внешнего IP
Terraform .gitignore: Файл terraform.tfvars и key.json исключены из Git — содержат чувствительные данные (ID облака, ключи доступа)

Доступы 
| Сервис    | URL                        | Логин | Пароль                                    |
| --------- | -------------------------- | ----- | ----------------------------------------- |
| GitLab    | <http://46.21.245.114>     | root  | *(запросить у автора)*                    |
| SonarQube | <http://93.77.184.24:9000> | admin | *(стандартный, сменить при первом входе)* |
