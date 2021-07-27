variable "AWS_KEY_PAIR_NAME" {
  type    = string
  default = "sgilz-key-pair"
}

variable "AWS_REGION" {
  type    = string
  default = "us-west-1"
}

variable "AWS_INSTANCE_TYPE" {
  type    = string
  default = "t2.micro"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags used for launching resources on the training AWS account"
  default = {
    responsible = "santiago.gilz"
    project     = "ramp-up-devops"
  }
}

variable "existing_resources" {
  type        = map(string)
  description = "Existing resource IDs"
  default = {
    #subnets
    public_subnet_0_id  = "subnet-0088df5de3a4fe490"
    public_subnet_1_id  = "subnet-055c41fce697f9cca"
    private_subnet_0_id = "subnet-0d74b59773148d704"
    private_subnet_1_id = "subnet-038fa9d9a69d6561e"
    #vpc
    vpc_id = "vpc-0d2831659ef89870c"
  }
}
