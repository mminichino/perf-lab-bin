#!/bin/sh

for id in $(docker ps -a |grep -v CONTAINER|awk '{print $1}'); do docker stop $id ; done
for id in $(docker ps -a |grep -v CONTAINER|awk '{print $1}'); do docker rm $id ; done
for image in $(docker images |grep -v REPOSITORY|awk '{print $3}'); do docker rmi -f $image ; done
