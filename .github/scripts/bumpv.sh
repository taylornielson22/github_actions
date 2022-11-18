set -x

echo "performing git setting"
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --global user.name "GitHub Actions"
git config --global user.email $GIT_EMAIL
git remote add origin https://token:$GIT_TOKEN@github.com/$GITHUB_REPOSITORY.git 

git fetch origin 

echo "Updating patch version on master branch"
git checkout -f main

#bump2version patch
touch the.txt
git add the.txt
git commit -m "Bump Version"

git push origin main
 