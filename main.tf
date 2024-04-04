/*
 The terraform {} block contains Terraform settings, including the required providers Terraform will use to provision infrastructure.
 Terraform installs providers from the Terraform Registry by default.
 In this example configuration, the aws provider's source is defined as hashicorp/aws,
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16"
    }
  }

  required_version = ">= 1.2.0"
}


/*
 The provider block configures the specified provider, in this case aws.
 You can use multiple provider blocks in your Terraform configuration to manage resources from different providers.
*/
provider "aws" {
  region  = "eu-north-1"
  profile = "default"
}


/*
 Use resource blocks to define components of your infrastructure.
 A resource might be a physical or virtual component such as an EC2 instance.
 A resource block declares a resource of a given type ("aws_instance") with a given local name ("app_server").
 The name is used to refer to this resource from elsewhere in the same Terraform module, but has no significance outside that module's scope.
 The resource type and name together serve as an identifier for a given resource and so must be unique within a module.

 For full description of this resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
*/
resource "aws_instance" "app_server" {
  ami           = "ami-0914547665e6a707c"
  instance_type = var.env == "prod" ? "t3.nano" : "t3.micro"
  vpc_security_group_ids = [aws_security_group.sg_web.id]
  key_name = ".pem File (Key Pair)"



  tags = {
    Name = "Amiran_tf-${var.env}"
    Env = var.env
    Terraform = "true"
    project = "hbs"
  }
}

resource "aws_security_group" "sg_web" {
  name = "${var.resource_alias}-${var.env}-sg"

  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Env         = var.env
    Terraform   = true
  }
}
