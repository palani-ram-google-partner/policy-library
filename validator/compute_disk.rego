#
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package templates.gcp.GCPComputeDiskConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	asset := input.asset
	asset.asset_type == "compute.googleapis.com/Disk"
	disk_config := asset.resource.data
	disk_config.labels.critical_vm == "true"
	key := lib.get_default(disk_config, "diskEncryptionKey", {})
	count(key) == 0

	message := sprintf("%v Ensure VM disks for critical VMs are encrypted with Customer Supplied Encryption Keys.", [asset.name])

	ancestry_path = lib.get_default(asset, "ancestry_path", "")
	metadata := {"ancestry_path": ancestry_path}
}
