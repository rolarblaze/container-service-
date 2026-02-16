resource "aws_db_instance" "default" {
  allocated_storage      = 30
  identifier             = "mydbinstance"
  db_name                = "mydb"
  engine                 = "postgres"
  engine_version         = "14.15"
  instance_class         = "db.t3.micro"
  username               = "postgres"
  password               = random_password.rds_password.result
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1b.id, aws_subnet.private_subnet_1c.id]
}

resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!@#$%^&*()-_=+[]{}|;:,.<>?"
}
