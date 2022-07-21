# ================================== Required =====================================

variable "application_name" {
  description = "This value is added to any log in Kibana as a tag for filtering"
  type        = string
}

variable "functionbeat_version" {
  description = "Funtionbeat version to deploy"
  type        = string
}

variable "lambda_config" {
  description = "Minimal required configuration for Functionbeat lambda"
  type = object({
    name = string
    vpc_config = object({
      vpc_id             = string
      subnet_ids         = list(string)
      security_group_ids = list(string)
    })
    output_elasticsearch = any
  })
  default = {
    name = "my-kibana-exporter"

    vpc_config = {
      vpc_id             = "vpc-b03cebc8 "
      subnet_ids         = ["subnet-1d3d2347 "]
      security_group_ids = ["sg-029c1f70"]
    }

    output_elasticsearch = {
      hosts : ["https://vpc-functionbeat-poc-w5r452kvp2s2cizqsu5rvvf5si.us-east-1.es.amazonaws.com"]
      protocol : "https"
      username : "bbtest123"
      password : "GObb2022!!"
    }
  }
}

# ================================= Extra Lambda ==================================

variable "lambda_reserved_concurrent_execution" {
  description = "ReservedConcurrentExecutions for the Lambda"
  type        = number
  default     = 5
}

variable "lambda_memory_size" {
  description = "Memory limit for the Lambda"
  type        = number
  default     = 128
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda"
  type        = number
  default     = 3
}

variable "lambda_description" {
  description = "Description added to the Lambda"
  type        = string
  default     = "Lambda function to ship cloudwatch logs to Kibana"
}

variable "lambda_write_arn_to_ssm" {
  description = "Will write the actual Functionbeat Lambda ARN to SSM"
  type        = bool
  default     = true
}

# ============================== Extra Functionbeat ===============================

variable "fb_extra_configuration" {
  description = "All valid Functionbeat configuration passed as valid HCL object. For configuration options head over to Functionbeat documentation."
  type        = any
  default     = {}
}

variable "fb_extra_tags" {
  description = "The tags of the shipper are included in their own field with each transaction published"
  type        = list(string)
  default     = []
}

variable "fb_log_level" {
  description = "Loglevel for Lambda"
  type        = string
  default     = "info"
}

# ================================ Extra Terraform ================================

variable "loggroup_name" {
  description = "Name of the Cloudwatch log group to be added as trigger for the function"
  type        = string
  default     = null
}

variable "loggroup_filter_pattern" {
  description = "Filter on the Cloudwatch log group to trigger the function only in case of matches"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to add to the actual AWS resources"
  type        = map(any)
  default     = {}
}
