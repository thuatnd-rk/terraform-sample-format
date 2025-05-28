ec2_instance_config = {
  instance_type             = "m6a.xlarge"
  monitoring                = true
  associate_public_ip_address = false
  root_block_device         = [
    {
      encrypted   = false
      volume_type = "gp3"
      throughput  = 200
      volume_size = 150
    },
  ]
  tags = {}
}
