terraform {
  backend "gcs" {
      bucket = "bucket_backend_tf_sep22"
      prefix = "env/dev"
  }
}