variable "image_name" {}
variable "full_path_to_docker" {}
variable "full_path_to_gcloud" {}
variable "full_path_to_kubectl" {}

resource "google_container_cluster" "primary" {
  name               = "processor-cluster-gke"
  zone               = "${var.region}-${var.zone}"
  initial_node_count = 1
  min_master_version = "1.11.3-gke.18"
  project 			 = "${google_project.project.project_id}"

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/bigquery",
    ]
  }
  depends_on = ["google_project_service.compute", "google_project_service.container"]
  
  provisioner "local-exec" "container_build"{
		command = "${var.full_path_to_docker} build -t gcr.io/${google_project.project.project_id}/${var.image_name}:latest ${path.module}/../processor/"  	
  }
  provisioner "local-exec" "contaier_push" {
		command = "${var.full_path_to_docker} push gcr.io/${google_project.project.project_id}/${var.image_name}:latest"
  }  
	
  provisioner "local-exec" "gcloud_auth" {
		command = "${var.full_path_to_gcloud} auth configure-docker"
  }
	
  provisioner "local-exec" "contaier_push" {
		command = "${var.full_path_to_gcloud} container clusters get-credentials processor-cluster-gke --zone ${var.region}-${var.zone} --project ${google_project.project.project_id}"
  }
  provisioner "local-exec" "kubectl_job" {
		command = "/google/google-cloud-sdk/bin/kubectl run processor --schedule='*/5 * * * *' --restart=OnFailure --image=gcr.io/${google_project.project.project_id}/${var.image_name}:latest --env='GOOGLE_CLOUD_PROJECT=${google_project.project.project_id}' --env='DATA_SET=${var.dataset}' --env='DATA_INPUT_TABLE=${var.table}_raw' --env='DATA_OUTPUT_TABLE=${var.table}_processed'"
  }	
}
