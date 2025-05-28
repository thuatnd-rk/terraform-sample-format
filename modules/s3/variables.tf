variable "s3_bucket_config" {
  description = "Configuration for the S3 bucket module"
  type = object({
    bucket                       = string
    control_object_ownership     = bool
    force_destroy                = bool
    versioning                   = object({
      enabled = bool
    })
    tags                         = map(string)
  })
}
