#! /bin/bash
set -e

PACKAGE_VERSION=$(cat package.json | grep version | head -1 | awk -F ':' '{ print $2}' | sed 's/[",]//g' | tr -d '[[:space:]]')

if [ -z "$PACKAGE_VERSION" ]; then
  echo "Could not parse package.json to extract version $(pwd)";
  exit 1;
fi

echo "Checking if tag=$PACKAGE_VERSION exists."
if [ ! -z $(git tag -l | grep $PACKAGE_VERSION) ];
  then echo "Tag found exiting";
    exit 0;
else 
  echo "Package version $PACKAGE_VERSION not already tagged."
  echo "Creating build."
  npm run build
  echo "Creating Release $PACKAGE_VERSION"
  git add .
  if [ -d "./dist" ]; then
    echo "Found ./dist folder. Force adding."
    git add -f ./dist
  fi
  if [ -d "./typings" ]; then
    echo "Found ./typings folder. Force adding."
    git add -f ./typings
  fi
  git commit --allow-empty -m "[skip ci] Harvesting release $PACKAGE_VERSION"
  git tag $PACKAGE_VERSION
  git push --tags origin master
  git pull --rebase origin development
  git push origin master:development
  echo "Created Release $PACKAGE_VERSION"
fi
