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

# 清空本地缓存
# git rm --cached $(git ls-files)

# git remote add origin https://github.com/louyan/blog.git
# 如果首次运行，需要先add一下，
# git subtree add -P public origin gh-pages --squash
# git subtree pull -P public origin gh-pages
# git subtree push -P public origin gh-pages

# 如果要删除远程分支
# git push origin --delete gh-pages

# Build the project. 
hugo # if using a theme, replace by `hugo -t <yourtheme>`

# 把自定义域名加入CNAME中，添加 CNAME 文件到你的存储库中.
echo yannotes.cn > public/CNAME

# Add changes to git.
git add -f public

# Commit changes.

git commit -m "$msg"

# Push source and build repos.
git subtree push -P public origin gh-pages