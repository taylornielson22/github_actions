#!/usr/bin/env sh
# This script acts as an entrypoint to cfl-doxygen
set -x
export GIT_EMAIL="nielson.taylorm@gmail.com"

echo "performing git setting"
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --global user.name "GitHub Actions"
git config --global user.email $GIT_EMAIL
git remote add origin https://token:$GIT_TOKEN@github.hpe.com/$GITHUB_REPOSITORY.git

echo "fetching tags"
git fetch --tags origin

echo "checking out production "
git checkout --track origin/prod

echo "pushing changes from qa-accept sha to production"
git merge qa-accept --no-ff -m 'Automated Merge Process: staging merge to production'
git remote set-url --push origin "https://token:$GIT_TOKEN@github.hpe.com/$GITHUB_REPOSITORY.git"
git push origin prod


echo "Updating patch version on master branch"
git checkout origin main
echo "hi" > hi.txt
git push https://token:$GIT_TOKEN@github.hpe.com/$GITHUB_REPOSITORY.git