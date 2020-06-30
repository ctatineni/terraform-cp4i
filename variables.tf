variable "helper" {
  type = map(string)
  default = {
    username       = "sysadmin"
    password       = "Passw0rd!"
  }
}

variable "helper_public_ip" {
  type = string
}

variable "key" {
  type = string
}

variable "ssh_private_key" {
  type = string
}