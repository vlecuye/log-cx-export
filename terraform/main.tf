# Create new storage bucket in the canadian region
# with standard storage

resource "google_storage_bucket" "bucket" {
 name          = var.bucket_name
 project       = var.project_id
 location      = "northamerica-northeast1"
 storage_class = "STANDARD"

 uniform_bucket_level_access = true
}

resource "google_cloud_run_v2_service" "default" {
  name     = var.service_name
  location = "northamerica-northeast1"
  project  = var.project_id
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = var.sa_email
    containers {
      image = "northamerica-northeast1-docker.pkg.dev/desjardins-test-338902/cx-log-export/export"
    
    env {
        name = "GCLOUD_REPORT_BUCKET"
        value = var.bucket_name
      }
    env {
        name = "PROJECT_ID"
        value = var.project_id
    }
  }
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloud_run_v2_service.default.location
  project = google_cloud_run_v2_service.default.project
  service = google_cloud_run_v2_service.default.name
  role = "roles/run.invoker"
  member = var.cloudrun_invoker
}