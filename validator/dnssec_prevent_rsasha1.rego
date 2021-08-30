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

package templates.gcp.GCPDNSSECPreventRSASHA1ConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	asset := input.asset
	asset.asset_type == "dns.googleapis.com/ManagedZone"

	dnssecConfig := asset.resource.data.dnssecConfig

	keySpec := dnssecConfig.defaultKeySpecs[_]

	keySpec.algorithm == "RSASHA1"

	check_key_type(params, keySpec)

	message := sprintf("%v: DNSSEC has weak RSASHA1 algorithm enabled", [asset.name])
	metadata := {"resource": asset.name}
}

check_key_type(params, keySpec) {
	lib.has_field(params, "keyType")
	keySpec.keyType == params.keyType
}

check_key_type(params, keySpec) {
	not lib.has_field(params, "keyType")
}
