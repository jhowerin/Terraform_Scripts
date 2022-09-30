# Terraform code to Launch 3 VM's in AWS VPC with SSH, HTTP, and ICMP public access
# AWS Provider
provider "aws" {
  region = var.region
  profile = "default"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}

# Create a security group
resource "aws_security_group" "allow_some" {
  name = "allow_some_protos"
  description = "Allow SSH, HTTP, ICMP inbound traffic"
  vpc_id = aws_vpc.main.id

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "ICMP"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_some_protos"
    }
}

# Create a subnet
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  #cidr_block = "172.16.1.0/24" 
  cidr_block = var.public_subnet_cidr_block 
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Main IGW"
  }
}

# Create a route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create mutliple instances using a count
resource "aws_instance" "web" {
  #count = 3
  count=var.instance_count
  ami = var.ami
  instance_type = var.type_of_instance
  key_name = var.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_some.id}"]
  subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
  tags = {
    # Create a unique name and add the count index
    Name = "web-${count.index+1}"
  }
  # Copies the ssh key file to home dir
    provisioner "file" {
        source      = "./${var.key_name}.pem"
        destination = "/home/ec2-user/${var.key_name}.pem"
        connection {
            type        = "ssh"
            user        = "ec2-user"
            private_key = file("${var.key_name}.pem")
            host        = self.public_ip
        }
    }
    //chmod key 400 on EC2 instance
    provisioner "remote-exec" {
        inline = ["chmod 400 ~/${var.key_name}.pem"]
        connection {
            type        = "ssh"
            user        = "ec2-user"
            private_key = file("${var.key_name}.pem")
            host        = self.public_ip
        }
    }
}

# Exec into the instance and do a yum update
resource "null_resource" "update" {
  count = var.instance_count
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("${var.key_name}.pem")
    # host = flatten(aws_instance.web.*.public_ip)[0]
    host = aws_instance.web.*.public_ip[count.index]
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "echo 'Hello World!'" # This is just to show that the provisioner is working
    ]
  }
}

// Generate the SSH keypair that we’ll use to configure the EC2 instance.
// After that, write the private key to a local file and upload the public key to AWS
resource "tls_private_key" "key" {
    algorithm = "RSA"
}

resource "local_sensitive_file" "private_key" {
    filename          = "TEST.pem"
    content = tls_private_key.key.private_key_pem
}

resource "aws_key_pair" "key_pair" {
    key_name   = "TEST"
    public_key = tls_private_key.key.public_key_openssh
}
