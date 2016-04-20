---
layout: post
title: brew update 명령에서 The following untracked working tree files 문제 해결
category: mac
tags: [brew, update, error]
comments: true
redirect_from: /213/
disqus_identifier : http://blog.saltfactory.net/213
---

homebrew는 Mac에서 설치되지 않은 Unix 패키지를 관리하기 위한 툴로 맥 운영체제로 개발 연구하는 사람들에게 가장 인기 있는 툴 중에서 하나이다. 좀더 자세한 글은 [Homebrew를 이용하여 Mac OS X 에서 Unix 패키기 사용하기](http://blog.saltfactory.net/109)를 참고하자. MariaDB를 homebrew를 이용해서 설치하려고 그동안 homebrew 를 업데이트를 한 적이 없어서 업데이트를 하는데 다음과 같은 에러를 보이면서 업데이트가 되지 않는 문제가 발생했다.

<!--more-->

```
brew update
```

```
error: The following untracked working tree files would be overwritten by merge:
	Library/Formula/cmigemo.rb
Please move or remove them before you can merge.
Aborting
Error: Failure while executing: git pull -q origin refs/heads/master:refs/remotes/origin/master
```

brew의 저장소에 관련된 문제가 발생한 것이기 때문에 git의 정보를 변경해줘야한다. brew는 /user/local 에 Cellar라는 git 저장소를 clone하는데 git 정보를 변경하기 위해서 /usr/local로 이동을 한다.

```
cd /usr/local
```

그리고 git fetch를 하여 homebrew의 최신 header 정보를 받아온다.

```
git fetch origin
```

다음은 git의 master에 대한 정보를 강제로 reset를 시켜준다.

```
git reset --hard origin/master
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/1d46db9e-cacf-49eb-b363-7b2cac80af55)

이제 homebrew를 git 저장소로부터 소스를 받아와서 업데이트를 할 준비를 모두 마쳤다. brew update로 최신 homebrew로 업데이트르 실행하면 된다.

```
brew update
```

## 참고

1. http://stackoverflow.com/questions/10762859/brew-update-the-following-untracked-working-tree-files-would-be-overwritten-by


