# configur Provider
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
# # AMI filter for ami id 
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
# aws ec2 describe-images --owners amazon --image-ids ami-0b18ca1a93b538109 (AMI-ID) 
  owners = ["099720109477"] # Canonical
}

# configure vpc
resource "aws_vpc" "Test-vpc" {
  cidr_block = "10.0.0.0/16"
}


# configure subnet
resource "aws_subnet" "Test-subnet" {
  vpc_id            = "${aws_vpc.Test-vpc.id}"
  cidr_block        = "10.0.10.0/24"
}

# resource block configures a security group to permit ssh and rdp
resource "aws_security_group" "Test_sg"{
  name = "My SG"
  description = "Allows ssh and RDP"
  vpc_id = "${aws_vpc.Test-vpc.id}"
  ingress = [
    {
      description = "Allows ssh"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = true
    },
    {
      description = "Allows rdp"
      from_port = 3389
      to_port = 3389
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = true
    }
  ]

  egress = [
    {
      description = "egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = true

}
  ]
}


# configure network interface
resource "aws_network_interface" "Test-nic1" {
  subnet_id   = "${aws_subnet.Test-subnet.id}"
  private_ips = ["10.0.10.101"]
  security_groups = ["${aws_security_group.Test_sg.id}"]
  attachment {
    instance = "${aws_instance.Ansible-Controller.id}"
    device_index = 1
  }
}

# resource block to configure key-pair for linux instance (must have already created the key pair)
resource "aws_key_pair" "Test_key"{
  key_name = "My-Key"
  public_key = var.key
}

#configure instance must include subnet_id otherwise default subnet is used
resource "aws_instance" "Ansible-Controller" {
  ami           =  data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  #network_interface {
  #  network_interface_id = "${aws_network_interface.Test-nic1.id}"
  #  device_index         = 0
    
  #}
  vpc_security_group_ids = ["${aws_security_group.Test_sg.id}"]
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.Test-subnet.id}"
  key_name = aws_key_pair.Test_key.key_name
  
  
   
  tags = {
    "name" = "ansible Controller"

  }
}
