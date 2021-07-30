#
# Copyright 2019 Google LLC
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

package templates.gcp.GCPPostgreSQLDisConnectionsConstraintV1

import data.validator.gcp.lib as lib

# A violation is generated only when the rule body evaluates to true.
deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "sqladmin.googleapis.com/Instance"
	instance := asset.resource.data

	# get instance settings
	settings := lib.get_default(instance, "settings", {})

	# check if name and value are as expected
	settings.databaseFlags[i].name == "log_disconnections"
	settings.databaseFlags[i].value != "on"

	message := sprintf("%v Ensure that the log_disconnections database flag for Cloud SQL PostgreSQL instance is set to ON ", [asset.name])
	ancestry_path = lib.get_default(asset, "ancestry_path", "")
	metadata := {"ancestry_path": ancestry_path}
}
