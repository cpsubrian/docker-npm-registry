docker-npm-registry
===================

A private npm registry based on Docker and Kappa.

## About

Use this project if you want your own private npm registry without cloning the complete official npm registry database.
See the [Kappa](https://github.com/paypal/kappa) project for more details how this is realized.

## Configuration & Usage

You need a Linux machine with Docker installed. See the [Docker website](http://www.docker.io/) for more details.

Fork this repository to make your changes or clone this repository and make your changes directly.

In the file `Dockerfile`, update the variables on lines 9-11 to reflect your own.

On your machine that has Docker installed, run the following commands:

	git clone https://github.com/jwvdiermen/docker-npm-registry
	cd docker-npm-registry
	# Edit Dockerfile if necessary, especially the NPM_VHOST variable.
	# sed -i 's/npm\.justdeploy\.eu/npm.example.com/g' Dockerfile
	# sed -i 's/your_secret_password/something_more_secure/g' Dockerfile
	docker build -rm -t=software/npm-registry . 
	docker run -name npm-registry-data software/npm-registry true

Now you can start the registry with the following command:

	docker run -d -p 80:80 -volumes-from npm-registry-data software/npm-registry

It is probably a good idea to run a reverse proxy in front of your Docker host if you're running multiple webservice containers
and you want to keep them available on port 80.

If you want to run the repository on a different port (e.g. 8080), change the first number in the command:

	docker run -d -p 8080:80 -volumes-from npm-registry-data software/npm-registry

## Using the registry with the npm client

With the setup so far, you can point the npm client at the registry by
putting this in your `~/.npmrc` file:

    registry = http://npm.example.com/

You can also set the npm registry config property like:

    npm config set registry http://npm.example.com/

Or you can simple override the registry config on each call:

    npm --registry http://npm.example.com/ install <package>

Don't forget to add the port number if you're not running on port `80`.
