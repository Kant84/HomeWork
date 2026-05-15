     1	# Домашнее задание: Система мониторинга Zabbix
     2	
     3	**Выполнил:** Andrei
     4	
     5	---
     6	
     7	## Задание 1. Установка Zabbix Server с веб-интерфейсом
     8	
     9	### Использованные команды
    10	
    11	```bash
    12	# Установка репозитория Zabbix 7.0 для Debian 13 (Trixie)
    13	wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian13_all.deb
    14	dpkg -i zabbix-release_latest_7.0+debian13_all.deb
    15	apt update
    16	
    17	# Установка Zabbix Server, Frontend, Agent
    18	apt install zabbix-server-pgsql zabbix-frontend-php php8.4-pgsql \
    19	  zabbix-apache-conf zabbix-sql-scripts zabbix-agent
    20	
    21	# Создание базы данных PostgreSQL
    22	su - postgres -c 'psql --command "CREATE USER zabbix WITH PASSWORD '\''123456789'\'';"'
    23	su - postgres -c 'psql --command "CREATE DATABASE zabbix OWNER zabbix;"'
    24	
    25	# Импорт схемы
    26	zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | \
    27	  sudo -u zabbix psql zabbix
    28	
    29	# Настройка пароля в конфиге
    30	sed -i 's/# DBPassword=/DBPassword=123456789/g' /etc/zabbix/zabbix_server.conf
    31	
    32	# Запуск служб
    33	systemctl restart zabbix-server zabbix-agent apache2
    34	systemctl enable zabbix-server zabbix-agent apache2
    35	```
    36	
    37	### Скриншот авторизации в админке
    38	
    39	Вход выполнен с логином `Admin` и паролем `zabbix`. Dashboard после авторизации:
    40	
    41	![Dashboard](screenshot_dashboard.png)
    42	
    43	- Zabbix server version: **7.0.26**
    44	- Zabbix frontend version: **7.0.26**
    45	- Number of hosts: **3**
    46	
    47	---
    48	
    49	## Задание 2. Установка Zabbix Agent на два хоста
    50	
    51	### Использованные команды
    52	
    53	#### Первый агент (zabbix-agent) — установлен с сервером
    54	
    55	```bash
    56	# Проверка статуса
    57	systemctl status zabbix-agent
    58	
    59	# Проверка конфигурации
    60	grep -E "^Server|^ServerActive|^Hostname" /etc/zabbix/zabbix_agentd.conf
    61	# Server=127.0.0.1,192.168.101.146
    62	# ServerActive=127.0.0.1,192.168.101.146
    63	# Hostname=Zabbix server
    64	```
    65	
    66	#### Второй агент (zabbix-agent2) — на порту 10052
    67	
    68	```bash
    69	# Установка
    70	apt install -y zabbix-agent2
    71	
    72	# Настройка агента
    73	cat > /etc/zabbix/zabbix_agent2.conf << 'EOF'
    74	Server=192.168.101.146
    75	ServerActive=192.168.101.146
    76	Hostname=Agent2-Host
    77	ListenPort=10052
    78	ListenIP=0.0.0.0
    79	EOF
    80	
    81	# Запуск
    82	systemctl enable --now zabbix-agent2
    83	
    84	# Проверка порта
    85	ss -tlnp | grep 10052
    86	# LISTEN 0 4096 *:10052 *:* users:(("zabbix_agent2",pid=11169,fd=7))
    87	
    88	# Проверка подключения
    89	zabbix_get -s 192.168.101.146 -p 10052 -k agent.ping
    90	# 1
    91	```
    92	
    93	### Скриншот раздела Configuration > Hosts
    94	
    95	Все 3 хоста в статусе Available (ZBX зелёный):
    96	
    97	![Hosts](screenshot_hosts_green.png)
    98	
    99	| Хост | Интерфейс | Availability |
   100	|------|-----------|-------------|
   101	| Agent2-Host | 192.168.101.146:10052 | **ZBX Available** |
   102	| Test Mashine | 192.168.101.146:10050 | **ZBX Available** |
   103	| Zabbix server | 127.0.0.1:10050 | **ZBX Available** |
   104	
   105	### Скриншот лога zabbix-agent2
   106	
   107	```bash
   108	journalctl -u zabbix-agent2 -n 10 --no-pager
   109	```
   110	
   111	Вывод:
   112	```
   113	Starting Zabbix Agent 2 (7.0.26)
   114	Zabbix Agent2 hostname: [Agent2-Host]
   115	Press Ctrl+C to exit.
   116	```
   117	
   118	Аналогично для первого агента:
   119	
   120	```bash
   121	tail -15 /var/log/zabbix/zabbix_agentd.log
   122	```
   123	
   124	Вывод:
   125	```
   126	Starting Zabbix Agent [Zabbix server]. Zabbix 7.0.26
   127	IPv6 support:          YES
   128	TLS support:           YES
   129	using configuration file: /etc/zabbix/zabbix_agentd.conf
   130	agent #0 started [main process]
   131	agent #1 started [collector]
   132	agent #2 started [listener #1]
   133	...
   134	agent #13 started [active checks #2]
   135	```
   136	
   137	### Скриншот раздела Monitoring > Latest data
   138	
   139	Данные поступают от всех 3-х хостов:
   140	
   141	![Latest Data](screenshot_latest_data.png)
   142	
   143	| Хост | Метрик | Статус |
   144	|------|--------|--------|
   145	| Zabbix server | 139 | ✅ With data |
   146	| Agent2-Host | 68 | ✅ With data |
   147	| Test Mashine | 61 | ✅ With data |
   148	
   149	---
   150	
   151	## Задание 3*. Установка Zabbix Agent на Windows
   152	
   153	(По желанию — пока не выполнено)
   154	
   155	---
   156	
   157	## Сводка проверки
   158	
   159	| Хост | IP | Порт | Availability |
   160	|------|-----|------|-------------|
   161	| Zabbix server | 127.0.0.1 | 10050 | ✅ Available |
   162	| Test Mashine | 192.168.101.146 | 10050 | ✅ Available |
   163	| Agent2-Host | 192.168.101.146 | 10052 | ✅ Available |
   164	
   165	---
   166	
   167	## Структура проекта
   168	
   169	```
   170	hw-02/
   171	├── README.md                     # Этот файл
   172	├── screenshot_dashboard.png      # Dashboard после входа
   173	├── screenshot_hosts.png          # Список хостов (3 шт)
   174	├── screenshot_hosts_green.png    # Все хосты Available
   175	└── screenshot_latest_data.png    # Latest Data всех хостов
   176	```
   177	
