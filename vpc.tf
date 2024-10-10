resource "aws_vpc" "csye6225_Swamy_Dev" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "VPC Cloud Project"
 }
}
