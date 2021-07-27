variable "AMI_ID" {
  type        = string
  description = "AMI ID to use into the AG (Autoscaling group)"
}

variable "AWS_INSTANCE_TYPE" {
  type        = string
  description = "The Amazon AWS instance type to used into the AG"
}

variable "AWS_KEY_PAIR_NAME" {
  type = string
}

variable "ag_capacities" {
  type        = map(number)
  description = "A map with the desired sizes for the AG"
  default = {
    "min_size"                  = 1
    "max_size"                  = 3
    "desired_capacity"          = 2
    "wait_for_capacity_timeout" = 0
  }
}

variable "target_app" {
  type        = string
  description = "Whether to provison api or ui app. Allowed: ui, api"
}

variable "api_lb_ip" {
  type        = string
  description = "IP of the api LB in case its the ui which will be launched"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags to use into the AG and its instances"
}

variable "security_groups" {
  type        = list(string)
  description = "A list with seg-group IDs to add the AG instances to"
}

variable "vpc_zone_identifier" {
  type        = list(string)
  description = "A list with the needed subnets for the AG"
}
