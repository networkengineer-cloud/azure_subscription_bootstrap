variable "billing_account_name" {
  type        = string
  description = "Azure billing account name. To get run the following command: `az billing account list --query '[].name' -o tsv`"
}

variable "billing_profile_name" {
  type        = string
  description = "Azure billing profile name. To get run the following command: `az billing profile list --account-name $(az billing account list --query '[].name' -o tsv) --query '[].name' -o tsv`"
}

variable "invoice_section_name" {
  type        = string
  description = "Azure invoice section name. To get run the following command: `az billing invoice section list --account-name $(az billing account list --query '[].name' -o tsv) --profile-name $(az billing profile list --account-name $(az billing account list --query '[].name' -o tsv) --query '[].name' -o tsv) --query '[].name' -o tsv`"
}

variable "subscription_name" {
  type        = string
  description = "Value to use for the subscription name. If not provided, a random pet name will be used."
  default     = null
}