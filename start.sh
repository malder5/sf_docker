#!/usr/bin/env sh
cd terraform
terraform init
terraform apply
cd ../ansible
ansible-playbook docker.yml
ansible-playbook postgres.yml
ansible-playbook database.yml
# дальше работа с докером.
docker build -t sf_docker.
docker -d -p 80:80 --name sf_docker_app --mount type=volume,dst=/var/lib/postgresql/14/main sf_docker