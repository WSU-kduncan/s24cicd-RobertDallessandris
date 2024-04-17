# Project 5  
Robert D'Allessandris  
CEG 3120  
Spring 2024  

## CD Project Overview  
**Project Due Friday April 19th**    

This project demonstrates the continuous deployment of a Docker image. The image is an apache2 http server image that will be automatically pushed to DockerHub with correct semantic versioning when a change is pushed to GitHub. This is accomplished using GitHub actions as defined in the .github/workflows directory. 

**TODO** 
- Include a diagram of the continuous deployment process. A good diagram will label tools used and how things connect. 


## 1. Semantic Versioning  
**Milestone Due Friday April 5th**  

[Semantic Versioning](https://semver.org/)  
[Github Actions - Docker metadata](https://github.com/docker/metadata-action)  
[Docker Docs - Manage tags/labels with GitHub actions](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/)  
[Git Tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging)  

### How to generate a tag in git / GitHub

A lightweight tag is simply:  
```bash
git tag v1.0
```  
  
To generate an annotated tag:  
```bash
git tag -a v1.1 -m "Release version 1.1"
```  
Annotated tags store additional information such as tagger name, email, date and a message.  

Tags do not get automatically pushed up to GitHub. To push a tag:  
```bash
git push origin v1.0
```  

### Amend GitHub Action workflow to push Docker images with tags

To change the GitHub Action workflow to trigger when a tag is pushed, amend the workflow trigger in the yaml file as follows:  

```yaml
on:
  push:
    tags:
      - 'v*'
```  
  
This will cause the workflow to trigger only when a tag is pushed.  
  
To Generate tags for the DockerHub image we will use the `docker/metadata-action` GitHub Action. Add the following to the steps section of the workflow yaml:  
  
```yaml
- 
    name: Docker meta
    id: meta
    uses: docker/metadata-action@v5
    with:
        images: |
            rdalless/ceg3120
        tags: |
        type=ref,event=tag
        type=semver,pattern=v{{major}}.{{minor}}
        type=semver,pattern=v{{major}}
```  
  
This will collect the github tag metadata that we will use when pushing the image to DockerHub.  
  
Next, modify the build and push action to utilize these tags:  
  
```yaml
-
    name: Build and push Docker images
    uses: docker/build-push-action@v5.3.0
    with:
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
```  

### Behavior of GitHub workflow
[My DockerHub Repository Link](https://hub.docker.com/repository/docker/rdalless/ceg3120/general)

This workflow will when a tag is pushed to GitHub. First, the docker/meta-action grabs the git tag metadata. Next, the docker/login-action logs into my dockerhub account using the GitHub secrets variables. Finally, the docker/build-push-action builds the image and pushes it to DockerHub with the version tag (e.g. v1.1) and latest.

## 2. Deployment  

This [Cload Formation Template](./project5-cf.yml) automates creating an instance with docker installed, the docker image downloaded from dockerhub, a new container started, and the webhooks properly configured to trigger a pre-loaded deploy script.  

I will walk through setting this up manually below.  

[GitHub Actions & webhooks](https://levelup.gitconnected.com/automated-deployment-using-docker-github-actions-and-webhooks-54018fc12e32)  
[DockerHub & webhooks](https://blog.devgenius.io/build-your-first-ci-cd-pipeline-using-docker-github-actions-and-webhooks-while-creating-your-own-da783110e151)  

On an EC2 instance:



**pull and run a container from your DockerHub image**  

- Create a script to pull a new image from DockerHub and restart the container
    - put a copy of the script in a folder named deployment in your repo
- Set a listener / hook to receive messages using adnanh's webhook
- Create a hook - when a message is received run the container restart script
    - put a copy of the hook configuration in a folder named deployment in your repo
- Configure either GitHub or DockerHub to send a message to the listener / hook  

### How to install Docker to your instance

Please refer to [README-CI](./README-CI.md#how-to-install-docker--dependencies) for step by step instructions to installing docker on a linux instance.  

### Container restart script

```bash
#! /bin/bash

# Kill and delete old container process
docker stop webserv
docker system prune --force
# pull fresh image
docker pull rdalless/ceg3120:latest
# run new container
docker run -d -p 80:80 --name webserv --restart always rdalless/ceg3120:latest
```

The deploy script is called by webhook when DockerHub is pushed an new image. The script will stop and delete the currently running container, download the fresh image, then start a new container with the --restart flag ensuring it runs whenever the system is rebooted.  
  
The script is located in `/home/user/ubuntu/deploy.sh` 

### Setting up a webhook on the instance

On an ubuntu instance, webhook can simply be installed with `sudo apt install webhook`

- How to start the webhook
    - since our instance's reboot, we need to handle this

To configure the service to work on reboot, reference the service file at `/lib/systemd/system/webhook.service`:  

```bash
[Unit]
Description=Small server for creating HTTP endpoints (hooks)
Documentation=https://github.com/adnanh/webhook/
ConditionPathExists=/etc/webhook.conf

[Service]
ExecStart=/usr/bin/webhook -nopanic -hooks /etc/webhook.conf

[Install]
WantedBy=multi-user.target
```
The service is looking for a file `/etc/webhook.conf` on startup. This is the hooks definitions for the service. 

Create the file `/etc/webhook.conf` with the following text:  
```json
[
    {
    "id": "deploy",
    "execute-command": "/home/ubuntu/deploy.sh",
    "command-working-directory": "/home/ubuntu"
    }
]
``` 

webhook listens on `port 9000`. The following http request will trigger the webhook:  

`http://54.156.193.218:9000/hooks/deploy`  

deploy is the name of the id for the hook we have defined in webhook.conf that gets triggered when the http request is recieved. It executes our deploy script in /home/ubunut/deploy.sh

### How to configure DockerHub to message the listener

### Provide proof that the CI & CD workflow work

Proof was demonstrated in person

### Additional Resources 
[Stackoverflow - Cloudformation logging user-data](https://stackoverflow.com/questions/54906764/aws-cloudformation-userdata-issue)  
[Stackoverflow - Echo multiline string into file bash](https://stackoverflow.com/questions/39277019/echo-multiline-string-into-file-bash)  
[Linuxize - HereDoc](https://linuxize.com/post/bash-heredoc/)  

