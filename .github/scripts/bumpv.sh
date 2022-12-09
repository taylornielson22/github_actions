set -x

echo "performing git setting"
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --global user.name "GitHub Actions"
git config --global user.email "$GIT_EMAIL"
git remote add origin https://token:$GIT_TOKEN@github.com/$GITHUB_REPOSITORY.git 

echo "Updating patch version on master branch"
git checkout -f master
echo "$VER_TYPE"
git push -f origin master
echo "$GIT_EMAIL"
#bump2version patch
touch bump.txt
git add bump.txt
git commit -m "Bump Version"

git push -f origin main
