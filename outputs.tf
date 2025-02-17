output "aurora_cluster_endpoint" {
  value = aws_rds_cluster.aurora_serverless_cluster.endpoint
}

output "aurora_cluster_read_endpoint" {
  value = aws_rds_cluster.aurora_serverless_cluster.reader_endpoint
}
