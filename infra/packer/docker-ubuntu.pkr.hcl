packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "docker_image" {
  type    = string
  default = "ubuntu:jammy"
}


source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

build {
  name = "imm-infra-openai-conpdf"
  sources = [
    "source.docker.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  provisioner "shell" {
      inline = ["echo This is docker image - ${var.docker_image}."]

    }
}
