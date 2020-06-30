module "cp4i" {
  source               = "./cp4i"
  helper               = var.helper
  helper_public_ip     = var.helper_public_ip
  ssh_private_key      = var.ssh_private_key
}

