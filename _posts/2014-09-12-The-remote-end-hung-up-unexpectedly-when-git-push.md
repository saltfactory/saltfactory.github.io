---
layout: post
title : Nginx와 git 연동 시 The remote end hung up unexpectedly 에러 문제 해결
category : nginx
tags : [nginx, git]
comments : true
redirect_from : /262/
disqus_identifier : http://blog.saltfactory.net/262
---

## 서론

Nginx와 git 연동 시 `git push` 명령어를 실행할 때, **The remote and hung up unexpectedly** 라는 에러를 보여주면서 `git push`가 정상적으로 동작하지 않는 문제를 만날 수 있다. 이것은 NginX에서 POST의 크기의 제한 때문에 발생하는 문제이다.
Nginx의 문제를 파악하고 NginX의 설정을 변경하여 이 문제를 해결하는 방법에 대해서 알아본다.

<!--more-->

## git push 에러 발생

우리는 [Yobi](http://yobi.io)와 [NGINX](http://nginx.com/)를 연동하여 사용하고 있다. 이전 포스팅에서 소개했지만, 우리는 다양한 리눅스 서버에 운영될 수 있는 환경을 구축하기 위해서 [Docker](https://docker.com/)를 사용하여 [saltfactory/yobi](https://github.com/saltfactory/docker-yobi)와 [saltfactory/nginx](https://github.com/saltfactory/docker-nginx) 이미지를 만들어서 git를 운영하고 있다. yobi는 ssh로 git를 사용하는 것 대신에 http로 git를 쉽게 사용할 수 있게 지원해주고 있다. 사내에서 http 포트만 외부에서 사용할 수 있는 우리 연구소에서 yobi를 선택했던 가장 큰 이유중에 하나가 http로 git를 사용할 수 있다는 것이였다. 우리는 http 서비스의 빠른 응답속도와 확장성을 위해서 웹 서버로 NGINX를 선택했고 이것을 yobi와 연동하여 사용하고 있다.

프로젝트 소스코드를 원격 리파지토리에 저장해서 서버에서 병합하는 방법을 취하고 있는데 어느날 갑자기 로컬에서 작업하여 이력을 관리한 `commit`들이 다음과 같이 ***The remote end hung up unexpectedly*** 에러를 발생하면서 서버의 원격 리파지토리에 `push`가 되지 않는 것이다.

```
Counting objects: 19, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (5/5), done.
Writing objects: 100% (5/5), 1.27 MiB | 0 bytes/s, done.
Total 5 (delta 2), reused 0 (delta 0)
error: RPC failed; result=22, HTTP code = 413
fatal: The remote end hung up unexpectedly
fatal: The remote end hung up unexpectedly
Everything up-to-date
```

하지만 `fetch`와 `pull` 과 같은 리모트 명령어들은 정상적으로 동작하고 있었다. 그래서 우리는 서버에서 nginx의 로그를 살펴보기로 했다.


## NGINX 에러 발생

Docker로 구성한 서버 환경에서 우리는 NGINX의 로그를 VOLUME으로 마운트시킨 디렉토리 파일에서 로그를 바로 확인할 수 있었다. 클라이언트에서 `git push`를 요청할 때마다 다음과 같이 ***client intended to send too large body***  에러가 로그에 남는 것을 확인했다.

```
2014/09/12 01:38:50 [error] 11#0: *155 client intended to send too large body: 1326741 bytes, client: 클라이언트 아이피, server: 서버네임, request: "POST /프로젝트명/git-receive-pack HTTP/1.0", host: "호스트네임"
```

위 에러는 **POST** request를 요청할 때 서버에서 처리할 수 있는 body의 사이즈보다 큰 요청이 들어오면 생기는 에러이다. 그래서 우리는 NGINX의 설정값을 수정하기로 했다.

## client\_max\_body\_size 수정

NGINX에서 클라이언트에서 요청하는 body의 사이즈를 설정하는 옵션은 **client\_max\_body\_size** 이다. 우리는 yobi를 docker에서 운영하기 때문에 서버에 직접 들어가서 수정하지 않고, *VOLUME*으로 마운트 시키는 디렉토리 안의  `yobis-site.conf` 파일을 다음과 같이 수정했다.

```
client_max_body_size 1000M;

upstream yobi-upstream {
  server  서버네임:9000;
}

server {
  listen 80;
  server_name 서버네임;
}
... 생략
```

Ubuntu에 설치되는 NGINX는 `/etc/nginx/nginx.conf` 설정 파일을 가지고 있고 그 파일 안에서 외부 설정 파일들을 로드시키는데 우리는 Docker를 설정할 때 `/site-enabed/*.conf` 파일들을 로드시키도록 지정하였다.

```
http {
... 생략 ...
include /etc/nginx/sites-enabled/*;
... 생략 ...
}
```

NGINX의 각 설정파일은 `http` 설정 안에 포함이 되도록 설정되어 있다. **client\_max\_body\_size** 설정은 **http** 설정 안에 지정되어야 하기 때문에 위의 `yobi-site.conf`의 첫번째 라인에 바로 이 값을 설정하도록 한 것을 유의해야한다. 설정이 끝나면 NGINX을 다시 제시작 한다. 우리는 docker를 사용했기 때문에 `docker start` 명령어로 재시작을 했다.

```
sudo docker start nginx
```

다시 클라이언트에 돌아가서 `git push` 명령을 실행하면 문제 없이 원격 리파지토리에 commit들이 모두 push 되는 것을 확인할 수 있을 것이다.

## 결론

git는 로컬에서 뿐만 아니라 원격 저장소에서 소스코드 형상관리를 할 수 있다. 사내 망 내부가 아닌 경우 http를 이용해서 git를 사용할 경우 접근도가 높아진다. http로 git 환경을 만드는 것은 그렇게 쉬운 일은 아니다. 하지만 yobi를 사용하면 복잡한 git를 http로 사용할 수 있는 환경을 쉽게 구축할 수 있다. http 서비스의 성능과 확장성을 위해서 [Play framework](http://playframework.com)을 단독으로 웹 서버로 사용하는 것 보다 NGINX나 Apaach와 같은 웹 서버를 함께 사용하는 것이 좋다. 하지만 git를 http로 사용할 때 한가지 기억해 둬야할 것이다. **HTTP로 git의 commit을 전송할 때 POST로 전송이 되며, 웹 서버는 POST의 body 사이즈를 제한하고 있다**다는 것이다. 즉, 더 큰 사이즈의 데이터를 HTTP의 POST로 전송하기 위해서는 웹 서버의 **HTTP POST body** 설정을 변경해야한다. 우리가 겪은 문제도 동일한 문제이다. 하이브리드 어플리케이션 개발을 하는 프로젝트에서 commit하고 push하는 데이터량이 많아져서 NGINX에서 기본적으로 설정한 HTTP POST 사이즈보다 커서 원격 저장소에 정상적으로 업데이트 정보를 전송하지 못하는 문제를 갖게 되었다. 우리는 NGINX 웹 서버를 사용하고 있었고 Docker를 사용해서 nginx의 설정파일을 외부 디렉토리에서 VOLUME으로 마운트시켜서 사용하고 있었기 때문에 설정파일에 **client\_max\_body\_size**의 값을 변경하여 이 문제를 해결했다.

git와 HTTP를 연동하여 사용한다면 반드시 HTTP POST body의 사이즈를 결정하는 옵션을 한번 더 체크해보기 바란다. 이 부분을 간과하고 넘어간다면 언젠가 큰 소스코드를 한번에 push 할 때  'fatal: The remote end hung up unexpectedly'를 만나게 될 것이다. 이 에러를 만나게 되면 웹 서버의 HTTP POST body 사이즈를 늘려주고 서버를 재시작하면 된다.


## 참고

1. http://stackoverflow.com/questions/2056124/nginx-client-max-body-size-has-no-effect

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
