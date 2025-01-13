packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}


variable "openai_api_key" {
  type    = string
}

variable "docker_image" {
  type    = string
  default = "python:3.12"
}

source "docker" "python" {
  image  = var.docker_image
  commit = true
}

build {
  name = "imm-infra-openai-conpdf"
  sources = [
    "source.docker.python"
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
    inline = [
      "echo This is docker image - ${var.docker_image}.",
      "mkdir /apps/",
    ]
  }

  provisioner "file" {
    source      = "requirements.txt"
    destination = "/apps/requirements.txt"
  }

  provisioner "file" {
    source      = "openai-internal-kb.py"
    destination = "/apps/openai-internal-kb.py"
  }

  provisioner "file" {
    source      = "Salt.pdf"
    destination = "/apps/Salt.pdf"
  }

  provisioner "shell" {
    inline = [
      "pip install --no-cache-dir --requirement  /apps/requirements.txt",
      "export OPENAI_API_KEY=${var.openai_api_key}",
      "python /apps/openai-internal-kb.py"
    ]
  }
}

