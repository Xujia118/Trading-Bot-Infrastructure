resource "aws_security_group" "ec2_sg" {
  name = "ec2_security_group"
  description = "Allow SSH and Internet connection"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow HTTP outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }
}

resource "aws_instance" "stocks_trading_robot_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [ aws_security_group.ec2_sg.name ]
  key_name = "final_project"

  tags = {
    Name = "Stocks Trading Robot Instance"
  }

  user_data = local.user_data_script // Script is below
}

# Output the instance ID
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.stocks_trading_robot_instance.id
}

# Output the public IP address
output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.stocks_trading_robot_instance.public_ip
}

locals {
  user_data_script = <<-EOF
  #!/bin/bash
  # Update ubuntu instance
  sudo apt update
  sudo apt upgrade -y

  # Install Python and pip
  sudo apt install -y python3
  sudo apt install -y python3-pip

  # Install Docker
  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  # Install the latest version of Docker 
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  
  # Get git repo
  cd /home/ubuntu
  sudo git clone https://github.com/Xujia118/Trading-Bot.git
  sudo git config --global --add safe.directory /home/ubuntu/Trading-Bot

  # Install Python dependencies
  # cd ~/Trading-Bot

  # Build docker image
  # sudo docker build -t us_stocks_robot .
  # sudo docker run --name us_stocks_robot us_stocks_robot

  EOF
}