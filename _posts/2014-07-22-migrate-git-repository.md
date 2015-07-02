---
layout: post
title : Git 원격 저장소 변경하기
category : git
tags : [git, github]
comments : true
redirect_from : /250/
disqus_identifier : http://blog.saltfactory.net/250
---

## 서론

git는 서버가 없어도 클라이언트에서 branch, tag, commit 등 형상을 관리할 수 있다. 뿐만 아니라 git-server를 만들어서 중앙에서 fetch, pull, push, merge등을 할 수 있기 때문에 여러 개발자가 서버 중심으로 버전이력을 업데이트할 수 있다. 가끔 서버없이 로컬에서 버전이력을 서버로 올려야하는 때나
또는 git-server에 clone을 받았다가 서버를 이전했을때 서버 저장소를 변경해야하는 경우가 있다. 이 두가지 경우에 대해서 설명하고자 한다.

<!--more-->

## 로컬에서 git를 사용하다가 서버로 업데이트하는 경우

git는 svn과 달리 서버가 없어도 내가 사용하는 로컬에서도 이력 관리를 할 수 있다. 이 기능은 매우 훌륭한데,
사내 네트워크에서 git으로 관리를 하다가 사내 네트워크를 벗어 나더라도 개인용 컴퓨터에서 관리하던 버전이력을 계속해서 버전을 관리할 수 있다.
다만 서버로 업데이트를 하지 않을 뿐 네트워크가 전혀되지 않은 곳에서도 이력을 관리할 수 있다. 그렇게 쌓인 이력은 다시 사내 네트워크 안에서 또는 https로 업데이트를 할 수 있다.

로컬에서 이력을 관리하는 것은 매무 간단하다. PC나 Mac에 git가 설치가 되어 있다면 `git init` 명령만으로 이력을 관리하는 리파지토리가 생성이 된다.

예를 들어서 ***GitDemoApp*** 이라는 프로젝트를 버전 관리를 한고 있었다고 생각해보자.
`git`를 기본적인 사용 방법은 이 포스팅에서 소개하지 않는다. `git`에 관한 기본적인 사용 방법은 쉽게 찾을 수 있을 것이다.

***GitDemoApp*** 이라는 디렉토리는 다음과 같은 구조를 하고 있다.
이 저장소의 *branch*는 **master**, **1.0-dev**, **2.0-dev** 를 가지고 있고 각각 *branch* 이름과 같은 `.txt` 파일을 가지고 있다.
예제이기 때문에 *master*와 각 *branch* 안의 내용을 다르게 했다.
![GitDemoApp](Screen Shot 2014-07-22 at 10.31.53 AM.png)

git는 이렇게 이력을 관리하는 디렉토리 안에 `.git/` 라는 디렉토리를 만들고 그 안에 git의 설정 정보를 저장한다.
`tree -a` 명령어로 현재 git로 관리한느 디렉토리 안의 내부를 살펴보자.
다음과 같이 git는 모든 정보를 `.git/` 디렉토리 안에 파일로 보관하고 있는 것을 확인할 수 있다.

