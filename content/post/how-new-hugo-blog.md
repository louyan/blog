---
title: "使用Hugo搭建静态个人博客"
author: "louyan"
categories: ["博客"]
tags: ["hugo",]
date: 2019-01-19T04:40:54+08:00
draft: false
---

使用Hugo搭建静态个人博客,源码和网站内容分开。

<!--more-->

### 从您的`gh-pages`分支部署项目页面[ ](https://gohugo.io/hosting-and-deployment/hosting-on-github/#deployment-of-project-pages-from-your-gh-pages-branch)

您还可以告诉GitHub页面将您的`master`分支视为已发布的站点或指向单独的`gh-pages`分支。后一种方法有点复杂但有一些优点：

- 它将您的源和生成的网站保存在不同的分支中，因此维护两者的版本控制历史记录。
- 与前面的`docs/`选项不同，它使用默认`public`文件夹。

#### `gh-pages`分支机构的筹备工作[ ](https://gohugo.io/hosting-and-deployment/hosting-on-github/#preparations-for-gh-pages-branch)

这些步骤只需要完成一次。替换`upstream`为遥控器的名称; 例如`origin`：

##### 添加`public`文件夹

首先，将`public`文件夹添加到`.gitignore`项目根目录下的文件中，以便在主分支上忽略该目录：

```
echo "public" >> .gitignore
```

##### 初始化您的`gh-pages`分支

您现在可以将`gh-pages`分支初始化为空的[孤立分支](https://git-scm.com/docs/git-checkout/#git-checkout---orphanltnewbranchgt)：

```
git checkout --orphan gh-pages
git reset --hard
git commit --allow-empty -m "Initializing gh-pages branch"
git push upstream gh-pages
git checkout master
```

#### 构建和部署[ ](https://gohugo.io/hosting-and-deployment/hosting-on-github/#build-and-deployment)

现在使用git的[worktree功能](https://git-scm.com/docs/git-worktree)将`gh-pages`分支检入您的`public`文件夹。本质上，worktree允许您在不同的目录中检出同一本地存储库的多个分支：

```
rm -rf public
git worktree add -B gh-pages public upstream/gh-pages
```

使用该`hugo`命令重新生成站点并在`gh-pages`分支上提交生成的文件：

commit-gh-pages-files.sh

```sh
hugo
cd public && git add --all && git commit -m "Publishing to gh-pages" && cd ..
```

如果本地`gh-pages`分支中的更改看起来没问题，请将它们推送到远程仓库：

```
git push upstream gh-pages
```

##### 设为`gh-pages`您的发布分支

要将`gh-pages`分支用作发布分支，您需要在GitHub UI中配置存储库。一旦GitHub意识到你已经创建了这个分支，这可能会自动发生。您也可以在GitHub项目中手动设置分支：

1. 转到**设置** → **GitHub页面**
2. 从**Source中**，选择“gh-pages branch”，然后选择**Save**。如果未启用该选项，您可能尚未创建分支，或者您尚未将分支从本地计算机推送到GitHub上的托管存储库。

片刻之后，您将在GitHub页面上看到更新的内容。