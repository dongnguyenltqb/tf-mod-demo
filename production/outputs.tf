output "instance_profile_arn" {
  value = module.instance_profile.profile_arn
}

output "secret_id" {
  value = module.secret.secret_id
}

output "vpn-access-server-url" {
  value = module.vpn.vpn_access_server_url
}

output "vpn-access-server-security-group-id" {
  value = module.vpn.security_group_id
}
