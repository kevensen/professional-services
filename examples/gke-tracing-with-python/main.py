# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import logging
from math import sqrt
from flask import current_app, Flask, redirect, request, session, url_for
from tracer.istiotracing import istiotrace

#pylint: disable=W0612
def create_app(debug=False, testing=False, config_overrides=None):
    app = Flask(__name__)

    app.debug = debug
    app.testing = testing

    if config_overrides:
        app.config.update(config_overrides)

    # Configure logging
    if not app.testing:
        logging.basicConfig(level=logging.INFO)

    # Create a health check handler. Health checks are used when running on
    # Google Compute Engine by the load balancer to determine which instances
    # can serve traffic. Google App Engine also uses health checking, but
    # accepts any non-500 response as healthy.
    @app.route('/_ah/health')
    def health_check():
        return 'ok', 200


    # Add a default root route.
    @app.route("/")
    def index():
        return 'ok', 200
    
    @istiotrace
    @app.route("/istio")
    def istio():
        create_load()
        return 'ok', 200

    # Add an error handler. This is useful for debugging the live application,
    # however, you should disable the output of the exception for production
    # applications.
    @app.errorhandler(500)
    def server_error(e):
        return """
        An internal error occurred: <pre>{}</pre>
        See logs for full stacktrace.
        """.format(e), 500

    return app


def create_load():
    x = 0.0001
    for x in range(0, 1000000):
        x += sqrt(x)
    current_app.logger.debug("X is %f", x)


# Note: debug=True is enabled here to help with troubleshooting. You should
# remove this in production.
app = create_app(debug=True)

# This is only used when running locally. When running live, gunicorn runs
# the application.
if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=True)