variable "domain-name" {
  type        = string
  description = "The domain name for the application"
  default     = "devroland.cloud"
}

variable "subdomain" {
  type    = string
  default = "containerapp"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tag" {
  type    = string
  default = "latest"
}

variable "container_port" {
  type = number 
  default = 8000
}

variable "health_check_path" {
  type       = string
  description = "The path for the health check of the target group"
  default     = "/health"
}

variable "image" {
  type = string 
  default = "879381241087.dkr.ecr.ap-south-1.amazonaws.com/student-portal"
}