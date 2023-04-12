resource "aws_security_group" "bastion-wordpress" {
  name        = "bastion"
  description = "this is using for securitygroup"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description = "this is inbound rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["43.225.22.31/32"]
  }
  #   ingress {
  #     description = "this is inbound rule"
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "all"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastion-stage"
  }
}
resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = var.type
  subnet_id              = aws_subnet.publicsubnet[1].id
  vpc_security_group_ids = [aws_security_group.bastion-wordpress.id]
  key_name               = "path"
  # iam_instance_profile = aws_iam_instance_profile.cicd-iam.name
  #   user_data              = <<EOF
  #              #!/bin/bash
  #              wget -O /etc/yum.repos.d/jenkins.repo \
  #     https://pkg.jenkins.io/redhat-stable/jenkins.repo
  #  rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  #  yum update -y
  #  amazon-linux-extras install java-openjdk11
  #  yum install jenkins -y
  #  systemctl start jenkins
  #  systemctl enable jenkins
  #        EOF
  tags = {
    Name = "stage-bastion"
  }
}
# tags = {
#   Name = "pk-bastion-sg"
# }