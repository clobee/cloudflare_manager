variable "cloudflare_email" {
  type        = string
  description = "Cloudflare account email"
}

variable "cloudflare_api_key" {
  type        = string
  description = "Cloudflare API key"
  sensitive   = true # This marks the variable as sensitive in logs
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}
