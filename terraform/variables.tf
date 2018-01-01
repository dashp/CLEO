variable "access_key" { 
  description = "AWS access key"
}

variable "secret_key" { 
  description = "AWS secert access key"
}

variable "region"     { 
  description = "AWS region"
  default     = "us-east-1" 
}
variable "name" { default = "cleo-wordpress" }
variable "ami"  { default = "ami-c93872b3" }

variable "wordpress_instance_type" {default = "t2.micro"}

variable "key_name" { default = "cleo-wordpress" }