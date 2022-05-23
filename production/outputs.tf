output "instance_profile_arn" {
  value = module.instance_profile.profile_arn
}

output "secret_id" {
  value = module.secret.secret_id
}
