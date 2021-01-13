variable "tags" {
  type        = map(string)
  description = "common tags to add to the ressources"
  default     = {}
}

variable "external_id" {
  default = ""

  description = <<EOF
  https://app.datadoghq.com/account/settings#integrations/amazon_web_services
EOF

}

variable "custom_policy" {
  default = ""

  description = <<EOF
  https://docs.datadoghq.com/integrations/amazon_web_services/
EOF

}
