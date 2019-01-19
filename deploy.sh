#!/bin/bash
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi

# Push Hugo content 
git add -A
git commit -m "$msg"
git push origin master

git remote add origin https://github.com/louyan/blog.git
git subtree add -P public origin gh-pages --squash
# git subtree pull -P public origin gh-pages
# git subtree push -P public origin gh-pages

# Build the project. 
hugo # if using a theme, replace by `hugo -t <yourtheme>`

# Go To Public folder
# cd public
# Add changes to git.
git add public

# Commit changes.

git commit -m "$msg"

# Push source and build repos.
git subtree push -P public origin gh-pages

