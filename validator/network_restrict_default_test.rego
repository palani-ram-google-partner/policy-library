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

package templates.gcp.GCPNetworkRestrictDefaultV1

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

import data.test.fixtures.network_restrict_default.assets as fixture_assets
import data.test.fixtures.network_restrict_default.constraints as fixture_constraints

template_name := "GCPNetworkRestrictDefaultV1"

test_private_google_access_disabled {
	expected_resource_names := {"//compute.googleapis.com/projects/fake-project/global/networks/default"}
	test_utils.check_test_violations_count(fixture_assets, [fixture_constraints], template_name, 1)
	test_utils.check_test_violations_resources(fixture_assets, [fixture_constraints], template_name, expected_resource_names)
}

test_private_google_access_enabled {
	expected_resource_names := {"//compute.googleapis.com/projects/fake-project/global/networks/test-network"}
	not test_utils.check_test_violations_resources(fixture_assets, [fixture_constraints], template_name, expected_resource_names)
}
