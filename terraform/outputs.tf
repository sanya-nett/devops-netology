//data "aws_caller_identity" "caller_data" {}
//
//data "aws_region" "region_data" {}
//
//output "aws_account_id" {
//  value = data.aws_caller_identity.caller_data.account_id
//}
//
//output "aws_caller_user" {
//  value = data.aws_caller_identity.caller_data.user_id
//}
//
//output "aws_region_name" {
//  value = data.aws_region.region_data.name
//}
//
//output "ec2_private_ip" {
//  value = aws_instance.web.private_ip
//}
//
//output "ec2_public_ip" {
//  value = aws_instance.web.public_ip
//}
//
//output "ec2_subnet_id" {
//  value = aws_instance.web.subnet_id
//}
