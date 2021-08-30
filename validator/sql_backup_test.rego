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

package templates.gcp.GCPSQLBackupConstraintV1

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

import data.test.fixtures.sql_backup.assets as fixture_assets
import data.test.fixtures.sql_backup.constraints.exemption as fixture_constraints_exemptions
import data.test.fixtures.sql_backup.constraints.no_parameter as fixture_constraints_no_parameter

template_name := "GCPSQLBackupConstraintV1"

test_sql_backup_no_parameter {
	expected_resource_names := {"//cloudsql.googleapis.com/projects/brunore-db-test/instances/mysqlv2-nomaintenance"}
	test_utils.check_test_violations_count(fixture_assets, [fixture_constraints_no_parameter], template_name, 4)
}

test_sql_backup_exemption {
	expected_resource_names := {"//cloudsql.googleapis.com/projects/brunore-db-test/instances/postgres-nomaintenance"}
	test_utils.check_test_violations_count(fixture_assets, [fixture_constraints_exemptions], template_name, 3)
}
