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

package templates.gcp.GCPStorageBucketPolicyOnlyConstraintV1

template_name := "GCPStorageBucketPolicyOnlyConstraintV1"

# Importing the test data
import data.test.fixtures.storage_bucket_policy_only.assets as fixture_assets

# Importing the test constraints
import data.test.fixtures.storage_bucket_policy_only.constraints.require_bucket_policy_only as fixture_constraints

# Import test utils
import data.validator.test_utils as test_utils

test_storage_bucket_policy_only_enabled {
	expected_resource_names := {"//storage.googleapis.com/my-storage-bucket-with-bucketpolicyonly"}
	not test_utils.check_test_violations_resources(fixture_assets, [fixture_constraints], template_name, expected_resource_names)
}

test_storage_uniform_bucket_level_access_enabled {
	expected_resource_names := {"//storage.googleapis.com/my-storage-bucketwithuniformbucketlevelaccess"}
	not test_utils.check_test_violations_resources(fixture_assets, [fixture_constraints], template_name, expected_resource_names)
}

test_storage_bucket_policy_only_violations_no_data {
	expected_resource_names := {"//storage.googleapis.com/my-storage-bucket-with-no-bucketpolicyonly-data"}
	not test_utils.check_test_violations_resources(fixture_assets, [fixture_constraints], template_name, expected_resource_names)
}

test_storage_bucket_policy_only_violations_null_data {
	expected_resource_names := {"//storage.googleapis.com/my-storage-bucket-with-null-bucketpolicyonly"}
	not test_utils.check_test_violations_resources(fixture_assets, [fixture_constraints], template_name, expected_resource_names)
}

