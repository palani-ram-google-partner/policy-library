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

package templates.gcp.GCPIAMKMSRestrictComboRolesConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset

	asset.asset_type == "cloudkms.googleapis.com/CryptoKey"
	check_asset_type(asset, params)

	# get all the users who has cloud admin role
	admin_bindings := asset.iam_policy.bindings[_]
	admin_role := admin_bindings.role
	check_admin_role(admin_role, params)
	admin_members := admin_bindings.members

	# get all the users who has combo roles
	kms_bindings := asset.iam_policy.bindings[_]
	kms_role := kms_bindings.role
	combo_roles := params.combo_roles
	matches_found = {r | r := kms_role; glob.match(combo_roles[_], [], r)}
	count(matches_found) > 0

	# find if any of the admin user is also a combo role user
	conflict_members := cast_set(kms_bindings.members)
	conflict_found = {r | r := admin_members[_]; glob.match(conflict_members[_], [","], r)}
	count(conflict_found) > 0

	# get conflicting users from user and group types
	param_members := params.members
	deny_members = {r | r := conflict_members[_]; glob.match(param_members[_], [":"], r)}
	count(deny_members) > 0

	message := sprintf("%v Ensure that Separation of duties is enforced while assigning KMS related roles to users %v", [asset.name, deny_members])
	ancestry_path = lib.get_default(asset, "ancestry_path", "")
	metadata := {"ancestry_path": ancestry_path}
}

###########################
# Rule Utilities
###########################

check_asset_type(asset, params) {
	lib.has_field(params, "assetType")
	params.assetType == asset.asset_type
}

check_asset_type(asset, params) {
	lib.has_field(params, "assetType") == false
}

check_admin_role(admin_role, params) {
	lib.has_field(params, "role")
	admin_role == params.role
}

check_admin_role(admin_role, params) {
	lib.has_field(params, "role") == false
}
