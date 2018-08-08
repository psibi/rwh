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
