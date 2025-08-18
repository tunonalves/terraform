resource "aws_s3_bucket" "proveedores" {
  count  = 3
  bucket = "proveedores${random_string.sufijo[count.index].id}"
  tags = {
    Owner       = "Federico"
    Environment = "Dev"
    Office      = "proveedores"
  }
}

resource "random_string" "sufijo" {
  count   = 3
  length  = 8
  special = false
  upper   = false
  numeric = false
}
