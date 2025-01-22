provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

resource "aws_instance" "web_server" {
  ami                     = "ami-04b4f1a9cf54c11d0"  # Amazon Linux 2 AMI
  instance_type           = "t3.micro"  # Updated to a compatible instance type for EBS optimization
  key_name                = "Project"  # The name of your key pair
  subnet_id               = "subnet-028111a6722578889"
  vpc_security_group_ids  = ["sg-079b7d8accf6c1422"]
  ebs_optimized           = true  # Ensure EBS optimization is enabled

  # Enable detailed monitoring
  monitoring = true

  # Associate IAM role for enhanced security and access management
  iam_instance_profile = aws_iam_instance_profile.web_server_profile.name

  # Enable Metadata Service Version 2
  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  # Encrypted root block device
  root_block_device {
    volume_size = 8  # Adjust size as needed
    volume_type = "gp2"
    encrypted   = true
  }

  tags = {
    Name = "WebServer"
  }
}

# IAM role for the instance
resource "aws_iam_role" "web_server_role" {
  name               = "web_server_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Attach managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "web_server_policy_attachment" {
  role       = aws_iam_role.web_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM instance profile
resource "aws_iam_instance_profile" "web_server_profile" {
  name = "web_server_profile"
  role = aws_iam_role.web_server_role.name
}
