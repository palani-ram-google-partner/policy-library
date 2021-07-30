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

package templates.gcp.GCPIAMRestrictComboRolesConstraintV1

import data.validator.test_utils as test_utils

import data.test.fixtures.iam_deny_combo_role.assets as fixture_assets
import data.test.fixtures.iam_deny_combo_role.constraints as fixture_constraints

# Find all violations on our test cases
find_violations[violation] {
	asset := fixture_assets[_]
	constraint := fixture_constraints

	issues := deny with input.asset as asset
		 with input.constraint as constraint

	total_issues := count(issues)

	violation := issues[_]
}

# Confirm total violations count
test_violations_count {
	count(find_violations) == 1
}

# Confim no violations with no resources
test_no_resources {
	found_violations := find_violations with fixture_assets as []
	count(found_violations) = 0
}
