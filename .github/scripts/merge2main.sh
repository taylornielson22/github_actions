#!/usr/bin/env sh
# This script acts as an entrypoint to cfl-doxygen
set -x
export GIT_EMAIL="nielson.taylorm@gmail.com"

echo "performing git setting"
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --global user.name "GitHub Actions"
git config --global user.email $GIT_EMAIL
git remote set-url origin https://x-access-token:$GIT_TOKEN@github.hpe.com/$GITHUB_REPOSITORY.git
git remote add fork https://x-access-token:$GIT_TOKEN@github.hpe.com/$GITHUB_REPOSITORY.git

echo "fetching tags"
git fetch --tags origin
git fetch fork prod

echo "checking out production "
git checkout -b fork/prod fork/prod

echo "pushing changes from qa-accept sha to production"
git merge qa-accept -m 'Automated Merge Process: staging merge to production'
git push --force-with-lease fork fork/prod:prod


echo "Updating patch version on master branch"
git checkout origin main
echo "hi" > hi.txt
git add -A
git commit -m "hi"
git push https://token:$GIT_TOKEN@github.hpe.com/$GITHUB_REPOSITORY.git