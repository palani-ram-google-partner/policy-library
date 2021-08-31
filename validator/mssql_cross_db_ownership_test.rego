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
package templates.gcp.GCPMsSQLCrossDBOwnershipConstraintV1

import data.test.fixtures.mssql_cross_db_ownership.constraints as fixture_constraints

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

import data.test.fixtures.mssql_cross_db_ownership.assets.no_settings as fixture_no_settings
import data.test.fixtures.mssql_cross_db_ownership.assets.no_violations as fixture_no_violation
import data.test.fixtures.mssql_cross_db_ownership.assets.violations as fixture_violation

template_name := "GCPMsSQLCrossDBOwnershipConstraintV1"

#1. mssql with correct key
test_mssql_cross_db_ownership_no_violations {
	expected_resource_names := {"//cloudsql.googleapis.com/projects/prj-dev-palani-ram/instances/tf-mssql-public-42b95125"}
	test_utils.check_test_violations_resources(fixture_no_violation, [fixture_constraints], template_name, expected_resource_names)
}

#2. mssql without correct key
test_mssql_cross_db_ownership_violations {
	expected_resource_names := {"//cloudsql.googleapis.com/projects/prj-dev-palani-ram/instances/tf-mssql-public-42b95125"}
	test_utils.check_test_violations_count(fixture_violation, [fixture_constraints], template_name, 1)
	test_utils.check_test_violations_resources(fixture_violation, [fixture_constraints], template_name, expected_resource_names)
}

#3. An instance without settings configured at all (settings doesn't exist).
test_mssql_cross_db_ownership_no_settings {
	expected_resource_names := {"//cloudsql.googleapis.com/projects/prj-dev-palani-ram/instances/tf-mssql-public-42b95125"}
	expected_field_name := "key_in_violation"
	expected_field_values := {"cross db ownership chaining"}
	test_utils.check_test_violations_count(fixture_no_settings, [fixture_constraints], template_name, 1)
	test_utils.check_test_violations_resources(fixture_no_settings, [fixture_constraints], template_name, expected_resource_names)
	test_utils.check_test_violations_metadata(fixture_no_settings, [fixture_constraints], template_name, expected_field_name, expected_field_values)
}
