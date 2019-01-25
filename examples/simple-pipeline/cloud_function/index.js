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


/**
 * Background Cloud Function to be triggered by Pub/Sub.
 * This function is exported by index.js, and executed when
 * the trigger topic receives a message.
 *
 * @param {object} event The Cloud Functions event.
 * @param {function} callback The callback function.
 */


exports.injestPubSub = (event, callback) => {
  
  // Imports the Google Cloud client library
  const BigQuery = require('@google-cloud/bigquery');
  console.log(`received message ${JSON.stringify(event)}`);
  
  // Your Google Cloud Platform project ID
  var projectId = process.env.GCLOUD_PROJECT;
  var pubsubMessage = event.data;
  var data = pubsubMessage.data ? Buffer.from(pubsubMessage.data, 'base64').toString() : 0;
  var data_int = parseInt(data, 10);
  
  let bq_data = {
    "payload": data_int,
	};
  
  // Creates a client
  const bigquery = new BigQuery({
    projectId: projectId,
  });
        
  bigquery
  .dataset(process.env.DATASET)
  .table(process.env.TABLE)
  .insert(bq_data)
  .then(() => {
    console.log(`inserted data: ${JSON.stringify(bq_data)}`);
  })
  .catch(err => {
    if (err && err.name === 'PartialFailureError') {
      if (err.errors && err.errors.length > 0) {
        console.log('Insert errors:');
        err.errors.forEach(err => console.error(err));
      }
    } else {
      console.error('ERROR:', err);
    }
  });

  
  callback();
};