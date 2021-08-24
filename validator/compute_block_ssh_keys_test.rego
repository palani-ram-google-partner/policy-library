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
package templates.gcp.GCPComputeBlockSSHKeysConstraintV1

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

# Importing the test data
import data.test.fixtures.compute_block_ssh_keys.assets.compute.instance_no_violation as fixture_compute_instance_no_violation
import data.test.fixtures.compute_block_ssh_keys.assets.compute.instance_violation as fixture_compute_instance_violation

#import data.test.fixtures.compute_block_ssh_keys.assets.projects as fixture_projects

# Importing the test constraint
import data.test.fixtures.compute_block_ssh_keys.constraints as fixture_constraints

template_name := "GCPComputeBlockSSHKeysConstraintV1"

field_name := "block-project-ssh-keys"

field_values := "true"

#No instances at all
#One instance with the correct key
#one instance without correct key
#No instances with the correct key
#An instance without projects configured at all (metadata_config doesn't exist).

#### Testing for GCE instances

#1. No instances at all - need to fix the data.json
test_block_ssh_keys_compute_instance_no_instances {
	expected_resource_names := {"//compute.googleapis.com/projects/prj-dev-palani-ram/zones/us-central1-f/instances/pals-jumphost"}
	test_utils.check_test_violations_count(fixture_compute_instance_no_violation, [fixture_constraints], template_name, 0)
	test_utils.check_test_violations_resources(fixture_compute_instance_violation, [fixture_constraints], template_name, expected_resource_names)
	test_utils.check_test_violations_signature(fixture_compute_instance_violation, [fixture_constraints], template_name)
}

#2a. One instance with correct key
test_block_ssh_keys_compute_instance_no_violations {
	expected_resource_names := {"//compute.googleapis.com/projects/prj-dev-palani-ram/zones/us-central1-f/instances/pals-jumphost"}
	test_utils.check_test_violations_count(fixture_compute_instance_no_violation, [fixture_constraints], template_name, 0)
	test_utils.check_test_violations_resources(fixture_compute_instance_violation, [fixture_constraints], template_name, expected_resource_names)
	test_utils.check_test_violations_signature(fixture_compute_instance_violation, [fixture_constraints], template_name)
}

#2b. One instance without correct key
test_block_ssh_keys_compute_instance_violations {
	expected_resource_names := {"//compute.googleapis.com/projects/prj-dev-palani-ram/zones/us-central1-f/instances/pals-jumphost"}
	test_utils.check_test_violations_count(fixture_compute_instance_violation, [fixture_constraints], template_name, 1)
	test_utils.check_test_violations_resources(fixture_compute_instance_violation, [fixture_constraints], template_name, expected_resource_names)
	test_utils.check_test_violations_signature(fixture_compute_instance_violation, [fixture_constraints], template_name)
}

#	test_utils.check_test_violations_resources(fixture_compute_instance_violation, [fixture_constraints], template_name, expected_resource_names)

#	test_utils.check_test_violations_signature(fixture_compute_instance_violation, [fixture_constraints], template_name)
#
#test_enforce_label_compute_instance_violations {
#	expected_resource_names := {
#		"//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-missing-labels-8hz5",
#		"//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-missing-label1-8hz5",
#		"//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-missing-label2-8hz5",
#		"//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-with-label1-and-label2-bad-values",
#	}
#
#	test_utils.check_test_violations_count(fixture_compute_instances, [fixture_constraints], template_name, 6)
#	test_utils.check_test_violations_resources(fixture_compute_instances, [fixture_constraints], template_name, expected_resource_names)
#	test_utils.check_test_violations_signature(fixture_compute_instances, [fixture_constraints], template_name)
#}

#    test_utils.check_test_violations_metadata(fixture_compute_instances, [fixture_constraints], template_name, key["block-project-ssh-keys"], true)

#find_violations[violation] {
#	instance := data.instances[_]
#	constraint := data.test_constraints[_]
#	issues := deny with input.asset as instance
#		 with input.constraint as constraint
#
#	total_issues := count(issues)
#	violation := issues[_]
#}
get_test_violations(test_assets, test_constraints, test_template) = violations {
	violations := [violation |
		violations := data.templates.gcp[test_template].deny with input.asset as test_assets[_]
			 with input.constraint as test_constraints[_]

		violation := violations[_]
	]

	trace(sprintf("violations %s", [violations]))
}

check_test_violations_count(test_assets, test_constraints, test_template, expected_count) {
	violations := get_test_violations(test_assets, test_constraints, test_template)
	count(violations) == expected_count
}

# This is to check for other field names from violations besides resource
check_test_violations_metadata(test_assets, test_constraints, test_template, field_name, field_values) {
	violations := get_test_violations(test_assets, test_constraints, test_template)
	resource_names := {x | x = violations[_].details[field_name]}
	resource_names == field_values
}

###### Testing for projects
#
## Confirm six violations were found for all projects
## 4 projects have violations - 2 of which have 2 violations (one has 2 labels missing,
## the other has 2 labels with invalid values)
## confirm which 4 projects are in violation
#test_block_ssh_keys_projects_violations {
#	expected_resource_names := {
#		"//cloudresourcemanager.googleapis.com/projects/prj-dev-palani-ram"
#	}
#	test_utils.check_test_violations_count(fixture_projects, [fixture_constraints], template_name, 0)
#	test_utils.check_test_violations_resources(fixture_projects, [fixture_constraints], template_name, expected_resource_names)
#	test_utils.check_test_violations_signature(fixture_projects, [fixture_constraints], template_name)
#}
## Find all violations on our test cases
#find_violations[violation] {
#	instance := data.instances[_]
#	constraint := data.test_constraints[_]
#	issues := deny with input.asset as instance
#		 with input.constraint as constraint
#
#	total_issues := count(issues)
#	violation := issues[_]
#}
#
## 1. Confim no violations with no instances
#test_block_ssh_keys_no_instances {
#	found_violations := find_violations with data.instances as []
#	count(found_violations) = 0
#}
#
##2. one instance with correct key
#test_block_ssh_keys_metadata {
#	found_violations := find_violations with data.instances as fixture_compute_instances
#		 with input.asset.metadata_config.items.key as "block-project-ssh-keys"
#
#	count(found_violations) = 0
#}
#
##3. one instance without correct key
#test_block_ssh_keys_metadata {
#	found_violations := find_violations with data.instances as fixture_compute_instances
#		 with input.asset.metadata_config.items.key as "block-ssh-keys"
#
#	count(found_violations) == 1
#}
#
##4. no instance with correct key (Multiple instances but none of the instance have correct key)
#test_block_ssh_keys_no_instances {
#	found_violations := find_violations with data.instances as []
#		 with input.asset.metadata_config.items.key as "block-project-ssh-keys"
#
#	count(found_violations) == 2
#}
#
##5. metadata missing in data.json
#test_block_ssh_keys_no_metadata {
#	found_violations := find_violations with data.instances as fixture_compute_metadata
#
#	#		 with input.asset.metadata_config as []
#
#	count(found_violations) == 1
#}
#
#test_block_ssh_keys_no_constraints {
#	found_violations := find_violations with data.instances as fixture_compute_instances
#		 with data.constraints as []
#
#	count(found_violations) = 0
#}
