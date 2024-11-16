# Fetch Current Account Details
data "aws_caller_identity" "current" {}

# Fetch Existing Private Subnet by Tag
data "aws_subnet" "private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["PaymentGateway-pvt-subnet"] # Replace with the tag of your private subnet
  }
}

# Fetch Existing Security Group by Tag
data "aws_security_group" "private_sg" {
  filter {
    name   = "tag:Name"
    values = ["PaymentGateway-pvt-sg"] # Replace with the tag of your Lambda security group
  }
}



# # Fetch Current Account Details
# data "aws_caller_identity" "current" {}

# # Private Subnet Details
# data "aws_subnet" "private_subnet" {
#   id = "subnet-09cf5642bef559d01" # Replace with the subnet ID of your private subnet
# }

# # Security Group Details
# data "aws_security_group" "lambda_sg" {
#   id = "sg-0b58e12b066d7f00a" # Replace with the security group ID for Lambda
# }
