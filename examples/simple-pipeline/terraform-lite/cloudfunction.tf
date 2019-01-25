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

data "archive_file" "cloud_function_source" {
  type        = "zip"
  output_path = "${path.module}/cloud_function_source.zip"
  source_dir  = "${path.module}/../cloud_function"

}

resource "google_storage_bucket_object" "cloud_function_source" {
  name   		= "cloud_functions_source"
  source 		= "${path.module}/cloud_function_source.zip"
  bucket 		= "${var.bucket}"
  depends_on 	= ["google_storage_bucket.cloud_functions_store", "data.archive_file.cloud_function_source", "google_project_service.cloudfunctions"]
}

resource "google_cloudfunctions_function" "pubsub_injest_function" {
  name                  = "pubsub-injest-function"
  description           = "Read from PubSub and place in BigQuery"
  available_memory_mb   = 128
  source_archive_bucket = "${var.bucket}"
  source_archive_object = "${google_storage_bucket_object.cloud_function_source.name}"
  event_trigger         = {
	event_type = "providers/cloud.pubsub/eventTypes/topic.publish",
	resource = "${google_pubsub_topic.streaming_data.name}"
  }
  timeout               = 60
  entry_point           = "injestPubSub"
  project 				= "${var.project_id}"
  environment_variables {
    DATASET = "${var.dataset}",
    TABLE = "${var.table}_raw"
  }
  depends_on = ["google_project_service.cloudfunctions", 
  				"google_storage_bucket_object.cloud_function_source",
  				"google_pubsub_topic.streaming_data"]
}