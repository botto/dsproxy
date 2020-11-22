locals {
  user_data = templatefile("${path.module}/files/bootstrap.sh.tpl", {
    ssh_keys         = var.ssh_keys
    user             = "admin"
    wg_conf          = file(var.wireguard_conf_path)
    sniproxy_conf    = file(var.sniproxy_conf_path)
    sniproxy_service = file("${path.module}/files/sniproxy.service")
  })
}

data "aws_eip" "main_ip" {
  id = var.eip_id
}

// Get the latest Debian Buster AMI
data "aws_ami" "debian-buster" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-10-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"] # Debian
}

// Create an EBS block device for data
resource "aws_ebs_volume" "main" {
  availability_zone = aws_subnet.main.availability_zone
  size = 10
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.main.id
  instance_id = aws_instance.gateway.id
}

// Create the EC2 instance
resource "aws_instance" "gateway" {
  ami           = data.aws_ami.debian-buster.id
  instance_type = "t3a.nano"

  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.gateway.id]
  user_data_base64       = base64gzip(local.user_data)

  tags = {
    "Name" = var.namespace
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.gateway.id
  allocation_id = data.aws_eip.main_ip.id
}

output "ip" {
  value = data.aws_eip.main_ip.public_ip
}
