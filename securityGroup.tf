resource "aws_security_group" "app_security_group" {
  vpc_id = aws_vpc.csye6225_Swamy_Dev.id
  name   = "application_security_group"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Application Traffic"
    from_port   = var.application_port # Using the variable for the application port
    to_port     = var.application_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "App Security Group"
  }
}


# Security group for RDS instance
resource "aws_security_group" "db_security_group" {
  vpc_id = aws_vpc.csye6225_Swamy_Dev.id
  name   = "database_security_group"

  ingress {
    description     = "Allow PostgresSQL access from application security group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_security_group.id] # Only allow from app SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB Security Group"
  }
}