```bash
$ tree -a
.
├── .git
│   ├── COMMIT_EDITMSG
│   ├── HEAD
│   ├── branches
│   ├── config
│   ├── description
│   ├── hooks
│   │   ├── applypatch-msg.sample
│   │   ├── commit-msg.sample
│   │   ├── post-update.sample
│   │   ├── pre-applypatch.sample
│   │   ├── pre-commit.sample
│   │   ├── pre-push.sample
│   │   ├── pre-rebase.sample
│   │   ├── prepare-commit-msg.sample
│   │   └── update.sample
│   ├── index
│   ├── info
│   │   └── exclude
│   ├── logs
│   │   ├── HEAD
│   │   └── refs
│   │       └── heads
│   │           ├── 1.0-dev
│   │           ├── 2.0-dev
│   │           └── master
│   ├── objects
│   │   ├── 0e
│   │   │   └── 45be1f8c87fc9962ef38e20a60215e4a571e61
│   │   ├── 1d
│   │   │   └── fe7101a2c7789f0442711cde34d4613717f230
│   │   ├── 24
│   │   │   └── afa7315a30e3d47614007664c69ce1a4d9e382
│   │   ├── 29
│   │   │   └── 86d4611d50689c04ed0ddad769dfe3a79f6b5a
│   │   ├── 49
│   │   │   └── f87f1119ba654eb5f80c4855a741ede43d89fa
│   │   ├── 5c
│   │   │   └── 07b34d5a3528024d167021d3aefbbd5490108e
│   │   ├── 7e
│   │   │   └── d1a6c1f41a1d0ad59272208ca26c4d2631ab91
│   │   ├── 7f
│   │   │   └── 2d4b65613cf3de8829315846071f166432e22b
│   │   ├── 87
│   │   │   └── 0c6fac0865629dc5a46a32750fc06d64a21799
│   │   ├── a4
│   │   │   └── 5dedacf4396d94876fa88a45bc08b5400486f3
│   │   ├── cf
│   │   │   └── 13b727f6a9cb8b5f8929f5382b9707dfc27c25
│   │   ├── e6
│   │   │   └── 9de29bb2d1d6434b8b29ae775ad8c2e48c5391
│   │   ├── info
│   │   └── pack
│   └── refs
│       ├── heads
│       │   ├── 1.0-dev
│       │   ├── 2.0-dev
│       │   └── master
│       └── tags
├── 2.0-dev.txt
└── README.md

25 directories, 36 files
```

`.git/` 디렉토리 내부에서 `config` 파일은 git의 설정 정보를 저장하는 파일이다. config 파일을 열어보자.
현재는 로컬에서만 git를 관리하기 때문에 원격저장소(또는 git-server)에 관한 설정이 보이지 않는다.

```
cat .git/config
```

```bash
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	ignorecase = true
	precomposeunicode = true
```

### 로컬 저장소에 원격저장소 추가하기

만약에 git-server의 저장소를 추가하고 싶으면 원격 저장소를 추가하고 난 다음 생성된 저장소 URI를 다음과 같이 `git remote add` 명령어를 사용해서 ***origin***으로 추가한다.
예를 들어 git-server의 원격저장소 URI가 *http://git.hibrainapps.net/hibrainnet/GitDemoApp*이라면 다음과 같이 추가한다.

```
git remote add origin http://git.hibrainapps.net/demo/GitDemoApp
```
위 명령어를 실행한 뒤 다시 `.git/config` 파일을 열어보자. 다음과 같이 ***origin*** 저장소가 원격저장소로 추가된 것을 확인할 수 있다.

```bash
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	ignorecase = true
	precomposeunicode = true
[remote "origin"]
	url = http://git.hibrainapps.net/demo/GitDemoApp
	fetch = +refs/heads/*:refs/remotes/origin/*
```

이제 로컬 저장소의 내용을 원격 저장소로 `push`를 해보자.
로컬저장소의 *branch*를 **master**로 변경한다.

```
git checkout master
```

그리고 우리가 원격저장소를 ***origin***으로 만들었기 때문에 ***origin***에 ***master***로 `push`를 한다.
```
git push origin master
```
이제 원격 저장소가 추가가 되었다. `git branch -a` 명령을 사용해서 원격격 저장소가 추가되었는지 확인할 수 있다.
![remote origin](Screen Shot 2014-07-22 at 3.33.51 PM.png)

### 로컬 저장소의 branch를 원격저장소에 추가하기
만약 로컬의 *branch*를 원격 저장소에 추가하고 싶을 때는 로컬 *branch*로 이동해서 `git push origin {branch}`로 하면 된다.

예로 **1.0-dev** branch를 원격 저장소에 추가하는 것을 살펴보면 다음 같다.
먼저 로컬의 branch로 이동한다.
```
git checkout 1.0-dev
```

그리고 `git push` 명령어를 사용한다.
```
git push origin 1.0-dev
```

