output "email" {
  description = "The email address of the custom service account."
  value       = google_service_account.service_account.email
}
output "id" {
  value = google_service_account.service_account.id
}
