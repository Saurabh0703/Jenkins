variable "cidr_blocks"{
  default = ["0.0.0.0/0"]
}
variable "ingressports" {
  type    = list(number)
  default = [8080]
}
variable "tag_name" {
  description = "Name tag value for the resource"
  type        = string
  default     = "Jenkins"
}
variable "tag_environment" {
  description = "Environment tag value for the resource"
  type        = string
  default     = "uat"
}
variable "tag_project" {
  description = "project tag value for the resource"
  type        = string
  default     = "vr-core"
}
variable "tag_owner" {
  description = "owner tag value for the resource"
  type        = string
  default     = "tothenew.com"
}
