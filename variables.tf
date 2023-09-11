
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

variable "team_contact" {
  default = "#pet-devops"
}

variable "team_name" {
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

variable "sa_account_kind" {
  type        = string
  default     = "BlobStorage"
  description = "Defines the Kind of account. Valid options are Storage, StorageV2 and BlobStorage. Changing this forces a new resource to be created. Defaults to BlobStorage."

  validation {
    condition     = can(regex("^(Storage|StorageV2|BlobStorage)$", var.sa_account_kind))
    error_message = "Invalid input, options: \"Storage\", \"StorageV2\", \"BlobStorage\"."
  }
}

variable "sa_account_tier" {
  type        = string
  default     = "Standard"
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium. Changing this forces a new resource to be created. Defaults to Standard."

  validation {
    condition     = can(regex("^(Standard|Premium)$", var.sa_account_tier))
    error_message = "Invalid input, options: \"Standard\", \"Premium\"."
  }
}

variable "sa_account_replication_type" {
  type        = string
  default     = "GRS"
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS. Defaults to RAGRS."

  validation {
    condition     = can(regex("^(LRS|GRS|RAGRS|ZRS)$", var.sa_account_replication_type))
    error_message = "Invalid input, options: \"LRS\", \"GRS\", \"RAGRS\", \"ZRS\"."
  }
}

variable "subscription" {}
