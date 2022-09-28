output "ingress_namespace" {
  value = helm_release.lb-ingress.metadata[0].namespace
}
output "ingress_name" {
  value = helm_release.lb-ingress.metadata[0].name
}