# Bash into a POD

``` shellsession
kubectl exec -ti $POD_NAME bash
```

# Creating POD

``` shellsession
kubectl create -f pods/monolith.yaml
```

# Describe POD

``` shellsession
kubectl describe pods
```

# Port forwarding

``` shellsession
kubectl port-forward monolith 10080:80
```

And in your local system:

``` shellsession
~ $ curl http://localhost:10080
{"message":"Hello"}
~ $ curl http://localhost:10080/secure
authorization failed
~ $ curl -u user http://localhost:10080/login
Enter host password for user 'user':
{"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InVzZXJAZXhhbXBsZS5jb20iLCJleHAiOjE1MzM5NjcyMzEsImlhdCI6MTUzMzcwODAzMSwiaXNzIjoiYXV0aC5zZXJ2aWNlIiwic3ViIjoidXNlciJ9.8vDLBQZrW1sVzLCCCcT_OO8z4WBzarXWSi7rsBHj-bw"}
~ $ curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InVzZXJAZXhhbXBsZS5jb20iLCJleHAiOjE1MzM5NjcyMzEsImlhdCI6MTUzMzcwODAzMSwiaXNzIjoiYXV0aC5zZXJ2aWNlIiwic3ViIjoidXNlciJ9.8vDLBQZrW1sVzLCCCcT_OO8z4WBzarXWSi7rsBHj-bw" http://localhost:10080/secure
{"message":"Hello"}
```

# Logs from POD

``` shellsession
$ kubectl logs monolith

2018/08/07 14:37:52 Starting server...
2018/08/07 14:37:52 Health service listening on 0.0.0.0:81
2018/08/07 14:37:52 HTTP service listening on 0.0.0.0:80
127.0.0.1:34620 - - [Wed, 08 Aug 2018 05:59:22 UTC] "GET / HTTP/1.1" curl/7.58.0
127.0.0.1:34670 - - [Wed, 08 Aug 2018 05:59:47 UTC] "GET /secure HTTP/1.1" curl/7.58.0
127.0.0.1:34720 - - [Wed, 08 Aug 2018 06:00:30 UTC] "GET /login HTTP/1.1" curl/7.58.0
127.0.0.1:34806 - - [Wed, 08 Aug 2018 06:01:29 UTC] "GET /secure HTTP/1.1" curl/7.58.0
```

Continously see logs:

``` shellsession
kubectl logs -f monolith
```
# Secrets and Configmaps

``` shellsession
$ kubectl create secret generic tls-certs --from-file=tls/
secret/tls-certs created
```

``` shellsession
$ kubectl describe secrets tls-certs
```

Or

``` shellsession
$ kubectl describe secret/tls-certs
Name:         tls-certs
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
ca-key.pem:               1675 bytes
ca.pem:                   1099 bytes
cert.pem:                 1253 bytes
key.pem:                  1679 bytes
ssl-extensions-x509.cnf:  275 bytes
update-tls.sh:            610 bytes
```

``` shellsession
$ kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf
configmap/nginx-proxy-conf created
```

``` shellsession
$ kubectl describe configmap nginx-proxy-conf
Name:         nginx-proxy-conf
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
proxy.conf:
----
server {
  listen 443;
  ssl    on;

  ssl_certificate     /etc/tls/cert.pem;
  ssl_certificate_key /etc/tls/key.pem;

  location / {
    proxy_pass http://127.0.0.1:80;
  }
}

Events:  <none>
```

Remaining tasks:

```
$ kubectl create -f pods/secure-monolith.yaml
pod/secure-monolith created
$ kubectl get pods secure-monolith
NAME              READY     STATUS    RESTARTS   AGE
monolith          1/1       Running   0          16h
secure-monolith   2/2       Running   0          19s
$ kubectl port-forward secure-monolith 10443:443
Forwarding from 127.0.0.1:10443 -> 443
Forwarding from [::1]:10443 -> 443
```

In local shell,

```
~ $ curl https://localhost:10443
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
~ $ curl --cacert github/fpco/ud615/kubernetes/tls/ca.pem https://localhost:10443
{"message":"Hello"}

~ $ kubectl logs -c nginx secure-monolith
127.0.0.1 - - [08/Aug/2018:06:51:00 +0000] "GET / HTTP/1.1" 400 271 "-" "curl/7.58.0" "-"
127.0.0.1 - - [08/Aug/2018:06:52:31 +0000] "GET / HTTP/1.1" 200 20 "-" "curl/7.58.0" "-"
```

The `-c` option indicates a specific container in that pod. Note that
`secure-monolith` pod is running two containers.

# Services

* Persistent endpoints for Pods.
* Uses labels to select pods.
* Internal or External IPs.

``` shellsession
$ kubectl create -f services/monolith.yaml
service/monolith created
```

Note that now you have exposed port 31000 to the outside world. This will route traffic to nginx at 443. So, In AWS - you likely need to create a new security group rule.

# Pods Labels Operations

``` shellsession
$ kubectl get pods -l "app=monolith"
NAME              READY     STATUS    RESTARTS   AGE
monolith          1/1       Running   0          17h
secure-monolith   2/2       Running   0          54m

$ kubectl get pods -l "app=monolith,secure=enabled"
No resources found.

$ kubectl describe pods secure-monolith | grep Labels
Labels:       app=monolith

$ kubectl label pods secure-monolith "secure=enabled"
pod/secure-monolith labeled
```



