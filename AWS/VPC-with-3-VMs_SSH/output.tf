output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value = aws_instance.web.*.public_ip
}

output "vpc_name" {
    description = "Name of the VPC"
    value = aws_vpc.main.tags.Name
    sensitive = true
}

output "vpc_id" {
    description = "ID of the VPC"
    value = aws_vpc.main.id
}   

output "vpc_cidr_block" {
    description = "CIDR block of the VPC"
    value = aws_vpc.main.cidr_block
    sensitive = true 
}   

output "vpc_dns_hostnames" {
    description = "DNS hostnames of the VPC"
    value = aws_vpc.main.enable_dns_hostnames
}      

output "name_of_subnet" {
    description = "Name of the subnet"
    value = aws_subnet.public.tags.Name
}

output "id_of_subnet" {
    description = "ID of the subnet"
    value = aws_subnet.public.id
}   

output "cidr_block_of_subnet" {
    description = "CIDR block of the subnet"
    value = aws_subnet.public.cidr_block
    sensitive = true 
}

output "availability_zone_of_subnet" {
    description = "Availability zone of the subnet"
    value = aws_subnet.public.availability_zone
}

output "public_ip_on_launch_of_subnet" {
    description = "Public IP on launch of the subnet"
    value = aws_subnet.public.map_public_ip_on_launch
}

output "name_of_security_group" {
    description = "Name of the security group"
    value = aws_security_group.allow_some.tags.Name
    #value = aws_security_group.allow_ssh.tags.Name
}

output "id_of_security_group" {
    description = "ID of the security group"
    value = aws_security_group.allow_some.id
    #value = aws_security_group.allow_ssh.id
}

output "description_of_security_group" {
    description = "Description of the security group"
    #value = aws_security_group.allow_ssh.description
    value = aws_security_group.allow_some.description
}

output "vpc_id_of_security_group" {
    description = "VPC ID of the security group"
    #value = aws_security_group.allow_ssh.vpc_id
    value = aws_security_group.allow_some.vpc_id
}

output "ingress_of_security_group" {
    description = "Ingress of the security group"
    #value = aws_security_group.allow_ssh.ingress
    value = aws_security_group.allow_some.ingress
}

output "egress_of_security_group" {
    description = "Egress of the security group"
    #value = aws_security_group.allow_ssh.egress
    value = aws_security_group.allow_some.egress
}

output "name_of_instance" {
    description = "Name of the instance"
    value = aws_instance.web.*.tags.Name
}

output "id_of_instance" {
    description = "ID of the instance"
    value = aws_instance.web.*.id
}

output "ami_of_instance" {
    description = "AMI of the instance"
    value = aws_instance.web.*.ami
}

output "instance_type_of_instance" {
    description = "Instance type of the instance"
    value = aws_instance.web.*.instance_type
}

output "ssh_keypair" {
    value = tls_private_key.key.private_key_pem
    sensitive = true
}

output "key_name" {
    value = aws_key_pair.key_pair.key_name
}
