# Elastic Demo

This is my demonstration of using elasticsearch with Rails.

## Elasticsearch

### Setup
The best way I've found to run with elasticsearch is with Docker.
* Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
* Sign up for [Docker Hub](https://hub.docker.com/) if you don't have an account
* Make sure you signed into docker hub once docker desktop is installed
* Pull the pre-built docker image: ```docker image pull sebp/elk:711```
* Build a container using the image: ```docker run -d -p 5601:5601 -p 9200:9200 -p 5044:5044 -it -e LOGSTASH_START=0 --name elk_demo sebp/elk:711```
* When you reboot, you can start the same image again: ```docker start elk_demo```

### Management
* List running docker containers: ```docker ps```
* List all docker containers: ```docker ps -a```
* Stop a running container: ```docker stop elk_demo```

### Web interfaces
* Elasticsearch: http://localhost:9200
* Kibana: http://localhost:5601

## Rails App

### Setup
* git clone git@github.com:briantgale/elastic_demo.git
* bundle install
* rails db:create db:migrate
* rails server
