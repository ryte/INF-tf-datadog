# INF-tf-datadog

Terraform module for [AWS integration in Datadog](https://docs.datadoghq.com/integrations/amazon_web_services/) to gather data from AWS services and billing.


NOTE: The module will only execute if an `external_id` is given. You receive
these by going to 'Integrations' in Datadog, click 'Configure' on 'Amazon Web
Services' and either click 'Add another account' or 'Generate new ID' for an
existing account.

NOTE: **This can increase the costs on Datadog and AWS heavilly.** Only include AWS services you need to track in Datadog and use [tags](https://help.datadoghq.com/hc/en-us/articles/203764805-How-will-an-AWS-Integration-impact-my-monthly-billing-Can-I-setup-exclusions-using-tags-).

This project is [internal open source](https://en.wikipedia.org/wiki/Inner_source)
and currently maintained by the [INF](https://github.com/orgs/ryte/teams/inf).

## Module Input Variables

-  `custom_policy`
    - __description__: Provide the Datadog integration with a custom set of permissions to limit or expand data collection
    - __type__: `string`
    - __default__: ""

-  `external_id`
    - __description__: "AWS External ID" from the integration settings dialog in Datadog
    - __type__: `string`
    - __default__: ""

- `tags`
    -  __description__: a map of tags which is added to all supporting ressources
    -  __type__: `map`
    -  __default__: {}

## Usage

Add your AWS account in [Datadog](https://app.datadoghq.com/account/settings#integrations/amazon_web_services):

- Insert account ID
- Keep role name to the default (`DatadogAWSIntegrationRole`)
- Copy the `AWS External ID` and supply it to the module as `external_id`
- Add a comma separated list of tags (should at least contain squad and environment)
- Optionally: limit collection to specific tagged hosts
- Select namespace rules you want to collect metrics from


Add following code snippet to your stack
```hcl
module "datadog" {
  source      = "github.com/ryte/INF-tf-datadog.git?ref=v0.2.1"
  tags        = local.common_tags
  external_id = "$yourAWSExternalIDinDatadog"
}
```
or with a custom set of permissions

```hcl
data "aws_iam_policy_document" "custom_policy" {
  statement {
    actions = ["budgets:ViewBudget"]
    resources = ["*"]
  }
}

module "datadog" {
  source        = "github.com/ryte/INF-tf-datadog.git?ref=v0.2.1"
  tags          = local.common_tags
  external_id   = "$yourAWSExternalIDinDatadog"
  custom_policy = data.aws_iam_policy_document.custom_policy.json
}
```

## Outputs
None

## Authors

- [Armin Grodon](https://github.com/x4121)

## Changelog

- 0.2.1 - Add tags to role
- 0.2.0 - Upgrade to terraform v0.12
- 0.1.0 - Initial release.

## License

This software is released under the MIT License (see `LICENSE`).
