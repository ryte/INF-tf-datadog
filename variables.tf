variable "tags" {
  type        = map(string)
  description = "common tags to add to the ressources"
  default     = {}
}

variable "external_id" {
  default = ""

  description = "'AWS External ID' from the [integration settings dialog in Datadog](https://app.datadoghq.com/account/settings#integrations/amazon_web_services)"
}

variable "custom_policy" {
  default = ""

  description = "Provide the Datadog integration with a custom set of permissions to limit or expand data collection (see [docs](https://docs.datadoghq.com/integrations/amazon_web_services/))"

}
