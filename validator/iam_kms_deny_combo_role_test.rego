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

import data.validator.test_utils as test_utils
import data.validator.gcp.lib as lib

import data.test.fixtures.iam_kms_deny_combo_role.assets as fixture_assets
import data.test.fixtures.iam_kms_deny_combo_role.constraints as fixture_constraints

template_name := "GCPIAMKMSRestrictComboRolesConstraintV1"

test_iam_kms_deny_combo_role_violations {
	test_utils.check_test_violations_count(fixture_assets, [fixture_constraints], template_name, 1)
}

test_iam_kms_deny_combo_role_no_violations {
    expected_resource_names := {"//cloudkms.googleapis.com/projects/prj-dev-palani-ram/locations/global/keyRings/kms-keyring-dev/cryptoKeys/kms-key-dev"}
	not test_utils.check_test_violations_resources(fixture_assets, [fixture_constraints], template_name, expected_resource_names)
}