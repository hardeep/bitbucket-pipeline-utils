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
  echo "Tagging package version $PACKAGE_VERSION."
  git commit --allow-empty -m "[skip ci] 🚀 Harvesting release $PACKAGE_VERSION"
  git tag $PACKAGE_VERSION
  git push --tags origin master-hotfix
  echo "Created Release $PACKAGE_VERSION"
fi
