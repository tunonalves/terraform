virginia_cidr = "10.10.0.0/16"
# public_subnet  = "10.10.0.0/24"
# private_subnet = "10.10.1.0/24"

subnets = ["10.10.0.0/24", "10.10.1.0/24"]


tags = {
  "env"         = "dev"
  "owner"       = "FTA"
  "cloud"       = "AWS"
  "IAC"         = "Terraform"
  "IAC_Version" = "1.10.5"
  "project"     = "Dev&Dev"
  "region"      = "virginia"
}

sg_ingress_cidr = "0.0.0.0/0"
