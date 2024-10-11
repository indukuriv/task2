terraform { 
 required_providers {
 aws = {
 source = "hashicorp/aws"
 version = "~> 4.16"
 }
 }
 required_version = ">=1.2.0" # which means any version equal & above 1.1 like 1.2, 1.3 etc
}

provider "aws" {
  region     = "us-east-2"
}