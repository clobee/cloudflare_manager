
# TERRAFORM / CLOUDFLARE

## DOC: https://pernod-ricard.atlassian.net/browse/MNB-792

## =========================
## Terraform
## =========================

With Cloudflare’s Terraform provider, we can manage the Cloudflare global network using the same familiar tools we use to automate the rest of our infrastructure. Define and store configuration in source code repositories like GitHub, track and version changes over time, and roll back when needed — all without needing to use the Cloudflare APIs.

### Best Practices

https://developers.cloudflare.com/terraform/advanced-topics/best-practices/

### Getting started

https://developers.cloudflare.com/terraform/installing/

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

https://github.com/cloudflare/cf-terraforming
```bash
brew tap cloudflare/cloudflare

# do not use brew as it sometimes install older version
go install github.com/cloudflare/cf-terraforming/cmd/cf-terraforming@latest
#optional: export PATH="$PATH:/Users/clobee/go/bin"
```

Which version is installed
```bash
terraform --version
```

If using Visio Code, we recommend to use the following extensionhttps://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform


List / Find a provider https://registry.terraform.io/browse/providers
In our case we are using Cloudflare https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs. The Cloudflare provider is used to interact with resources supported by Cloudflare.


### API tokens

From the Cloudflare dashboard ↗,
go to My Profile > API Tokens for user tokens.
For Account Tokens, go to Manage Account > API Tokens.


### Actions
0. Load the .env variables
```bash
# https://gist.github.com/mihow/9c7f559807069a03e302605691f85572
# set -a; source .env; set +a
# Verify : env | grep CLOU
set -o allexport; source .env; set +o allexport
```

1.

```bash

terraform init

# Compare the LOCAL infrastructure with the REMOTE changes
terraform plan

# Mirror the REMOTE to our LOCAL version
# Resource: cloudflare_record | cloudflare_page_rule | cloudflare_zone
cf-terraforming generate --resource-type "cloudflare_record" --zone $CLOUDFLARE_ZONE_ID > imported.tf

# Import the current CF content in our project (always run this before you start any modif)
cf-terraforming import --resource-type "cloudflare_record" --zone $CLOUDFLARE_ZONE_ID > tmp.sh

```




Docker compose
```bash
# Run one shot command
docker-compose -f docker-compose.yml run terraform init

# Start the entire container
docker-compose -f docker-compose.yml build terraform


docker compose exec -it gcms_cloudflare-terraform-run-eebb9551f746 sh -c "echo 1"


```







List the contianers
```bash
docker compose ps -a
docker compose rm
```







### Github actions

https://www.youtube.com/watch?v=0BNwAEwYZlA&list=PLeXyNq8uiaAYtXbeeLKwGdyHOn6JXE4He&index=4










```bash
# build docker
❯❯ docker build --rm --tag erangaeb/terraform-k8s:0.1 .

# run terraform init
❯❯  docker-compose -f docker-compose.yml run --rm terraform init

# run terraform init
❯❯  docker-compose -f docker-compose.yml run --rm terraform claude

# run terrafrom plan
❯❯ docker run --name terraform -v /private/var/services/terraform:/app/.state erangaeb/terraform-k8s:0.1 plan


# run terraform apply
❯❯ docker run --name terraform -v /private/var/services/terraform:/app/.state erangaeb/terraform-k8s:0.1 apply


# terraform apply will deploy kubernets resource in minkube cluster
❯❯ kubectl get pods -n rahasak
NAME                     READY   STATUS    RESTARTS   AGE
nginx-54b5bd6994-8pr6t   1/1     Running   0          32s
nginx-54b5bd6994-whg9s   1/1     Running   0          32s


# now the terraform state files can be found in the docker volume
❯❯ ls -al /private/var/services/terraform/
total 16
drwxr-xr-x 2 root root   80 Feb  5 13:55 .
drwxrwxrwx 3 root root   60 Feb  5 13:10 ..
-rw-r--r-- 1 root root 9269 Feb  5 13:55 terraform.tfstate
-rw-r--r-- 1 root root  180 Feb  5 13:55 terraform.tfstate.backup


# run terraform destroy
❯❯ docker run --name terra -v /private/var/services/terraform:/app/.state erangaeb/terraform-k8s:0.1 destroy
```
















```bash


```
