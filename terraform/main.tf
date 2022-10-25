terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.81.0"
    }
  }
}
provider "yandex" {
  service_account_key_file = file("key.json")
  folder_id                = var.folder_id
  cloud_id                 = var.cloud_id
  zone                     = var.zone
}

data "yandex_compute_image" "ubuntu-image" {
  family = "ubuntu-2204-lts"
}
resource "yandex_compute_instance" "vm-4" {
  name                      = "vm-ubuntu-1"
  allow_stopping_for_update = true
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-image.id
      type     = "network-ssd"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys           = "root:${file("~/.ssh/id_rsa.pub")}"
    #    user-data          = "${file("/Users/roman/PycharmProjects/ansible_project/meta.txt")}"
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = true
  }
}


resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}