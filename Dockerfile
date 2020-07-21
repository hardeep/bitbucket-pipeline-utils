FROM node:12.14.1


COPY ./release.sh /usr/bin/git-release
COPY ./hotfix.sh /usr/bin/git-release-hotfix
COPY ./build-ecs-docker-instance.sh /usr/bin/build-ecs-docker-instance

RUN apt-get update && apt-get install -y build-essential libssl-dev jq unzip python-pip libpython-dev rsync
RUN chmod +x /usr/bin/git-release
RUN chmod +x /usr/bin/build-ecs-docker-instance
RUN chmod +x /usr/bin/git-release-hotfix
RUN pip install awscli

