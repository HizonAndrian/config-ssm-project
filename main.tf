resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "config_recorder"
  role_arn = aws_iam_role.config-role.arn

  # Resources to be tracked
  recording_group {
    all_supported  = false
    resource_types = ["AWS::EC2::Volume", "AWS::EC2::Instance"]
  }
}

resource "aws_config_delivery_channel" "config_delivery_channel" {
  name           = "deliver_channel"
  s3_bucket_name = aws_s3_bucket.s3_config.bucket
  depends_on     = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_configuration_recorder_status" "start_recorder" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true

  depends_on = [
    aws_config_configuration_recorder.config_recorder,
    aws_config_delivery_channel.config_delivery_channel
  ]
}

resource "aws_config_config_rule" "config_rule" {
  name = "config_rule"

  source {
    # Used a managed AWS Rule
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_remediation_configuration" "config_remediation" {
  config_rule_name = aws_config_config_rule.config_rule.name
  resource_type    = "AWS::EC2::Volume"
  target_type      = "SSM_DOCUMENT"
  target_id        = aws_ssm_document.stop_instance.name

  automatic                  = true
  maximum_automatic_attempts = 2
  retry_attempt_seconds      = 120

  parameter {
    name         = "AutomationAssumeRole"
    static_value = aws_iam_role.ssm_role.arn
  }

  parameter {
    name           = "VolumeIds"
    resource_value = "RESOURCE_ID"
  }
}
