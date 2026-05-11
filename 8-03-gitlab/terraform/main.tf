terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.99"
    }
  }
  required_version = ">= 1.3.0"
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  zone                     = var.yc_zone
}

resource "yandex_vpc_network" "gitlab-network" {
  name = "gitlab-network"
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "gitlab-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "nat_route_table" {
  name       = "gitlab-nat-routes"
  network_id = yandex_vpc_network.gitlab-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

resource "yandex_vpc_subnet" "gitlab-subnet" {
  name           = "gitlab-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.gitlab-network.id
  v4_cidr_blocks = ["192.168.100.0/24"]
  route_table_id = yandex_vpc_route_table.nat_route_table.id
}

resource "yandex_compute_instance" "gitlab" {
  name        = "gitlab-server"
  description = "GitLab CE Server"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores         = 4
    memory        = 8
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 50
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.gitlab-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file(var.ssh_public_key_path)}"
  }

  labels = {
    role = "gitlab"
  }
}

resource "yandex_compute_instance" "gitlab-runner" {
  name        = "gitlab-runner"
  description = "GitLab Runner with Docker"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.gitlab-subnet.id
    nat       = false
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file(var.ssh_public_key_path)}"
  }

  labels = {
    role = "gitlab-runner"
  }

  depends_on = [yandex_compute_instance.gitlab]
}

resource "yandex_compute_instance" "sonarqube" {
  name        = "sonarqube-server"
  description = "SonarQube Community"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 25
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.gitlab-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file(var.ssh_public_key_path)}"
  }

  labels = {
    role = "sonarqube"
  }
}
