# Security group for the Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow traffic from anywhere"

  ingress {
    description = "allow HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for EC2 instances
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Allow traffic only from the 'alb_sg' security group"

  ingress {
    description     = "Allow traffic from other security group"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}