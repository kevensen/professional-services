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

variable "project_name" {}
variable "billing_account" {}
variable "org_id" {}
variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "b"
}

provider "google" {
 region = "${var.region}"
}

resource "random_id" "id" {
 byte_length = 4
 prefix      = "${var.project_name}-"
}

resource "google_project" "project" {
 name            = "${random_id.id.hex}" #"${var.project_name}"
 project_id      = "${random_id.id.hex}"
 billing_account = "${var.billing_account}"
 org_id          = "${var.org_id}"
}

resource "google_project_service" "compute" {
   project = "${google_project.project.project_id}"
  service = "compute.googleapis.com"
}

resource "google_project_service" "iam" {
   project = "${google_project.project.project_id}"
   service = "iam.googleapis.com"
}


resource "google_project_service" "logging" {
  project = "${google_project.project.project_id}"
  service = "logging.googleapis.com"
}

resource "google_project_service" "storage" {
  project = "${google_project.project.project_id}"
  service = "storage-component.googleapis.com"
}

resource "google_project_service" "pubsub" {
   project = "${google_project.project.project_id}"
   service = "pubsub.googleapis.com"
}

resource "google_project_service" "cloudfunctions" {
   project = "${google_project.project.project_id}"
   service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "container" {
   project = "${google_project.project.project_id}"
   service = "container.googleapis.com"
}

output "project_id" {
 value = "${google_project.project.project_id}"
}