// OpenVPN Access Server
module "vpn" {
  source    = "../terraform-modules/vpn-access-server"
  vpc_id    = "vpc-3"
  subnet_id = "subnet-054a"
  key_name  = "tfkey"
  username  = "dong"
  password  = "helloworld123"
}

// AWS Secret Manager
module "secret" {
  source      = "../terraform-modules/secret-manager"
  secret_name = "tfmodtest"
  secret_value = {
    Name     = "DongNguyen"
    Age      = "24"
    Username = "dongnguyenltqb"
  }
}

// AWS IAM Instace profile
module "instance_profile" {
  depends_on = [
    module.secret
  ]
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
            module.secret.secret_id
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
