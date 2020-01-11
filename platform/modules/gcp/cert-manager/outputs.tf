output "service_account_auth_file" {
  value = google_storage_bucket_object.account_auth.content
}

output "service_account" {
  value = module.dns_service_account.email
}
