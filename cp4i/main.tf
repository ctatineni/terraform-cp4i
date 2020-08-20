resource "null_resource" "add_catalogs" {
  connection {
    host        = var.helper_public_ip
    user        = var.helper["username"]
    password    = var.helper["password"]
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = "${path.module}/scripts"
    destination = "/tmp/cp4i_scripts"
  }

  provisioner "remote-exec" {
    inline = [
      "export KUBECONFIG=~/installer/auth/kubeconfig",
      "sudo chmod u+x /tmp/cp4i_scripts/*.sh",
      "/tmp/cp4i_scripts/installcp4i.sh \"${var.key}\"",
    ] 
  }
}

