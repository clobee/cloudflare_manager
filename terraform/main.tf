# Configure the Cloudflare provider
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0" # Specify a stable version range
    }
  }

  cloud {
  }
}

#####################################
#####################################
# MODULES (managed content)
module "zone_id_1a2b3c4d" {
  source = "./modules/1a2b3c4d"
}
