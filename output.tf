# Show the public IP of the newly created loadbalancer
output "load_balancer_dns_name" {
  value = aws_lb.frontend-app.dns_name
}
