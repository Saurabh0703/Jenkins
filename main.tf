data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "jenkins-sg" {
  name        = "Allow web traffic"
  description = "Allowing port 8080"

  dynamic "ingress" {
    for_each = var.ingressports
    content {
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = var.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }

  tags = {
    "Name"      = "Jenkins-sg"
    "Terraform" = "true"
  }
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role" "ssm_role" {
  name               = "ssm-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t4g.medium"
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  key_name               = "demo"
  user_data              = file("user_data.sh")

  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    "Name"      = var.tag_name
    "Environment" = var.tag_environment
    "Project" = var.tag_project
    "Owner" = var.tag_owner
    
  }
}

