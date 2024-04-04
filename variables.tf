variable "env" {
  description = "Deployment enviorment"
  type = string
  default = "dev"
}

variable "resource_alias" {
  description = "Your name"
  type        = string
  default     = "=<your-name>"
}
