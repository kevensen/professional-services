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
variable "dataset" {}
variable "table" {}

resource "google_project_service" "biqquery" {
   project = "${google_project.project.project_id}"
   service = "bigquery-json.googleapis.com"
}

resource "google_bigquery_dataset" "data" {
  project = "${google_project.project.project_id}"
  dataset_id                  = "${var.dataset}"
  friendly_name               = "${google_project.project.project_id}_dataset"
  description                 = "This is a test description for ${google_project.project.project_id}_dataset"
  location                    = "US"
  depends_on                  = ["google_project_service.biqquery"]
}


resource "google_bigquery_table" "data_raw" {
  project = "${google_project.project.project_id}"

  dataset_id = "${google_bigquery_dataset.data.dataset_id}"
  table_id = "${var.table}_raw"
  schema = "${file("data_raw_schema.json")}"
}

resource "google_bigquery_table" "data_processed" {
  project = "${google_project.project.project_id}"

  dataset_id = "${google_bigquery_dataset.data.dataset_id}"
  table_id = "${var.table}_processed"
  schema = "${file("data_processed_schema.json")}"
}


output "bq dataset" {
 value = "${google_bigquery_dataset.data.dataset_id}"
}