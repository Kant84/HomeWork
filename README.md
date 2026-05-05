# Домашнее задание к занятию «Git»
Автор: Андрей Санакин

## Задание 1 — Первый коммит

Создан репозиторий, выполнены команды:
- `git clone`
- `git config`
- `git status`
- `git diff` / `git diff --staged`
- `git add`
- `git commit`
- `git push`

**Ссылка на коммит:** https://github.com/Kant84/HomeWork/commit/f4dce24078608a74137ba04a1e2d2d80d9aa430a

---

## Задание 2 — .gitignore

Создан файл `.gitignore` с правилами:
- `*.pyc` — игнорировать скомпилированные Python-файлы
- `cache/` — игнорировать директорию cache

**Ссылка на коммит:** https://github.com/Kant84/HomeWork/commit/a8dc5dbe151055adeae0799083411ba3bdc23b12

---

## Задание 3 — Работа с ветками

Создана ветка `dev`, в ней выполнена работа с файлом `test.sh` (10 коммитов).
В основной ветке `main` создан файл `main.sh`.
Ветка `dev` слита в `main` через `git merge`.

**Ссылка на граф коммитов:** https://github.com/Kant84/HomeWork/network

---

## Задание 4* — Конфликт

Создана ветка `conflict`, в ней изменена та же строка в `test.sh`, что и в `main`.
При мердже возник конфликт, который был решён в пользу ветки `conflict`.

**Ссылка на граф коммитов:** https://github.com/Kant84/HomeWork/network
