variable "project_id" {
    description="project ID in string format"
  type = string
}

variable "bucket_name" {
    description="Name of the bucket to export to (must be unique)"
    type=string
}

variable "service_name" {
    description="Name of the Cloud Run service to be called"
    type=string
}

variable "sa_email" {
    description="Email of the service account to be used by Cloud Run."
    type=string
}

variable cloudrun_invoker {
    description="Email address of the person calling the Cloud Run instance"
    type=string
}