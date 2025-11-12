variable "primary_region" {
  default = "eu-north-1" # your chosen region  :)
}

variable "backup_region" {
  default = "eu-west-1" # your chosen region :)
}

# Domain is optional; we leave it empty for now ;)
variable "domain_name" {
  default = ""
}
