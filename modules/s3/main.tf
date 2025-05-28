module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version                      = "4.6.0"
  bucket                       = var.s3_bucket_config.bucket
  control_object_ownership     = var.s3_bucket_config.control_object_ownership
  versioning                   = var.s3_bucket_config.versioning
  force_destroy =         var.s3_bucket_config.force_destroy
  tags                         = var.s3_bucket_config.tags

}
