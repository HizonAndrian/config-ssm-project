resource "aws_ssm_document" "stop_instance" {
  name            = "stop-instance-automation"
  document_type   = "Automation"
  document_format = "YAML"

  content = <<DOC
schemaVersion: '0.3'
description: Stops EC2 instance due to unencrypted volume.
assumeRole: "{{ AutomationAssumeRole }}"

parameters:
  VolumeIds:
    type: StringList
    description: EBS volume IDs that are unencrypted
  AutomationAssumeRole:
    type: String
    description: Role ARN for automation to assume

mainSteps:
  - name: getInstanceFromVolume
    action: aws:executeAwsApi
    inputs:
      Service: ec2
      Api: DescribeVolumes
      VolumeIds: "{{ VolumeIds }}"
    outputs:
      - Name: InstanceIds
        Selector: "$.Volumes[0].Attachments[0].InstanceId"
        Type: String
  
  - name: stopInstance
    action: aws:changeInstanceState
    inputs:
      InstanceIds: 
      - "{{ getInstanceFromVolume.InstanceIds }}"
      DesiredState: stopped
DOC
}