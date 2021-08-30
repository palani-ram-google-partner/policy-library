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

package templates.gcp.GCPDNSSECConstraintV1

import data.test.fixtures.dnssec.assets as fixture_assets
import data.test.fixtures.dnssec.constraints.require_dnssec as fixture_constraints

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

template_name := "GCPDNSSECConstraintV1"

test_dnssec_violations {
	expected_resource_names := {
	"//dns.googleapis.com/projects/186783260185/managedZones/wrong-off",
	"//dns.googleapis.com/projects/186783260185/managedZones/wrong-transfer",
	}
	test_utils.check_test_violations_count(fixture_assets, [fixture_constraints], template_name, 2)
	test_utils.check_test_violations_resources(fixture_assets, [fixture_constraints], template_name, expected_resource_names)
}

