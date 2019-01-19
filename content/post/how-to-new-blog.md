---
title: "Hugo搭建博客，用gh-pages分支部署页面"
author: "lou'yan"
categories:
    - "hugo"
tags: ["hugo", "subtree"]
date: 2019-01-19T21:40:45+08:00
draft: false
---

将Hugo部署为GitHub Pages项目或个人/组织站点，并使用简单的shell脚本自动完成整个过程。

GitHub通过其[GitHub Pages服务](https://help.github.com/articles/what-is-github-pages/)直接从GitHub存储库为个人，组织或项目页面提供基于SSL的免费和快速静态托管。

关于详细的hugo建博客过程，前往我在掘金的文章：[Hugo -最好用的静态网站生成器](https://juejin.im/post/5c02c03af265da616a4766e5)

本文的重点在源码和hugo后生成的页面分开部署，便于管理等

<!--more-->

## 场景：

在搭建博客过程中有这样的需求，想把hugo后生产的public里的文件分别管理，部署在一个master分支，看着不爽(于是折腾，强迫症犯了 ：呲牙>)。经过一番折腾，发现可以用subtree解决。

>  git subtree

相信大部分人和我一样，只会git add ，push，pull之类的，对subtree概念模糊，很少用到。

把一个项目作为子项目，在多个项目中共享&维护。

**栗子**：

假设你有一个在线商城项目 `Shop`，这个项目下有个订单模块 order，这个 `order `模块很通用，你在下一个团购系统 `Groupon`，也要用到这个 order 模块，最简单的方式就是把整个 order 模块 copy 过来。

然而，这种 copy 方式，会很难维护：order 模块修改了一个Bug，然后又要复制更新到所有用了 order 模块的项目里。

 这时就需要 `git subtree`来管理这个 order 模块了：把 order 模块单独作为一个 git 仓库，在需要用到 order 模块的项目，通过使用 `git subtree`把 `order`模块当作一个 git 项目来引入，这就解决了 `order` 模块的共享和维护问题。

## 相关命令

`git subtree --help` 可以查看 `git subtree` 命令的帮助文档。

`git subtree` 命令中，都会用到一个参数 `--prefix=<prefix>`，可以简写成 `-P <prefix>`，本文的命令都是这样使用的。

- 添加远程仓库：

**git remote add origin https://github.com/louyan/blog.git**

### git subtree add 添加项目作为子树

> git subtree add -P <子树名> <子仓库地址> <分支>

执行以上命令后，项目下就会新创建一个名为` <子树名> `的目录。

如果提前使用` git remote add <子仓库名> <子仓库地址> `添加了子项目的远程仓库地址（建议按此方式，下文都基于此），那么也可以这样：

>  git subtree add -P <子树名> <子仓库名> <分支>

以上命令可以多加一个 `--squash `参数：

>  git subtree add -P <子树名> <子仓库名> <分支> --squash

`--squash` 参数含义是：把 `subtree` 的改动合并成一次`commit`，这样就不用拉取子项目完整的历史记录。

### git subtree pull 从子仓库拉取子树更新
先 `fetch`：

> git fetch <子仓库名> <分支>

后 `pull`：

> git subtree pull -P <子树名> <子仓库名> <分支>

以上命令也可以多加一个 `--squash `参数：

> git subtree pull -P <子树名> <子仓库名> <分支> --squash

`--squash `参数含义同上。

### git subtree push 推送子树更新到子仓库

> git subtree push -P <子树名> <子仓库名> <分支>



## 部署

把源码和文章更新到master分支上。

**Push Hugo content** 

> git add -A
> git commit -m "$msg"
> git push origin master



把public页面内容更新到gh-pages分支上，public作为子树推送。

- **step 1**

  把public 目录添加到 subtree:

  > ```github
  > git add public 
  > git commit -m "Initial dist subtree commit"
  > ```

- **step 2**

  用 subtree 将 dist 目录推送到 gh-pages 分支:

  > git subtree push -P public origin gh-pages

### 自动化部署

完整过程：deploy.sh

```github
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
echo "yannotes.cn" >> CNAME

# Add changes to git.
git add -f public

# Commit changes.

git commit -m "$msg"

# Push source and build repos.
git subtree push -P public origin gh-pages

```



新建文章：**hugo new post/XXXX.md**，

本地浏览：**hugo server  -D** , 

(***注意**：正式发布时，draft: false，为true时是草稿，不会发布。)

确认无误后，然后cmd中执行脚本**deploy.sh  " commit msg"**

commit msg：替换为你需要写的提交信息，默认为日期信息

~ End  