module "abc" {
    source = "./Ec2"
    ami_id = "ami-09694bfab577e90b0"
    instance_type = "t2.micro"
    subnet_id = module.xyz.subnet_id
    sg_id = [module.def.sec_id]
  
  }

  module "def" {
    source = "./security_group"
    sg = "sggroup"
    some_custom_vpc = module.abc1.ec2_vpc_id
    
  }

  module "xyz" {
    source = "./subnet"
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-2a"
    some_custom_vpc = module.abc1.ec2_vpc_id
    cidr_block1 = "10.0.0.0/24"
    availability_zones = "us-east-2b"
  }


  module "abc1" {
    source = "./vpc"
    cidr_block = "10.0.0.0/16"
  }

  module "demoigw" {
    source = "./internet_gateway"
    some_custom_vpc = module.abc1.ec2_vpc_id
    
  }

  module "demoroute" {
    source = "./route_table"
    some_custom_vpc = module.abc1.ec2_vpc_id
    igw = module.demoigw.igw-id
    subnet1_id = module.xyz.subnet_id
    subnet2_id = module.xyz.subnet_id2
    
  }

  module "loadbalancer" {
    source = "./load_balancer"
    sg_id = module.def.sec_id
    some_public_subnet = module.xyz.subnet_id
    public_subnet2 = module.xyz.subnet_id2
    lb_port = 80
    lb_protocol = "HTTP"
    # instance_port = 80
    # instance_protocol = "http"
    vpc_id = module.abc1.ec2_vpc_id
    target_id = module.abc.ec2_id

  }

  module "demo-asg" {
    source = "./asg"
    name = "demo1"
    ami_id = "ami-09694bfab577e90b0"
    instance_type = "t2.micro"
    availability_zone = "us-east-2a"
    desired_capacity = 1
    max = 2
    min = 1
    tg_arn = module.loadbalancer.ec2_instance
    sg_id = module.def.sec_id
    sub_id = module.xyz.subnet_id
  }