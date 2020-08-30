# Raspberry Pi Terraform Bootstrap Provisioner (Tested with Raspbian Stretch).
# This is a run-once bootstrap Terraform provisioner for a Raspberry Pi.  
# Provisioners by default run only at resource creation, additional runs without cleanup may introduce problems.
# https://www.terraform.io/docs/provisioners/index.html

resource "null_resource" "raspberry_pi_bootstrap" {
  connection {
    type = "ssh"
    user = "${var.username}"
    password = "${var.password}"
    host = "${var.raspberrypi_ip}"
  }

  provisioner "file" {
    source      = "worker_init.sh"
    destination = "/tmp/worker_init.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      # SET HOSTNAME
      "sudo hostnamectl set-hostname ${var.new_hostname}",
      "echo '127.0.1.1 ${var.new_hostname}' | sudo tee -a /etc/hosts",
     
      # DATE TIME CONFIG
      "sudo timedatectl set-timezone ${var.timezone}",
      "sudo timedatectl set-ntp true",

      # SYSTEM AND PACKAGE UPDATES
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "sudo apt-get dist-upgrade -y",
      "sudo apt --fix-broken install -y",

      # INSTALL PROMETHEUS NODE EXPORTER
      # This step optional, comment out this section if not desired
      "sudo apt-get install prometheus-node-exporter -y",
      "sudo systemctl enable prometheus-node-exporter.service",
            
      "chmod u+x /tmp/worker_init.sh",
      "/tmp/worker_init.sh",
      "sudo ${var.worker_join_command}",
      
      "sudo shutdown -r +0"
    ]
  }
}
