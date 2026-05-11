# ID облака Yandex Cloud
yc_cloud_id  = "b1go4u9l02430g02r6q2"

# ID каталога (рабочего пространства)
yc_folder_id = "b1g39jpe6a94k90us6kl"

# Зона доступности (Москва)
yc_zone      = "ru-central1-a"

# Образ Ubuntu 22.04 LTS (свежий, от 8 мая 2026)
ubuntu_image_id = "fd83vkt13re8v8cdapql"

# Пользователь для подключения к VM
# Ubuntu 22.04 в Yandex Cloud создаёт пользователя 'ubuntu' через cloud-init
vm_user             = "ubuntu"

# Путь к SSH публичному ключу (ED25519 - современный алгоритм)
ssh_public_key_path = "~/.ssh/id_ed25519.pub"
