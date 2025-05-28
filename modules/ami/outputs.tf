output "ubuntu_ami_id" {
  description = "The ID of the latest Ubuntu AMI"
  value       = data.aws_ami.ubuntu.id
}