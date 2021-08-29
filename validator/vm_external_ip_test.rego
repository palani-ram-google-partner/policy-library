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

package templates.gcp.GCPComputeExternalIpAccessConstraintV2

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

# Importing the test data
import data.test.fixtures.vm_external_ip.assets.compute.instance_no_violation as fixture_compute_instance_no_violation
import data.test.fixtures.vm_external_ip.assets.compute.instance_violation as fixture_compute_instance_violation
import data.test.fixtures.vm_external_ip.assets.compute.no_instances as fixture_compute_no_instance

#import data.test.fixtures.vm_external_ip.assets as fixture_instances
import data.test.fixtures.vm_external_ip.constraints as fixture_constraints

template_name := "GCPComputeExternalIpAccessConstraintV2"

#1. No instances at all
test_vm_external_ip_compute_no_instances {
	expected_resource_names := {"//dns.googleapis.com/projects/186783260185/managedZones/correct"}
	test_utils.check_test_violations_count(fixture_compute_no_instance, [fixture_constraints], template_name, 0)
}

#2. One instance without public ip
test_vm_external_ip_compute_instance_no_violations {
	expected_resource_names := {"//compute.googleapis.com/projects/prj-dev-palani-ram/zones/us-central1-f/instances/pals-jumphost"}
	test_utils.check_test_violations_count(fixture_compute_instance_no_violation, [fixture_constraints], template_name, 0)
}

#3. One instance with public ip
test_vm_external_ip_compute_instance_violations {
	expected_resource_names := {"//compute.googleapis.com/projects/prj-dev-palani-ram/zones/us-central1-f/instances/pals-jumphost"}
	test_utils.check_test_violations_count(fixture_compute_instance_violation, [fixture_constraints], template_name, 1)
}
