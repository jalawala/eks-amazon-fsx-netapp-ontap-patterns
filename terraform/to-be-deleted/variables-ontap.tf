# Copyright 2023 (c) NetApp, Inc.
# SPDX-License-Identifier: Apache-2.0

variable "helm_config" {
  description = "NetApp Trident Helm chart configuration"
  type        = any
  default     = {}
}

variable "manage_via_gitops" {
  description = "Determines if the add-on should be managed via GitOps"
  type        = bool
  default     = false
}