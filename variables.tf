variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}
variable "vpc_id" {
  type = string
  default = "vpc-0b4cba11eaa653fba"
}
variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "MIAX-POC1"
}
variable "subnets" {
  description = "A list of subnets."
  type        = list(string)
  default     = [
    "subnet-0648165c6cb6f23e5",
    "subnet-0c6d09930ac8d6be6",
    "subnet-09576884b6e657534"
  ]
}

variable "clusteringress_cidrs" {
  description = "List of CIDR blocks that are permitted for cluster egress traffic."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}