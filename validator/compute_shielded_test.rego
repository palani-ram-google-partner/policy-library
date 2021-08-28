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

package templates.gcp.GCPComputeShieldedConstraintV1

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

# Importing the test data
import data.test.fixtures.compute_shielded.assets.compute.instance_no_violation as fixture_compute_instance_no_violation
import data.test.fixtures.compute_shielded.assets.compute.instance_violation as fixture_compute_instance_violation
import data.test.fixtures.compute_shielded.assets.compute.no_instances as fixture_compute_no_instance

# Importing the test constraint
import data.test.fixtures.compute_shielded.constraints as fixture_constraints

template_name := "GCPComputeShieldedConstraintV1"

#1. No instances at all - need to fix the data.json
test_shielded_compute_no_instances {
	expected_resource_names := {"//dns.googleapis.com/projects/186783260185/managedZones/correct"}
	test_utils.check_test_violations_count(fixture_compute_no_instance, [fixture_constraints], template_name, 0)
}

#2. One instance with correct key
test_shielded_compute_instance_no_violations {
	expected_resource_names := {"//compute.googleapis.com/projects/prj-dev-palani-ram/zones/us-central1-f/instances/pals-jumphost"}
	test_utils.check_test_violations_count(fixture_compute_instance_no_violation, [fixture_constraints], template_name, 0)
	test_utils.check_test_violations_resources(fixture_compute_instance_violation, [fixture_constraints], template_name, expected_resource_names)
	test_utils.check_test_violations_signature(fixture_compute_instance_violation, [fixture_constraints], template_name)
}

#3. One instance without correct key
test_shielded_compute_instance_violations {
	expected_resource_names := {"//compute.googleapis.com/projects/prj-dev-palani-ram/zones/us-central1-f/instances/pals-jumphost"}
	test_utils.check_test_violations_count(fixture_compute_instance_violation, [fixture_constraints], template_name, 1)
	test_utils.check_test_violations_resources(fixture_compute_instance_violation, [fixture_constraints], template_name, expected_resource_names)
	test_utils.check_test_violations_signature(fixture_compute_instance_violation, [fixture_constraints], template_name)
}
