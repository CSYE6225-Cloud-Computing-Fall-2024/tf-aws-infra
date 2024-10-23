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

    # Log to a custom file for validation
    LOGFILE="/var/log/userdata.log"

    echo "Starting user_data script..." >> $LOGFILE

    # Write environment variables to /etc/environment
    echo "DB_ENDPOINT=${aws_db_instance.csye6225_rds.endpoint}" >> /etc/environment
    echo "DB_URL=${var.jdbc_prefix}://${aws_db_instance.csye6225_rds.endpoint}/${var.db_name}" >> /etc/environment
    echo "DB_USERNAME=${var.db_user}" >> /etc/environment
    echo "DB_PASSWORD=${var.db_pass}" >> /etc/environment
    echo "DB_NAME=${var.db_name}" >> /etc/environment

    # Validate if environment variables were written to /etc/environment
    if grep -q "DB_URL=" /etc/environment && grep -q "DB_USERNAME=" /etc/environment; then
      echo "Environment variables written successfully." >> $LOGFILE
    else
      echo "Error: Environment variables not written correctly." >> $LOGFILE
    fi

    # Starting the Spring Boot application
    echo "Starting Spring Boot application..." >> $LOGFILE

    # Check if the service is running after the instance is up
    sudo systemctl status springbootapp >> $LOGFILE 2>&1
  EOF
}
