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

package templates.gcp.GCPSQLPublicIpConstraintV1

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

import data.test.fixtures.sql_public_ip.assets as fixture_violation
import data.test.fixtures.sql_public_ip.constraints as fixture_constraints

template_name := "GCPSQLPublicIpConstraintV1"

test_sql_public_ip_violations {
	expected_resource_names := {"//cloudsql.googleapis.com/projects/test-project/instances/public-sql"}
	test_utils.check_test_violations_count(fixture_violation, [fixture_constraints], template_name, 3)
}



