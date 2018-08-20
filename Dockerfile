FROM node:8.9.3


COPY ./release.sh /usr/bin/git-release
COPY ./build-ecs-docker-instance.sh /usr/bin/build-ecs-docker-instance

RUN apt-get update && apt-get install -y build-essential libssl-dev jq unzip python-pip libpython-dev rsync
RUN chmod +x /usr/bin/git-release
RUN chmod +x /usr/bin/build-ecs-docker-instance
RUN pip install awscli

