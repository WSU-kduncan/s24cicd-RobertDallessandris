# Project 4: CI -> CD  
Robert D'Allessandris  
CEG 3120  
Spring 2024  

## CI Project Overview 
  
What are you doing, why, and what tools?  

## Run Project Locally  
  
### How to install docker + dependencies  

Instructions for installing the `Docker Engine` are in the [Docker Docs](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
- *Note: These instructions were run on Ubuntu 23.10*
- You may find references to an apt package named docker.io which is unofficial. It may be installed simply with `sudo apt install docker.io`. However your best bet would be to follow the official installation instructions on the Docker Docs for the most up to date version and official support.


After installing the Docker Engine, Follow these [instructions](https://docs.docker.com/desktop/install/ubuntu/) to install `Docker Desktop`
- If you are trying to install Docker Desktop and get the following error:
    ```
    The following packages have unmet dependencies:
    docker-desktop : Depends: docker-ce-cli but it is not installable
    E: Unable to correct problems, you have held broken packages.
    ```
    It means you have not installed the Docker Engine yet  
### How to build an image from the Dockerfile

[Docker Docs - image build](https://docs.docker.com/reference/cli/docker/image/build/)  

The docker file:
```docker
FROM httpd:2.4

COPY ./website/ /usr/local/apache2/htdocs/
```
Run the following command to build the image: 
```shell
docker build -t project4-apache-server .
```
  
### How to run the container  
  
### How to view the project running in the container
