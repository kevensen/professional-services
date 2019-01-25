#
# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#!/bin/bash

export BQ_RESULT=$(bq query --project_id $GOOGLE_CLOUD_PROJECT --nouse_legacy_sql "SELECT payload FROM $DATA_SET.$DATA_INPUT_TABLE LIMIT 1000" 2> /dev/null| grep -Eo '[0-9]*')

R_RESULT=$(Rscript add_value.R | sed -e 's/\[1\] //')

R_JSON=$(echo $R_RESULT | sed 's/\ /, /g')

echo "{\"data\": [$R_JSON]}" | bq insert --project_id $GOOGLE_CLOUD_PROJECT $DATA_SET.$DATA_OUTPUT_TABLE