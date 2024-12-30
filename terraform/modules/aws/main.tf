# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ad-db-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "ad-db-subnet"
  }
}

resource "aws_security_group" "ad_sg" {
  name        = "ad-security-group"
  description = "Security group for Active Directory"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Security group for Database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 1433
    to_port         = 1433
    protocol        = "tcp"
    security_groups = [aws_security_group.ad_sg.id]
  }
}

# EC2 Instances
resource "aws_instance" "ad_server" {
  ami           = data.aws_ami.windows_2019.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ad_sg.id]

  root_block_device {
    volume_size = 100
  }

  tags = {
    Name = var.ad_instance_name
  }

  user_data = <<-EOF
              <powershell>
              Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
              </powershell>
              EOF
}

resource "aws_instance" "db_server" {
  ami           = data.aws_ami.windows_2019.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.db_sg.id]

  root_block_device {
    volume_size = 100
  }

  tags = {
    Name = var.db_instance_name
  }
}

# Data source for Windows Server 2019 AMI
data "aws_ami" "windows_2019" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}