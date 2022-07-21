provider "aws" {
  max_retries = 1337
  region      = "eu-central-1"
}
resource "aws_security_group" "functionbeat_securitygroup" {
  name   = "Functionbeat"
  vpc_id = "vpc-b03cebc8 "

  egress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    description = "HTTPS"
    cidr_blocks = ["10.210.0.0/16"]
  }
}

module "functionbeat" {
  source = "../"

  application_name     = "crazy-test-module"
  functionbeat_version = "8.3.2"

  lambda_config = var.lambda_config

  fb_extra_configuration = {
    fields = {
      env = "test",
      foo = "bar"
    }
    setup = {
      "template.settings" = {
        "index.number_of_shards" : 1
      }
      ilm = {
        enabled : true
        rollover_alias : "my-alias"
        pattern : "{now/d}-000001"
        policy_name : "index_curation"
      }
    }
    logging = {
      to_syslog : false
      to_eventlog : false
    }
    processors = [
      {
        add_cloud_metadata : null
      },
      {
        add_fields = {
          fields = {
            id   = "574734885120952459"
            name = "myproject"
          }
          target = "project"
        }
      }
    ]
  }
  fb_extra_tags = ["webserver", "testme"]
}
