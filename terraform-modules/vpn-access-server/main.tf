// Tag Name
resource "random_string" "name" {
  length  = 8
  special = false
}
locals {
  common_tags = {
    Name = format("OpenVPNAccessServer-%s", random_string.name.result)
  }
}

// VPN access server
resource "aws_instance" "this" {
  depends_on = [
    aws_security_group.this
  ]
  ami = data.aws_ami.ubuntu.id
  // we can automation setup 
  // https://openvpn.net/vpn-server-resources/migrating-an-access-server-installation/
  user_data                   = <<-EOF
              admin_user=${var.username}
              admin_pw=${var.password}
              EOF
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.this.id]
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  tags                        = local.common_tags
}
// Static IP for VPN Server
resource "aws_eip" "this" {
  vpc      = true
  instance = aws_instance.this.id
  depends_on = [
    aws_instance.this
  ]
  tags = local.common_tags
}
// Security group for VPN access server
resource "aws_security_group" "this" {
  name        = format("OpenVPNAccesServerSecurityGroup-%s", random_string.name.result)
  description = "Security group for VPN access server"
  vpc_id      = var.vpc_id
  tags_all    = local.common_tags
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 943
    to_port     = 943
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "udp"
    from_port   = 1194
    to_port     = 1194
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
