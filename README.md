# AWS Config + SSM Auto-Remediation (EC2 EBS Encryption)
 AWS Config + SSM Auto-Remediation Mini Project


# Overview
  This project demonstrates how to use AWS Config and AWS Systems Manager (SSM) to automatically remediate non-compliant EC2 instances that do not have EBS encryption enabled. The solution uses AWS Config rules to detect non-compliance and triggers SSM automation documents to encrypt the EBS volumes of the affected instances.


# 📐 Architecture
- ✅ Automatic compliance monitoring for EBS encryption
- 🔄 Auto-remediation of non-compliant EC2 instances (stop action)
- 🔐 Secure OIDC authentication (multi-workspace support)
- 📝 Infrastructure as Code with Terraform
- 🚀 Extensible to other AWS Config rules

# Key Features


# 🔑 OIDC Authentication Setup
- This Project uses Terraform Cloud OIDC for authentication instead of long-lived IAM credentials




# 📊 Example Use Case
1. Launch an EC2 instance with an unencrypted EBS volume.
2. AWS Config marks it Non-Compliant.
3. SSM Automation runs:
    - Instance is stopped automatically
    - Prevents running workloads in a non-compliant state
4. The resource is flagged for manual remediation.


# 🔮 Possible Improvements
✅ Add more config rules. <br>
✅ Implement a notification system to alert when remediation occurs. <br>
✅ Automate remediation process.


# 👤 Author
 **Mark Andrian Hizon Pogi** — DevOps/Cloud Enthusiast <br>
[ 🔗 LinkedIn Profile ](https://www.linkedin.com/in/mark-andrian-hizon-9a215722a/) <br>
[ 🏅 Credly Profile   ](https://www.credly.com/users/mark-andrian-hizon.9ae74f49)

















fall back; When ec2 is stopped, and re deployed again, manual trigger is needed.