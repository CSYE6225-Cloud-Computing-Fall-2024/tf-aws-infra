resource "aws_launch_template" "csye6225_launch_template" {
  name_prefix   = "csye6225_asg"
  image_id      = var.ami_id # Replace with your custom AMI ID
  instance_type = "t2.micro"
  key_name      = var.key_name # Replace with your actual key name


  iam_instance_profile {
    name = aws_iam_instance_profile.app_instance_profile.name # Replace with the IAM role attached to the current EC2 instance
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_security_group.id] # Replace with the correct security group resource
  }

  user_data = base64encode(templatefile("${path.module}/user_data.tpl", {
    DB_ENDPOINT                       = aws_db_instance.csye6225_rds.endpoint
    DB_URL                            = "${var.jdbc_prefix}://${aws_db_instance.csye6225_rds.endpoint}/${var.db_name}"
    DB_USERNAME                       = var.db_user
    DB_PASSWORD                       = var.db_pass
    DB_NAME                           = var.db_name
    BANNER                            = var.banner_mode
    APPLICATION_NAME                  = var.application_name
    SHOW_SQL                          = var.show_sql
    NON_CONTEXTUAL_CREATION           = var.non_contextual_creation
    HIBERNATE_DIALECT_POSTGRESDIALECT = var.hibernate_dialect
    HIBERNATE_DDL_AUTO                = var.hibernate_ddl_auto
    AWS_S3_BUCKET_NAME                = aws_s3_bucket.example_bucket.id
    AWS_PROFILE_NAME                  = var.aws_profile_name
    AWS_REGION                        = var.region
    MAX_FILE_SIZE                     = var.max_file_size
    MAX_REQUEST_SIZE                  = var.max_request_size

  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name             = "CSYE6225-EC2"
      Environment      = "Production"
      AutoScalingGroup = "CSYE6225-ASG"
    }
  }
}

resource "aws_autoscaling_group" "csye6225_asg" {
  desired_capacity = 3
  max_size         = 5
  min_size         = 3
  launch_template {
    id      = aws_launch_template.csye6225_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = aws_subnet.public_subnets[*].id
  health_check_type   = "ELB"                            # Set to ELB to enable health checks via ALB
  target_group_arns   = [aws_lb_target_group.app_tg.arn] # Link to the target group

  tag {
    key                 = "Name"
    value               = "CSYE6225-EC2"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }
  tag {
    key                 = "AutoScalingGroup"
    value               = "CSYE6225-ASG"
    propagate_at_launch = true
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "csye6225_high_cpu_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 5 # 5% CPU
  alarm_description   = "Alarm when CPU exceeds 5%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.csye6225_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up_policy.arn]
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "csye6225_scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.csye6225_asg.name
  cooldown               = 60
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "csye6225_low_cpu_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 3 # 3% CPU
  alarm_description   = "Alarm when CPU is below 3%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.csye6225_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down_policy.arn]
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "csye6225_scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.csye6225_asg.name
  cooldown               = 60
}
