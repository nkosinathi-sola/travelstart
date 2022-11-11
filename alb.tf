# load_balancer_target_group
resource "aws_lb_target_group" "frontend-app" {
  name     = "travelstart-application-frontend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.travelstart.id
  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 10
    matcher = 200
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 3
    unhealthy_threshold = 2
  }
}

# attach apps to the load balancer
resource "aws_lb_target_group_attachment" "travelstart-application1" {
  target_group_arn = aws_lb_target_group.frontend-app.arn
  target_id        = aws_instance.travelstart-app-server1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "travelstart-application2" {
  target_group_arn = aws_lb_target_group.frontend-app.arn
  target_id        = aws_instance.travelstart-app-server2.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "travelstart-application3" {
  target_group_arn = aws_lb_target_group.frontend-app.arn
  target_id        = aws_instance.travelstart-app-server3.id
  port             = 80
}

# load balancer listener
resource "aws_lb_listener" "frontend-lb-listener" {
  load_balancer_arn = aws_lb.frontend-app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-app.arn
  }
}

resource "aws_lb" "frontend-app" {
  name               = "frontend-app"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.travelstart-sg.id]
  subnets            = [aws_subnet.private-2a.id, aws_subnet.private-2b.id, aws_subnet.private-2c.id]

  enable_deletion_protection = true

  tags = {
    Environment = "frontend-app"
  }
}
