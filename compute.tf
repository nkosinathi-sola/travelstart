 # AWS Security Group
 resource "aws_security_group" "travelstart-sg" {
  name        = "allow_http_access"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.travelstart.id

  ingress {
    description = "ssh from my ip range"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
  tags = {
    "Name" = "Travelstart-sg"
  }
}
data "aws_ami" "amazon_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20220606.1-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["amazon"]
}

# Webserver EC2 Instances
resource "aws_instance" "travelstart-app-server1" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_ami.id
  vpc_security_group_ids = [aws_security_group.travelstart-sg.id]
  subnet_id              = aws_subnet.private-2a.id
  associate_public_ip_address = true
    tags = {
      Name = "travelstart-app-server-1"
    }
  user_data = file("user.tpl")
}
resource "aws_instance" "travelstart-app-server2" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_ami.id
  vpc_security_group_ids = [aws_security_group.travelstart-sg.id]
  subnet_id              = aws_subnet.private-2b.id
  associate_public_ip_address = true
  user_data = file("user.tpl")
      tags = {
      Name = "travelstart-app-server-2"
    }
}
resource "aws_instance" "travelstart-app-server3" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_ami.id
  vpc_security_group_ids = [aws_security_group.travelstart-sg.id]
  subnet_id              = aws_subnet.private-2c.id
  associate_public_ip_address = true
  user_data = file("user.tpl")
      tags = {
      Name = "travelstart-app-server-3"
    }
}

# PostgreSQL DB Instance
resource "aws_instance" "travelstart-postgres-db" {
  ami           = data.aws_ami.amazon_ami.id
  instance_type = "t2.micro"
  user_data = templatefile("postgres.sh", {
    pg_file = templatefile("pg.conf", { allowed_ip = "0.0.0.0/0" }),
  })
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.travelstart-sg.id]
  tags = {
    Name = "PostgreSQL"
  }
}
