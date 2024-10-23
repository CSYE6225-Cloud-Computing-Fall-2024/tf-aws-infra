# PostgreSQL Parameter Group for custom DB configurations
# Defining the Postgres Version
resource "aws_db_parameter_group" "rds_pg" {
  name   = "csye6225-db-parameter-group"
  family = "postgres16"

  #parameter {
  #name  = "max_connections"
  #value = "150"
  #}

  tags = {
    Name = "csye6225 PostgreSQL Parameter Group"
  }
}

# Create RDS instance
resource "aws_db_instance" "csye6225_rds" {
  identifier             = "csye6225" # DB instance identifier
  engine                 = "postgres" # Change to "postgres" or "mariadb" if needed
  engine_version         = "16.3"
  instance_class         = "db.t3.micro" # Cheapest instance
  allocated_storage      = 20
  db_name                = "webapp"
  username               = "postgres"
  password               = "Northeastern2024"
  parameter_group_name   = aws_db_parameter_group.rds_pg.name
  vpc_security_group_ids = [aws_security_group.db_security_group.id] # Attach DB security group
  skip_final_snapshot    = true
  publicly_accessible    = false # No public access
  multi_az               = false # Disable Multi-AZ
  availability_zone      = element(data.aws_availability_zones.available.names, 0)
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name # Use private subnet group

  tags = {
    Name = "csye6225 RDS Instance"
  }
}

# Create DB Subnet Group for RDS instances in private subnets
# what id * in Subnet_ids
resource "aws_db_subnet_group" "db_subnet" {
  name       = "csye6225-db-subnet-group"
  subnet_ids = aws_subnet.private_subnets[0].id

  tags = {
    Name = "csye6225 DB Subnet Group"
  }
}
