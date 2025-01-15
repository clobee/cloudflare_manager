
<h1 align="center">
Development Environment to manage your Cloudflare resources, using Terraform.
</h1>

<h3 align="center">
Make your changes locally in a docker environment then apply your changes to Cloudflare via Github actions. 
</h3>
<br />

<p align="center">
    <a href="https://github.com/clobee/cloudflare_manager/tags" target="_blank"><img src="https://img.shields.io/github/v/tag/clobee/cloudflare_manager?logo=github&color=79A7B5&link=https%3A%2F%2Fgithub.com%2Fclobee%2Fcloudflare_manager%2Freleases" alt="GitHub tag (with filter)"/></a>
    <a href="https://github.com/clobee/cloudflare_manager/issues" target="_blank"><img src="https://img.shields.io/github/issues/clobee/cloudflare_manager?logo=github&color=2ea087&link=https%3A%2F%2Fgithub.com%2Fclobee%2Fcloudflare_manager%2Fissues" alt="GitHub issues"/></a>
</p>

<br />

> This project is currently in alpha state, so expect major changes in the future!

<p align="center">
Contributors and early adopters are welcome!
</p>

## Pre-Requisite

- The Terraform state is managed in terraform cloud (best practice). This lets your team manage infrastructure using HCP Terraform, which also handles state data. 

In Terraform Cloud, create an organization and a workspace

https://app.terraform.io/public/signup/account?product_intent=terraform

- You will also need the email you are using in Cloudflare and your Cloudflare api key

https://developers.cloudflare.com/fundamentals/api/get-started/keys/

- The Github Actions requires a Github User Token 

https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens


## DOC used:

- https://developers.cloudflare.com/terraform/advanced-topics/best-practices/
- https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
- https://github.com/cloudflare/cf-terraforming


## The tools used:

  1. **Cloudflare:**  
    Cloudflare is a service that helps make websites faster, safer, and more reliable.

  2. **Docker:**  
    Docker is a tool that makes it easy to run apps anywhere by putting them in small, ready-to-go packages called containers. The whole code/application is contain in a controlled environment (which can run in most common Operator system E.g: windows, Mac...). 

  3. **Terraform:**  
    Terraform is an open-source tool for managing cloud infrastructure. 
    It uses files to define and control resources.

  4. **Github:**  
    GitHub is a web-based platform which allows users to store and manage their source code, track changes, and collaborate on projects with others.


## The Concept in a Nutshell

Let's consider a Cloudflare account with 2 ressources (E.g: page rules, firewall rules...)

![image](https://github.com/user-attachments/assets/456db285-290e-4d84-bdd9-4cbb347f6875)

1. When you run the Docker command to initialise the entire environment, a script (/scripts/docker.sh) will clone the Cloudflare resources locally into the ./generated folder.
   _This step is an helper, so as a dev you have all the last changes in your local environment ready to be used._

![image](https://github.com/user-attachments/assets/db4dde81-e300-4f34-9304-aff94a948ae9)

2. In parallel, the resources already tracked by Terraform will be loaded into Terraform local state.  
The ./modules folder contains the resources that have already been added to the system.  

3. A new resource can be added see comments.  
The cloudflare resources are stored in the folder ./modules/ 

![image](https://github.com/user-attachments/assets/0ea6e1af-1d3e-4b3c-8bd9-8899cbb2f91b)

The modules must be referenced in the main.tf file to be detected by Terraform.

![image](https://github.com/user-attachments/assets/5333939e-7ea6-4b67-88dd-b99859b6b9b1)

Don't forget to add the main.tf to your each module you want to add 

![image](https://github.com/user-attachments/assets/6e5c4b62-c812-4c74-a41d-b9246a1dac47)

Pushing changes to GitHub after adding a new resource will trigger a suite of Terraform commands (refer to terraform.yml in GitHub Actions).

![image](https://github.com/user-attachments/assets/c83ec766-f1f3-4b35-813c-17f5f7cc8eef)

4. If the Terraform actions end with a succeful outcome then the change can be found in Cloudflare (if not a related error will be shown in the Github actions summary)

![image](https://github.com/user-attachments/assets/bba1d128-ec7e-482a-ad31-c9d3ee18dba5)


## Getting started

- First, Fork this project in your environment

- Set secrets variables in your repo settings

```text
CLOUDFLARE_EMAIL
CLOUDFLARE_API_KEY

TF_WORKSPACE
TF_CLOUD_ORGANIZATION

GH_USER_TOKEN
```

- Create your .env file (use the .env.tmp as a base)

- Build your local Docker environment

```bash
git clone git@github.com:<MY_GITHUB_USERNAME>/cloudflare_manager.git
```

- Start your docker environment

```bash
# Build the image (if anything has changed)
docker compose down; docker-compose build; docker-compose up -d
```

- Start applying your changes (in the modules folder)


On the related module (you can run any Terraform commands directly from your docker environment)
- Commit your changes
- Check your changes in Cloudflare


You can then enter your working environment (or check the logs of all the commands). 

```bash
# Drop into a bash session
docker exec -it cloudflare_manager sh

#Run a non interactive command 
docker exec -it cloudflare_manager cat logs.txt
```

The system requires some time to build the working environment.
A log file, LOGS.txt, is generated, containing all the commands executed during the entire process.


------


## Some Helpers


### Docker commands

```bash
# List the containers
docker compose ps -a
docker compose rm
```

### Terraform commands

```bash
# Initializes all modules
terraform init

# Generate an execution plan that shows the changes needed to reach the desired state
terraform plan

# Execute the plan to create or update the infrastructure
terraform apply

# Target specific module
terraform plan -target=module.1a2b3c4d
terraform apply -target=module.5e6f7g8h
```

### Extreme Cleanup

```bash
docker rmi -f cloudflare_manager
docker rmi $(docker images -q)
docker system prune -af && docker image prune -af && docker system prune -af --volumes && docker system df
```
