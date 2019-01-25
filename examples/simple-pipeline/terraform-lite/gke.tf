/*
 * Copyright 2018 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "image_name" {}
variable "full_path_to_docker" {}
variable "full_path_to_gcloud" {}
variable "full_path_to_kubectl" {}
variable "gke_cluster" {}


resource "null_resource" "gke_cluster" {

    provisioner "local-exec" "container_build"{
        command = "${var.full_path_to_docker} build -t gcr.io/${var.project_id}/${var.image_name}:latest ${path.module}/../processor/"  	
    }
    
    provisioner "local-exec" "contaier_push" {
        command = "${var.full_path_to_docker} push gcr.io/${var.project_id}/${var.image_name}:latest"
    }  

    provisioner "local-exec" "gcloud_auth" {
        command = "${var.full_path_to_gcloud} auth configure-docker"
    }

    provisioner "local-exec" "contaier_push" {
        command = "${var.full_path_to_gcloud} container clusters get-credentials ${var.gke_cluster} --zone ${var.region}-${var.zone} --project ${var.project_id}"
    }
    
    provisioner "local-exec" "kubectl_job" {
        command = "/google/google-cloud-sdk/bin/kubectl run processor --schedule='*/5 * * * *' --restart=OnFailure --image=gcr.io/${var.project_id}/${var.image_name}:latest --env='GOOGLE_CLOUD_PROJECT=${var.project_id}' --env='DATA_SET=${var.dataset}' --env='DATA_INPUT_TABLE=${var.table}_raw' --env='DATA_OUTPUT_TABLE=${var.table}_processed'"
    }	
}

