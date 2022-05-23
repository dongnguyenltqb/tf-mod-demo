// AWS IAM Instace profile
module "instance_profile" {
  // Allow instance get scret value from AWS secret manager service
  source              = "../terraform-modules/iam-instance-profile"
  profile_name        = "testInstanceProfile"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  custom_policy_documents = [
    jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect : "Allow"
          Action = [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ],
          Resource : [
            "*"
          ]
        }
      ]
    }),
    // Allow ssm agent on instance to connect/process request 
    // from AWS System Manager Service
    jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ]
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "s3:GetEncryptionConfiguration"
          ]
          Resource = "*"
        }
      ]
    })
  ]
}
