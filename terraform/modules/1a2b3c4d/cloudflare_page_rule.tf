resource "cloudflare_page_rule" "terraform_managed_resource_4a2c751c082206404353b6c2bd3ffca3" {
  priority = 1
  status   = "disabled"
  target   = "www.totalonion.com/*"
  zone_id  = "1a2b3c4d"
  actions {
    cache_level = "cache_everything"
  }
}
