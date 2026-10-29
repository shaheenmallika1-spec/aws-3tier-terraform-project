resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-high-cpu"
  alarm_description   = "Average EC2 CPU utilization exceeds 70% for 10 minutes."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  period              = 300
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ec2/${var.project_name}-${var.environment}/app"
  retention_in_days = 14

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Tier        = "app"
  }
}