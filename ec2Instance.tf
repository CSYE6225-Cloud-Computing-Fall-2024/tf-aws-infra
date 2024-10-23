resource "aws_instance" "app_instance" {
  ami                         = var.ami_id        # Using variable for AMI ID
  instance_type               = var.instance_type # Using variable for instance type
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.app_security_group.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.root_volume_size # Using variable for root volume size
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "App EC2 Instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "DB_HOST=${aws_db_instance.csye6225_rds.endpoint}" >> /etc/environment
    echo "DB_USER=${var.db_user}" >> /etc/environment
    echo "DB_PASS=${var.db_pass}" >> /etc/environment
    echo "DB_NAME=${var.db_name}" >> /etc/environment
  EOF
}
