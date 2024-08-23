# Get the default vpc of the AWS account
data "aws_vpc" "default" {
  default = true
}

# Get the subnet ids associated to the VPC
data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.default.id
}
