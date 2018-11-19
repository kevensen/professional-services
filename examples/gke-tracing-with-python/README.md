# GKE Tracing with Python
This simple Python based web application can be used to demonstrate various monitoring, logging, and tracing capabilities in Stackdriver.

1. [Obtain credentials](https://cloud.google.com/container-registry/docs/pushing-and-pulling#before_you_begin) for the Google Container Registry

2. Clone this Repo.
```shell
git clone https://github.com/kevensen/professional-services.git
```

3. Navigate to Folder.
```shell
cd professional-services/examples/gke-tracing-with-python
```

4. Build container image.
```shell
docker build -t gcr.io/$GOOGLE_CLOUD_PROJECT/python-webapp:latest .
```

5. Push container image.
```shell
docker push gcr.io/$GOOGLE_CLOUD_PROJECT/python-webapp:latest
```

6. Create default limits and requests for your namespace.
```shell
kubectl apply -f k8s/default-limits-requests.yaml
```

7. Deploy the webapp
```shell
sed "s/GOOGLE_CLOUD_PROJECT/$GOOGLE_CLOUD_PROJECT/" k8s/deployment.yaml | kubectl apply -f -
```

8. Deploy the service.
```shell
kubectl apply -f k8s/service.yaml
```

9. Deploy the horizontal pod autoscaler.
```shell
kubectl apply -f k8s/autoscaler.yaml
```

10. Generate a load.
```shell
$ kubectl run -i --tty load-generator --image=busybox /bin/sh

Hit enter for command prompt

$ while true; do wget -q -O- http://webapp.default.svc.cluster.local:8080; done
```