resource "aws_default_vpc" "default" {}

resource "aws_security_group" "gateway" {
  name_prefix = var.namespace
  vpc_id      = aws_default_vpc.default.id

  # Allow any incoming connection to SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow any outgoing connection
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a private subnet for the container cluster
resource "aws_subnet" "main" {
  availability_zone       = var.subnet_az
  cidr_block              = cidrsubnet(aws_default_vpc.default.cidr_block, 8, 178)
  vpc_id                  = aws_default_vpc.default.id
  map_public_ip_on_launch = true

  tags = {
    Name = var.namespace
  }
}