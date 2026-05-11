# ============================================
# GitLab Server
# ============================================
output "gitlab_external_ip" {
  description = "External IP of GitLab server"
  value       = yandex_compute_instance.gitlab.network_interface.0.nat_ip_address
}

output "gitlab_internal_ip" {
  description = "Internal IP of GitLab server"
  value       = yandex_compute_instance.gitlab.network_interface.0.ip_address
}

# ============================================
# GitLab Runner
# ============================================
output "gitlab_runner_external_ip" {
  description = "External IP of GitLab Runner"
  value       = yandex_compute_instance.gitlab-runner.network_interface.0.nat_ip_address
}

output "gitlab_runner_internal_ip" {
  description = "Internal IP of GitLab Runner"
  value       = yandex_compute_instance.gitlab-runner.network_interface.0.ip_address
}

# ============================================
# SonarQube Server
# ============================================
output "sonarqube_external_ip" {
  description = "External IP of SonarQube server"
  value       = yandex_compute_instance.sonarqube.network_interface.0.nat_ip_address
}

output "sonarqube_internal_ip" {
  description = "Internal IP of SonarQube server"
  value       = yandex_compute_instance.sonarqube.network_interface.0.ip_address
}

# ============================================
# Summary
# ============================================
output "urls" {
  description = "Access URLs for all services"
  value = {
    gitlab    = "http://${yandex_compute_instance.gitlab.network_interface.0.nat_ip_address}"
    sonarqube = "http://${yandex_compute_instance.sonarqube.network_interface.0.nat_ip_address}:9000"
  }
}
