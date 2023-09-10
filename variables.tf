
variable "common_tags" {
  type = map(string)
}

variable "product" {
  default = "et-pet"
}
variable "env" {}
variable "tenant_id" {}

variable "location" {
  default = "UK South"
}

variable team_contact {
  default = "#pet-devops"
}

variable team_name {
  default = "et-pet"
}

variable "destroy_me" {
  type        = string
  description = "Here be dragons! In the future if this is set to Yes then automation will delete this resource on a schedule. Please set to No unless you know what you are doing"
  default     = "No"
}

variable "managed_identity_object_id" {
  default = ""
}

variable "jenkins_AAD_objectId" {
  description = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

variable "db_postgresql_user" {
  default = "employment_tribunals_postgresql_user"
}

variable "db_storage_mb" {
  default = "5120"
}

variable "subscription" {}
