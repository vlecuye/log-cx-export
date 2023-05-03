#!/usr/bin/env bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##
# script.sh
# Uses gcloud to create a report of Cloud Run services.
# Uses gsutil to write the report to Cloud Storage.
#
# Requires GCLOUD_REPORT_BUCKET environment variable
##

# [START cloudrun_report_script]
set -eo pipefail

# Check for required environment variables.
requireEnv() {
  test "${!1}" || (echo "gcloud-report: '$1' not found" >&2 && exit 1)
}
requireEnv GCLOUD_REPORT_BUCKET
requireEnv PROJECT_ID
# Prepare formatting: Default search term to include all services.
format="json"

# Create a specific object name that will not be overridden in the future.
obj="gs://${GCLOUD_REPORT_BUCKET}"

# Write a report containing the service name, service URL, service account or user that
# deployed it, and any explicitly configured service "limits" such as CPU or Memory.

gcloud alpha logging copy ${3} storage.googleapis.com/${4} --location=${5}  --log-filter='logName="projects/'${PROJECT_ID}'/logs/dialogflow-runtime.googleapis.com%2Frequests" AND timestamp>="'${1}'T00:00:00Z" AND timestamp<="'${2}'T23:59:59Z"'
#gcloud logging read 'logName="projects/'${PROJECT_ID}'/logs/dialogflow-runtime.googleapis.com%2Frequests" AND timestamp>="'${1}'T00:00:00Z" AND timestamp<="'${1}'T23:59:59Z"' --format=json | jq -cn --stream 'fromstream(1|truncate_stream(inputs))' | gcloud storage cp - $obj/export-$1.json&
# /dev/stderr is sent to Cloud Logging.
echo "Job Started, see logs for details!"

# [END cloudrun_report_script]
