variable "cidr_blocks"{
  default = ["0.0.0.0/0"]
}
variable "ingressports" {
  type    = list(number)
  default = [8080]
}
variable "tag_name" {
  description = "Name tag value for the instance"
  type        = string
  default     = "Jenkins"
}
variable "tag_environment" {
  description = "Name tag value for the instance"
  type        = string
  default     = "uat"
}
variable "tag_project" {
  description = "Name tag value for the instance"
  type        = string
  default     = "vr-core"
}
variable "tag_owner" {
  description = "Name tag value for the instance"
  type        = string
  default     = "saurabh.joshi@tothenew.com"
}