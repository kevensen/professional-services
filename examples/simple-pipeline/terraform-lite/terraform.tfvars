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
project_id      		= ""
# Must match your GKE regoin
region 					= ""
# A single letter for the zone (must match the GKE zone)
zone 					= ""
# BigQuery Table
table 					= ""
# BigQuery Dataset
dataset 				= ""
bucket 					= ""
image_name 				= ""
# The name of the GKE Cluster
gke_cluster             = ""

# Ensure these are correct (on the machine running terraform)
full_path_to_docker 	= "/usr/bin/docker"
full_path_to_gcloud		= "/google/google-cloud-sdk/bin/gcloud"
full_path_to_kubectl	= "/google/google-cloud-sdk/bin/kubectl"