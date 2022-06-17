variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}
variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "Bala-Cluster"
}

variable "clusteringress_cidrs" {
  description = "List of CIDR blocks that are permitted for cluster egress traffic."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}