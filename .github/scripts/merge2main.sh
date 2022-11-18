set -x

echo "performing git setting"
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --global user.name "GitHub Actions"
git config --global user.email $GIT_EMAIL
git remote add origin https://token:$GIT_TOKEN@github.com/$GITHUB_REPOSITORY.git 

echo "fetching tags"
git fetch --tags origin

echo "update master if needed"
git checkout -f main
git merge --strategy-option ours origin/prod
git push origin main

echo "checking out prod"
git checkout prod

echo "pushing changes from qa-accept sha to production"
git merge qa-accept --no-ff -m 'Automated Merge Process: Triggered by qa-accept tag on master'
git remote set-url --push origin "https://token:$GIT_TOKEN@github.com/$GITHUB_REPOSITORY.git"
git push origin prod

echo "Updating patch version on master branch"
git checkout main
#bump2version patch
echo "hello" > hi.txt
git commit hi.txt -m "test"

git push -u origin main
