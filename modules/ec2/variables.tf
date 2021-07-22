variable "AMIS" {
    type = map(string)
    description = "AMI IDs for CentOS 7 in different regions"
    default = {
        us-east-1 = "ami-00e87074e52e6c9f9"
        us-east-2 = "ami-00f8e2c955f7ffa9b"
        us-west-1 = "ami-08d2d8b00f270d03b"
        us-west-2 = "ami-08d2d8b00f270d03b"
    }
}

variable "INSTANCE_TYPE" {
    default = "t2.micro"
}

variable "KEY_NAME" {
    type = string
}

variable "PUBLIC_SUBNETS" {
    type = list
}

variable "VPC_ID" {
    type = string
}

