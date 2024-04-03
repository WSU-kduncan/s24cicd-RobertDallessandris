# Project 5  
Robert D'Allessandris  
CEG 3120  
Spring 2024  

## CD Project Overview  
**Project Due Friday April 19th**  

**TODO** 
- what are you doing, why, what tools.
- Include a diagram of the continuous deployment process. A good diagram will label tools used and how things connect. 


## 1. Semantic Versioning  
**Milestone Due Friday April 5th**  

[Semantic Versioning](https://semver.org/)  
[Github Actions - Docker metadata](https://github.com/docker/metadata-action)  
[Docker Docs - Manage tags/labels with GitHub actions](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/)  

- Link to Docker Hub repository  

#### How to generate a tag in git / GitHub
- Amend your GitHub Action workflow to:
    - run when a tag is pushed
    - use the docker/metadata-action to generate a set of tags from your repository
    - push images to DockerHub with an image tags based on your git tag version AND latest
- Behavior of GitHub workflow


## 2. Deployment  
**Milestone Due Monday April 15th**  

[GitHub Actions & webhooks](https://levelup.gitconnected.com/automated-deployment-using-docker-github-actions-and-webhooks-54018fc12e32)  
[DockerHub & webhooks](https://blog.devgenius.io/build-your-first-ci-cd-pipeline-using-docker-github-actions-and-webhooks-while-creating-your-own-da783110e151)  

For this piece, use an EC2 instance.

- Install docker on the instance
- pull and run a container from your DockerHub image
    - confirm you can access your service running in the container from a browser
- Create a script to pull a new image from DockerHub and restart the container
    - put a copy of the script in a folder named deployment in your repo
- Set a listener / hook to receive messages using adnanh's webhook
- Create a hook - when a message is received run the container restart script
    - put a copy of the hook configuration in a folder named deployment in your repo
- Configure either GitHub or DockerHub to send a message to the listener / hook  

#### How to install Docker to your instance

#### Container restart script
- Justification & description of what it does
- Where it should be on the instance (if someone were to use your setup)  

#### Setting up a webhook on the instance
- How to install adnanh's webhook to the instance
- How to start the webhook
    - since our instance's reboot, we need to handle this
- webhook task definition file
    - Description of what it does
    - Where it should be on the instance (if someone were to use your setup)

#### How to configure GitHub OR DockerHub to message the listener

#### Provide proof that the CI & CD workflow work

1. starting with a commit that is a change, taging the commit, pushing the tag
2. Showing your GitHub workflow returning a message of success.
3. Showing DockerHub has freshly pushed images.
4. Showing the instance that you are deploying to has the container updated.

Proof can be provided by either demonstrating to me in person OR by creating a video of the process. If you go the video route and your file is too large for GitHub, submit it to the "Project 5 - Proof of Flow" Dropbox on Pilot



