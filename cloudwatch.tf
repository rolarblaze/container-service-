resource "aws_cloudwatch_log_group" "ecs_log" {
  name              = "/ecs/lb-app"
  retention_in_days = 7
}