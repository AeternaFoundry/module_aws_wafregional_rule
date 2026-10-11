variable "wafregional_rules" {
  description = <<EOT
Map of wafregional_rules, attributes below
Required:
    - metric_name
    - name
Optional:
    - region
    - tags
    - tags_all
    - predicate (block):
        - data_id (required)
        - negated (required)
        - type (required)
EOT

  type = map(object({
    metric_name = string
    name        = string
    region      = optional(string)
    tags        = optional(map(string))
    tags_all    = optional(map(string))
    predicate = optional(list(object({
      data_id = string
      negated = bool
      type    = string
    })))
  }))
  validation {
    condition = alltrue([
      for k, v in var.wafregional_rules : (
        v.predicate == null || alltrue([for item in v.predicate : (length(item.data_id) >= 1 && length(item.data_id) <= 128)])
      )
    ])
    error_message = "must be between 1 and 128 characters"
  }
  # Note: 1 additional provider-side validator is enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

