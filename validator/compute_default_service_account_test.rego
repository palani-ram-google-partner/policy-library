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

package templates.gcp.GCPComputeDefaultServiceAccountConstraintV1

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

# Importing the test data
import data.test.fixtures.compute_default_service_account.assets.compute.instance_no_violation as fixture_compute_instance_no_violation
import data.test.fixtures.compute_default_service_account.assets.compute.instance_violation as fixture_compute_instance_violation
import data.test.fixtures.compute_default_service_account.assets.compute.no_instances as fixture_compute_no_instance

# Importing the test constraint
import data.test.fixtures.compute_default_service_account.constraints.check_account_only as fixture_constraints
import data.test.fixtures.compute_default_service_account.constraints.check_full_scope as fixture_constraints_full_scope

template_name := "GCPComputeDefaultServiceAccountConstraintV1"

#### Testing for GCE instances

#1. No instances at all
test_default_service_account_compute_no_instances {
	expected_resource_names := {"//dns.googleapis.com/projects/186783260185/managedZones/correct"}
	test_utils.check_test_violations_count(fixture_compute_no_instance, [fixture_constraints], template_name, 0)
}

#2. One instance without default service account
test_default_service_account_compute_instance_no_violations {
	expected_resource_names := {"//compute.googleapis.com/projects/prj-dev-palani-ram/zones/us-central1-f/instances/pals-jumphost"}
	test_utils.check_test_violations_count(fixture_compute_instance_no_violation, [fixture_constraints], template_name, 0)
	test_utils.check_test_violations_resources(fixture_compute_instance_violation, [fixture_constraints], template_name, expected_resource_names)
	test_utils.check_test_violations_signature(fixture_compute_instance_violation, [fixture_constraints], template_name)
}

#3. One instance with default service account
test_default_service_account_compute_instance_violations {
	expected_resource_names := {"//compute.googleapis.com/projects/prj-dev-palani-ram/zones/us-central1-f/instances/pals-jumphost"}
	test_utils.check_test_violations_count(fixture_compute_instance_violation, [fixture_constraints_full_scope], template_name, 1)
	test_utils.check_test_violations_resources(fixture_compute_instance_violation, [fixture_constraints_full_scope], template_name, expected_resource_names)
	test_utils.check_test_violations_signature(fixture_compute_instance_violation, [fixture_constraints_full_scope], template_name)
}

#find_violations[violation] {
#	asset := data.assets[_]
#	constraint := data.test_constraints[_]
#	issues := deny with input.asset as asset with input.constraint as constraint
#	total_issues := count(issues)
#	violation := issues[_]
#}
#
#violations_check_account_only[violation] {
#	constraints := [fixture_constraints.checkaccountonly]
#	found_violations := find_violations with data.assets as fixture_assets
#		 with data.test_constraints as constraints
#
#	violation := found_violations[_]
#}
#
#test_violations_check_account_only {
#	found_violations := violations_check_account_only
#
#	count(found_violations) == 2
#}
#
#violations_check_full_scope[violation] {
#	constraints := [fixture_constraints.checkfullscope]
#	found_violations := find_violations with data.assets as fixture_assets
#		 with data.test_constraints as constraints
#
#	violation := found_violations[_]
#}
#
#test_violations_check_full_scope {
#	found_violations := violations_check_full_scope
#
#	count(found_violations) == 1
#}
