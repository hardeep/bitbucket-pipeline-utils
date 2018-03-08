#! /bin/bash
set -e

PACKAGE_VERSION=$(cat package.json | grep version | head -1 | awk -F ':' '{ print $2}' | sed 's/[",]//g' | tr -d '[[:space:]]')

if [ -z "$PACKAGE_VERSION" ]; then
  echo "Could not parse package.json to extract version $(pwd)";
  exit 1;
fi

if [ -z "$ECR_REPOSITORY" ]; then
  echo "NO ecr repository defined.";
  exit 1;
fi

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "No AWS_ACCESS_KEY_ID or AWS_SECRET_ACCESS_KEY.";
  exit 1;
fi

IMAGE_EXISTS=$(aws ecr list-images --repository-name $ECR_REPOSITORY  | jq ".imageIds[] | select(.imageTag == \"$PACKAGE_VERSION\")")

if [ -n "$IMAGE_EXISTS" ]; then
  echo "Docker instance already exists. Skipping.";
else
  echo "The docker tag doesn't exist. Preparing docker instance.";
  docker build -t "$ECR_REPOSITORY:$PACKAGE_VERSION" $DOCKER_FILE
  $(aws ecr get-login --no-include-email)
  docker push "$ECR_REPOSITORY:$PACKAGE_VERSION"
fi

