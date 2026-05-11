variable "yc_cloud_id" {
  description = "Yandex Cloud ID - идентификатор облака"
  type        = string
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID - идентификатор каталога (рабочего пространства)"
  type        = string
}

variable "yc_zone" {
  description = "Yandex Cloud zone - зона доступности (например, ru-central1-a для Москвы)"
  type        = string
  default     = "ru-central1-a"
}

variable "ubuntu_image_id" {
  description = "Ubuntu 22.04 LTS image ID - ID образа операционной системы"
  type        = string
}

variable "vm_user" {
  description = "VM user name - имя пользователя для SSH-доступа (ubuntu для стандартных образов Ubuntu в Yandex Cloud)"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key - путь к публичному SSH-ключу для авторизации на VM"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
