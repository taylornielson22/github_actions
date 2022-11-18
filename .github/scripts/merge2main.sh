set -x

echo "performing git setting"
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --global user.name "GitHub Actions"
git config --global user.email $GIT_EMAIL
git remote add origin https://token:$GIT_TOKEN@github.com/$GITHUB_REPOSITORY.git 
echo "fetching tags"
git fetch --tags origin


echo "checking out production "
git checkout -B origin/prod origin/prod

echo "pushing changes from qa-accept sha to production"
git merge qa-accept --no-ff -m 'Automated Merge Process: Triggered by qa-accept tag on master'
git remote set-url --push origin "https://token:$GIT_TOKEN@github.com/$GITHUB_REPOSITORY.git"
git push --force-with-lease origin origin/prod:prod

