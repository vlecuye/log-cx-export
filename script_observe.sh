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

# Write a report containing the service name, service URL, service account or user that
# deployed it, and any explicitly configured service "limits" such as CPU or Memory.

gcloud logging operations describe ${1} --location=${2}
#gcloud logging read 'logName="projects/'${PROJECT_ID}'/logs/dialogflow-runtime.googleapis.com%2Frequests" AND timestamp>="'${1}'T00:00:00Z" AND timestamp<="'${1}'T23:59:59Z"' --format=json | jq -cn --stream 'fromstream(1|truncate_stream(inputs))' | gcloud storage cp - $obj/export-$1.json&
# /dev/stderr is sent to Cloud Logging.

# [END cloudrun_report_script]
