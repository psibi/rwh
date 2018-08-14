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

Or

```
kubectl port-forward $POD_NAME 10080:80
```

Note that `80` is the port on which it exposes within the container.

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

After adding the corresponding AWS terraform rule:

``` terra
resource "aws_security_group_rule" "port_testing_access" {
  description              = "https test"
  from_port                = "31000"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.demo-node.id}"
  cidr_blocks              = ["0.0.0.0/0"]
  to_port                  = "31000"
  type                     = "ingress"
}
```

And after applying the plan, you can do the curl to it:

```
$ curl -k https://x.x.x.x:31000
{"message":"Hello"}
```

Note that if you have two different 

# Deployments

* Drive current state towards desired state
* You can provide replicas.

``` terra
$ kubectl create -f deployments/auth.yaml
deployment.extensions/auth created

$ kubectl describe deployments auth
```

Other tasks:

``` shellsession
$ kubectl create -f services/auth.yaml
$ kubectl create -f deployments/hello.yaml
$ kubectl create -f services/hello.yaml
$ kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
$ kubectl create -f deployments/frontend.yaml
$ kubectl create -f services/frontend.yaml
$ kubectl get services frontend
NAME       TYPE           CLUSTER-IP      EXTERNAL-IP                                                               PORT(S)         AGE
frontend   LoadBalancer   172.20.146.42   aaff20c7e9ae811e8af0a02501deeb42-2031620562.us-west-2.elb.amazonaws.com   443:31133/TCP   31s
$ curl -k https://x.x.x.x
```

You likely need to allow 443 port access in AWS security group for the last curl command to work.

# Scaling

Done by updating the replicas.

``` shellsession
$ kubectl get replicasets
$ kubectl get pods -l "app=hello,track=stable"
$ emacs deployments/hello.yaml # And change replicasets to 3
$ kubectl apply -f deployments/hello.yaml
```

See new replicasets:

``` shellsession
$ kubectl get replicasets
$ kubectl get pods
$ kubectl describle deployment hello
```

# Rolling Update

``` shellsession
$ emacs deployments/auth.yaml # Change docker image version to 2.0.0
$ kubectl apply -f deployments/auth.yaml
$ kubectl describe deployments auth
```

# Further Reading

* [Yaml file and K8 object](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/)
* Regarding the POD host name: [DNS Pod Service](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
* [Different Ports for a service](https://vitalflux.com/kubernetes-port-targetport-and-nodeport/)
* [Difference between POD and Deployment](https://stackoverflow.com/q/41325087/1651941)
* [NodePort vs LoadBalancer vs Ingress](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0)
1* Check docker image -
```
docker run -p 2000:80 udacity/example-monolith:1.0.0
```

Inside docker image, it runs on port 80.
```
~ $ curl localhost:2000
{"message":"Hello"}
```
* it's important for the service selector (spec.selector) to match with pod's labels (metadata.labels) to work.
