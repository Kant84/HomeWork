# Домашнее задание: Система мониторинга Zabbix

**Выполнил:** Andrei

---

## Задание 1. Установка Zabbix Server с веб-интерфейсом

### Команды установки

```bash
# Репозиторий Zabbix 7.0
wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian13_all.deb
dpkg -i zabbix-release_latest_7.0+debian13_all.deb
apt update

# Установка компонентов
apt install zabbix-server-pgsql zabbix-frontend-php php8.4-pgsql \
  zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# База данных PostgreSQL
su - postgres -c 'psql --command "CREATE USER zabbix WITH PASSWORD '\''123456789'\'';"'
su - postgres -c 'psql --command "CREATE DATABASE zabbix OWNER zabbix;"'

# Импорт схемы
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | \
  sudo -u zabbix psql zabbix

# Конфиг сервера
sed -i 's/# DBPassword=/DBPassword=123456789/g' /etc/zabbix/zabbix_server.conf

# Запуск
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
Скриншот авторизации
img/screenshot_login.png
Задание 2. Установка Zabbix Agent на два хоста
Агент 1 (zabbix-agent)
bash
Copy
systemctl status zabbix-agent
grep -E "^Server|^Hostname" /etc/zabbix/zabbix_agentd.conf
Агент 2 (zabbix-agent2, порт 10052)
bash
Copy
apt install -y zabbix-agent2

cat > /etc/zabbix/zabbix_agent2.conf << 'AGENT'
Server=192.168.101.146
ServerActive=192.168.101.146
Hostname=Agent2-Host
ListenPort=10052
ListenIP=0.0.0.0
AGENT

systemctl enable --now zabbix-agent2
ss -tlnp | grep 10052
zabbix_get -s 192.168.101.146 -p 10052 -k agent.ping
Скриншот Configuration > Hosts
img/screenshot_hosts.png
Table
Хост	Интерфейс	Availability
Agent2-Host	192.168.101.146:10052	ZBX Available
Test Mashine	192.168.101.146:10050	ZBX Available
Zabbix server	127.0.0.1:10050	ZBX Available
Скриншот лога агента
img/screenshot_agent_log.png
bash
Copy
tail -15 /var/log/zabbix/zabbix_agentd.log
Скриншот Latest Data
img/screenshot_latest_data.png
Задание 3*. Windows Agent
(По желанию)
Сводка
Table
Хост	IP	Порт	Статус
Zabbix server	127.0.0.1	10050	Available
Test Mashine	192.168.101.146	10050	Available
Agent2-Host	192.168.101.146	10052	Available
