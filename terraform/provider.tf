# Primary AWS provider (Stockholm)
provider "aws" {
  region = var.primary_region
}

# Backup AWS provider (Ireland)
provider "aws" {
  alias  = "backup"
  region = var.backup_region
}