`git branch -a`로 확인해보면 원격저장소에 **1.0-dev** branch가 추가된 것을 확인할 수 있다.
![remote branch](Screen Shot 2014-07-22 at 4.17.57 PM.png)

### --mirror 옵션을 사용하여 push 하기

만약 ***banch***가 많다고 할 경우 위와 같은 방법은 아주 귀찮은 일이 될 것이다.
그래서 로컬의 저장소를 그대로 원격 저장소로 보내는 방법이 바로 `--mirror`옵션을 사용하는 것이다.
```
git push --mirror http://git.hibrainapps.net/demo/GitDemoApp
```
미러를 마친 후 `git branch -a`로 모든 branch 를 확인하면 로컬에 가지고 있었던 branch가 모두 원격 저장소에 만들어진 것을 확인할 수 있다.
![mirror](Screen Shot 2014-07-22 at 4.35.53 PM.png)


## 기존에 사용하던 원격저장소에서 새로운 원격저장소로 변경할 경우

위에서 git에 관련된 모든 파일은 `.git/` 디렉토리 밑에 파일로 저장 된다고 말했다. 그리고 원격저장소에 관한 정보는 `.git/config`에 추가된다고 살펴보았다.
만약 기존에 원격저장소를 추가하고 사용하고 있었는데 원격저장소가 변경이 되었다고 가정해보자.

> 기존의 원격 저장소는  git@git.hibrainapps.net:GitDemoApp.git 이였는데, 이것을 새로운 저장소인 http://saltfactory@git.hibrainapps.net/demo/GitDemoApp 로 변경할 때는 다음과 같은 절차를 따라 원격 저장소를 변경한다.


아마 기존에 저장소를 사용하고 있을 경우 `.git/config` 파일을 열면 다음과 같이 되어 있을 것이다.

```bash
[core]
        repositoryformatversion = 0
        filemode = true
        logallrefupdates = true
        ignorecase = true
        precomposeunicode = true
[remote "origin"]
        url = git@git.hibrainapps.net:GitDemoApp.git
        fetch = +refs/heads/*:refs/remotes/origin/*
```
원격 저장소가 변경되면 ***origin***의 `url`을 새로운 원격저장소 URI로 변경한다.

```bash
[core]
        repositoryformatversion = 0
        filemode = true
        logallrefupdates = true
        ignorecase = true
        precomposeunicode = true
[remote "origin"]
        url = http://git.hibrainapps.net/demo/GitDemoApp
        fetch = +refs/heads/*:refs/remotes/origin/*
```

그리고 새롭게 추가한 원격 저장소로 `push`를 진행한다.
```
push remote origin master
```

그리고 나머지 모든 *branch*를 저장소에 저장하고 싶을 경우는 위에서 살펴보았던 `--mirror`를 사용해서 새로운 원격저장소에 저장을 한다.

### 이미 새로운 원격저장소에 다른 유저가 소스코드를 push한 상태일 경우

만약 한 프로젝트에서 A,B 유저가 함께 소스를 공유하고 사용하고 있었을 경우를 살펴보자.
A 유저가 새로운저장소에 이미 소스코드를 새로운 원격저장소인 http://git.hibrainapps.net/demo/GitDemoApp에 `push --mirror` 실행한 상태라면,
같은 소스를 로컬에 가지고 있었는 B 사용자는 `.git/config` 파일을 열어서 ***origin*** 의 url만 새로운 원격저장소의 URI인 http://git.hibrainapps.net/demo/GitDemoApp 변경하고
`fetch`, `pull`, `push` 등 원격저장소 명령어를 사용하면 된다.

```bash
[core]
        repositoryformatversion = 0
        filemode = true
        logallrefupdates = true
        ignorecase = true
        precomposeunicode = true
[remote "origin"]
        url = http://git.hibrainapps.net/demo/GitDemoApp
        fetch = +refs/heads/*:refs/remotes/origin/*
```


## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
