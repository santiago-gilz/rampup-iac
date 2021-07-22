variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
    default = "us-west-1"
}

variable "common_tags" {
    type = map(string)
    description = "Common tags used for launching resources on the training AWS account"
    default = {
        responsible = "santiago.gilz"
        project = "ramp-up-devops"
    }
}

variable "existing_resources" {
    type = map(string)
    description = "Existing resource IDs"
    default = {
        vpc_id = "vpc-0d2831659ef89870c"
        public_subnet_0_id = "subnet-0088df5de3a4fe490"
        sg_id = "sg-0befdd70e43ce72b3"
    }
}
