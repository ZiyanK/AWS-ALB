# Define the Application Load Balancer
resource "aws_lb" "test" {
  name               = "test-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_sg.id}"]
  subnets            = data.aws_subnet_ids.subnets.ids

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "test_listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_target_group" "test" {
  name     = "test-lb-target-group-tf"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group_attachment" "instance1_attachment" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance2_attachment" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.instance_2.id
  port             = 80
}

# EC2 instance
resource "aws_instance" "instance_1" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = var.ec2_instance_type
  security_groups = ["${aws_security_group.instance_sg.name}"]
  tags = {
    Name = "Instance-1"
  }
  user_data = file("${path.module}/ec2-script.sh")
}

# EC2 instance
resource "aws_instance" "instance_2" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = var.ec2_instance_type
  security_groups = ["${aws_security_group.instance_sg.name}"]
  tags = {
    Name = "Instance-2"
  }
  user_data = file("${path.module}/ec2-script.sh")
}