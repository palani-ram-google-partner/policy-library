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

import data.test.fixtures.compute_disk.assets as fixture_instances
import data.test.fixtures.compute_disk.constraints as fixture_constraints

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

template_name := "GCPComputeDiskConstraintV1"

test_compute_disk_violations {
	test_utils.check_test_violations_count(fixture_instances, [fixture_constraints], template_name, 1)
}

test_compute_disk_no_violations {
	expected_resource_names := {"//compute.googleapis.com/disk-1"}
	not test_utils.check_test_violations_resources(fixture_instances, [fixture_constraints], template_name, expected_resource_names)
	test_utils.check_test_violations_signature(fixture_instances, [fixture_constraints], template_name)
}

