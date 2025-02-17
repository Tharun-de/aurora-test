output "aurora_cluster_endpoint" {
  value = module.aurora.aurora_cluster.endpoint
}
output "aurora_cluster_read_endpoint" {
  value = module.aurora.aurora_cluster.reader_endpoint
}
