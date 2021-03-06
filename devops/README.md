
# Devops



* [Ops School](http://www.opsschool.org/en/latest/)

# Networking

* [VPN vs Proxy](https://superuser.com/questions/257388/what-is-the-difference-between-a-proxy-and-a-vpn)
* [Amazon VPC](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Introduction.html)
* [IP Address basics](https://www.digitalocean.com/community/tutorials/understanding-ip-addresses-subnets-and-cidr-notation-for-networking)
* [How does Subnets work](https://serverfault.com/questions/49765/how-does-ipv4-subnetting-work)

# Terraform articles

* https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180
* [Terraform - Count related doc](https://www.terraform.io/docs/configuration/resources.html)

# Consul

* https://www.digitalocean.com/community/tutorials/an-introduction-to-using-consul-a-service-discovery-system-on-ubuntu-14-04
* https://medium.com/@ladislavGazo/easy-routing-and-service-discovery-with-docker-consul-and-nginx-acfd48e1a291
* https://www.nginx.com/blog/service-discovery-in-a-microservices-architecture/

# Kubernetes

* [Getting Started Guide](https://vsupalov.com/getting-started-with-kubernetes/)
* [Interesting articles](https://akomljen.com/tag/kubernetes/)
* [DO - Introduction to Kubernetes](https://www.digitalocean.com/community/tutorials/an-introduction-to-kubernetes)
* [Udacity course](https://www.udacity.com/course/scalable-microservices-with-kubernetes--ud615)
* [Environment variables for containers](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/)
* [Helm](https://medium.com/@gajus/the-missing-ci-cd-kubernetes-component-helm-package-manager-1fe002aac680)
* [Ports in services](https://stackoverflow.com/a/49982009/1651941)

# Webapp + Kubernetes

* [Using external IP of LB service](https://stackoverflow.com/questions/48291745/how-do-i-find-out-the-external-ip-of-a-load-balancer-service)
* https://github.com/helm/helm/issues/949 - Problematic issue
* [Preserving client IP](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip)

# SaltStack

* [Official guide](https://docs.saltstack.com/en/getstarted/fundamentals/index.html)

# Ansible

* [Youtube Video](https://www.youtube.com/watch?v=icR-df2Olm8)

# CI/CD

* [Beginner guide to Jenkins Pipeline](https://www.reddit.com/r/devops/comments/7u3zk7/a_beginners_guide_to_jenkins_pipeline/)
* [Continuous Integration: Part 1 - Setting Up VMs, Docker, and Jenkins](http://blog.asg-service.net/post/continuous-integration-part-1-setting-up-vms-docker-and-jenkins/)

# Misc

* [Primer on Load Balancing](https://www.reddit.com/r/devops/comments/6krvhu/a_primer_on_load_balancing/)

# Network Programming

* [Beej's Guide](https://beej.us/guide/bgnet/html/multi/index.html)
* [C10K Problem](http://www.kegel.com/c10k.html)


# AWS

* [ARN and namespaces](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html)
* [AWS CLI Configuration and Credential files](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html)
* [AWS Cli Profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html)
* [Assuming a role via AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html)
* [Shared Credential file/CLI config file doc](https://docs.aws.amazon.com/cli/latest/topic/config-vars.html)
*  `aws iam list-virtual-mfa-devices --profile admin`
* [Ingress vs Egress](https://en.wikipedia.org/wiki/Egress_filtering)
* Note that you need to have MFA serial for the role you have initially.
* Also, you need to find the Role ARN for which you need access (or switch or assume) to.
* Also, you need to generate secret access tokens for the things you initially have.
* Let's assume, a user named "sibi" has been created and he needs to assume the role of "power-user" for some arbitray account to do some operations. Then you need to find the MFA serial and the access keys for the user "sibi" and the Role ARN for the "power-user" role of that particular account:
  ```
  # ~/.aws/config
  [profile company-power-user]
  role_arn=arn:aws:iam::xxxx92:role/power-user
  source_profile=sibi
  mfa_serial=arn:aws:iam::xxx992:mfa/sibi

  # ~/.aws/credentials
  [sibi]
  aws_access_key_id=xxxxxxxxxx
  aws_secret_access_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  ```

  And then you can have something like `aws-env.config` in the directory you are going to use `aws-env`:
  ```
  profile=company-power-user
  role_arn = arn:aws:iam::xxxx92:role/power-user
  ```

  And then you can invoke `aws-env -- aws s3 ls`
* Finding Role ARN:
  - Go the AWS Console
  - Go to IAM
  - Click "users" from the left menu.
  - Click the user name you are interested in.
  - Your "User ARN" will appear.
* Finding MFA Serial
  - Go the AWS Console
  - Go to IAM
  - Click "users" from the left menu.
  - Click "security credentials" tab.
  - Get MFA serial from "Asigned MFA device" input text.
* [aws-env tutorial](https://github.com/fpco/devops-helpers/blob/master/doc/aws/aws-env.md)
* Test command: `aws-env -- aws s3 ls`
