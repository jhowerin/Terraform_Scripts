variable "region" {
 type        = string
 description = "Default region to use"
 default     = "us-east-1"
 sensitive   = true
}

variable "vpc_cidr_block" {
 type        = string
 description = "CIDR block for the VPC"
 default     = "172.16.0.0/16"
    sensitive   = true
}

variable "vpc_name" {
 type        = string
 description = "Name of the VPC"
 default     = "JakesVPC"
 sensitive   = true
}

variable "public_subnet_cidr_block" {
 type        = string
 description = "CIDR block for the public subnet"
 default     = "172.16.1.0/24"
    sensitive   = true
}

variable "ami" {
    type        = string
    description = "AMI to use for the instances"
    default     = "ami-026b57f3c383c2eec"
    sensitive   = false 
}

variable "route_table_cidr_block" {
    type        = string
    description = "CIDR block for the route table"
    default     = "0.0.0.0/0"
    sensitive   = true
}

variable "instance_count" {
    type        = number
    description = "Number of instances to create"
    default     = 3
    sensitive   = false 
}   

variable "type_of_instance" {
    type        = string
    description = "Type of instances to create"
    default     = "t2.micro"
    sensitive   = false 
}

variable key_name {
    type = string
    default = "TEST"
}
# Language: terraform
# Path: Terraform/AWS/BasicVPCwVariables/variables.tf