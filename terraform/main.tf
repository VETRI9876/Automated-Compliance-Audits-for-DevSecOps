provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

resource "aws_instance" "web_server" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "Project"  # The name of your key pair
  subnet_id     = "subnet-028111a6722578889"
  security_groups = ["sg-079b7d8accf6c1422"]
  vpc_security_group_ids = ["sg-079b7d8accf6c1422"]

  tags = {
    Name = "WebServer"
  }
}
