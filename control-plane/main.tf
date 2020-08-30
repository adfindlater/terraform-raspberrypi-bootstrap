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
    source      = "control_plane_init.sh"
    destination = "/tmp/control_plane_init.sh"
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

      "sudo apt-get install sshpass -y",
      # INSTALL PROMETHEUS NODE EXPORTER
      # This step optional, comment out this section if not desired
      "sudo apt-get install prometheus-node-exporter -y",
      "sudo systemctl enable prometheus-node-exporter.service",
            
      # COPY KUBERNETES PREP SCRIPT
      "chmod u+x /tmp/control_plane_init.sh",
      "/tmp/control_plane_init.sh",
    ]
  }
  provisioner "local-exec" {
    command = "/usr/bin/sshpass -p '${var.password}' scp -o StrictHostKeyChecking=no ubuntu@${var.raspberrypi_ip}:/tmp/worker_join_command.txt worker_join_command.txt"
  }
  provisioner "local-exec" {
    command = "/usr/bin/sshpass -p '${var.password}' scp -o StrictHostKeyChecking=no ubuntu@${var.raspberrypi_ip}:/home/ubuntu/.kube/config kube_config"
  }
  # provisioner "remote-exec" {
  #   inline = ["sudo shutdown -r +0"]
  # }
}
