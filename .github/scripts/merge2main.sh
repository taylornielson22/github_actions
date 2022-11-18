set -x

echo "performing git setting"
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --global user.name "GitHub Actions"
git config --global user.email $GIT_EMAIL
git remote add origin https://token:$GIT_TOKEN@github.com/git 

echo "fetching tags"
git fetch --tags origin

echo "checking out production "
git checkout origin/prod
git pull

echo "pushing changes from qa-accept sha to production"
git merge qa-accept -m 'Automated Merge Process: Triggered by qa-accept tag on master'
git remote set-url --push origin "https://token:$GIT_TOKEN@github.com/$GITHUB_REPOSITORY.git"
git push --set-upstream origin prod
