resource "aws_launch_template" "lt" {
  image_id      = "ami-0f5ee92e2d63afc18"
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups             = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(<<EOF
#!/bin/bash
set -e

yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker

usermod -aG docker ec2-user
sleep 10

docker rm -f backend-app || true
docker pull muhammed5793/backend-app:latest

docker run -d \
  --name backend-app \
  -p 5000:5000 \
  --restart always \
  muhammed5793/backend-app:latest
EOF
  )
}


resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 5
  min_size         = 1
  vpc_zone_identifier = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]
}
