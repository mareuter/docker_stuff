#!/bin/sh
if [ $# -lt 2 ]; then
  echo "Prints the command necessary to shrink a docker image."
  echo "Flattening an image destroys the metadata, so a file containing"
  echo "Dockerfile instructions can be provided to fixup the image."
  echo
  echo "Usage: docker_shrink.sh <tag to search> <tag for import> [file for Docker instructions]"
  exit 255
fi

search_tag=$1
rename_tag=$2

change=""
if [ ! -z "$3" ]; then
  while read line
  do
    change="${change} --change \"${line}\""
  done < $3  
fi

docker_container=$(docker ps -a | grep ${search_tag} | awk '{print $1}')
docker_export="docker export ${docker_container}"
docker_import="docker import${change} - ${rename_tag}"

echo "${docker_export} | ${docker_import}"
