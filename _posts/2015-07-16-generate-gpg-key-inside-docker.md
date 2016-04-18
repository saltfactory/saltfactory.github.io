---
layout: post
title: docker에서 GnuPG 키 생성 문제 해결과 파일 암호화/복호화 하기
category: docker
tags:
  - ubuntu
  - docker
  - gnupg
  - gpg
  - encrypt
  - decrypt
  - random
comments: true
images:
  title: 'http://asset.hibrainapps.net/saltfactory/images/fe9e56f7-48e2-4d5a-b035-de7a33d9ea10'
---

## 서론

[GnuPG(GNU Privacy Guard)](https://www.gnupg.org/)는 [PGP(Pretty Good Privacy)](https://en.wikipedia.org/wiki/Pretty_Good_Privacy)를 대체하는 **암호화/복보화** 프로그램이다. **PGP**는 이메일 보안의 표준으로 되었고 전자서명을 할 수도 있다. 원본파일과 sig 파일을 생성하여 배포하며 PGP를 사용하여 sig파일을 검증한다. GnuPG는 **OpenPG** 표준인 [RFC4880](https://tools.ietf.org/html/rfc4880)을 따른다. 컴퓨터에서 보안을 위해 파일을 암호화하거나 복호화할 때 이것을 사용하면 상용 암호화/복호화 프로그램없이 파일을 수준높은 보안으로 관리할 수 있다.

GPG를 사용할 때는 **개인키(private key)**를 생성해서 사용하는데, **docker** 환경에서 **GPG**로 키를 생성할 때, **Not enough random bytes available. Please do some other work to give the OS a change to collect more entropy!** 에러가 발생한다. 이 글에서는 docker에서 이 문제를 해결해서 docker에서 GPG를 사용하는 방법을 소개한다.
<!--more-->

## GnuPG key 생성

docker를 실행하여 접속한 뒤 GPG 개인키(private key)를  생성해보자.

```
gpg --gen-key
```

```text
gpg (GnuPG) 1.4.16; Copyright (C) 2013 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

gpg: directory `/root/.gnupg' created
gpg: new configuration file `/root/.gnupg/gpg.conf' created
gpg: WARNING: options in `/root/.gnupg/gpg.conf' are not yet active during this run
gpg: keyring `/root/.gnupg/secring.gpg' created
gpg: keyring `/root/.gnupg/pubring.gpg' created
Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 2048
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 0
Key does not expire at all
Is this correct? (y/N) y

You need a user ID to identify your key; the software constructs the user ID
from the Real Name, Comment and Email Address in this form:
    "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

Real name: saltfactory
Email address: saltfactory@gmail.com
Comment: demo-gpg
You selected this USER-ID:
    "saltfactory (demo-gpg) <saltfactory@gmail.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
You need a Passphrase to protect your secret key.

We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

Not enough random bytes available.  Please do some other work to give
the OS a chance to collect more entropy! (Need 275 more bytes)
```

![not enough random bytes](http://asset.hibrainapps.net/saltfactory/images/bd894e86-51e7-4cc0-a9db-3c17a6a86aa0)

위의 결과와 같이 docker에서 gpg 개인키를 생성할 때, 랜덤 바이트가 부족하다는 메세지를 출력하고 더이상 진행이 되지 않는다. 난수를 발생시키기 위해서 키보드나 마우스를 움직이라고 하는데 아무리 키보드를 두드려도 다음으로 진행이 되지 않는다.

> Not enough random bytes availabe. Please do some other work to give the OS a chance to collect more entropy!(Need 275 more bytes)

## 문제 원인

위와 같은 문제는 GPG로 키를 만들 때 난수를 발생을 디바이스의 노이즈를 사용하여 엔트로피를 채워 만드는 방식을 사용하는데 엔트로피가 채워지기까지 block이 걸리는 것이다. 데스크탑일 경우는 마우스나 키보드를 입력하면 되지만 서버일 경우 키보드나 마우스가 존재하지 않기 때문에 엔트로피가 채워지기까지 시간이 오래 걸린다. 이때 시스템에서 **/dev/random** 파일을 읽어서 처리한다.

이 문제를 해결하기 위해서 [rng-tools(Random Number Generator)](https://www.gnu.org/software/hurd/user/tlecarrour/rng-tools.html)을 사용하여 데몬으로 **/dev/random** 파일을 업데이트하여 사용하는 방법이 있다.

```
rngd -r /dev/random
```

하지만 이 방법을 사용해도 행아웃에 걸려 오랜 시간을 걸려도 다음으로 진행이 되지 않는 것을 볼 수 있다.


### 문제 해결하기

앞에서 난수를 발생하기 위해 **/dev/random**을 사용해서 엔트로피 풀을 채워서 사용하기 때문에 block이 발생한다고 했는데, 이와 다르게 non block으로 사용할 수 있는 **/dev/urandom** 으로 엔트로피 풀이 차지 않아도 난수를 발생할 수 있다. **urandom**은 **unlimited**를 뜻한다. 두가지는 비슷한 역활을 가지는 파일이지만 **/dev/random**이 **/dev/urandom**보다 보안적으로 깨어질 확률이 더 적어서 안전하다고 볼 수 있다.

docker 환경에서 **/dev/random**을 **/dev/urandom**으로 사용할 수 있도록 변경한다. (실제 어떤 시스템은 이 두가지를 심볼릭링크로 만들어져 있는 것을 확인할 수 있다.)

```
mv /dev/random /dev/random.bak
```
```
ln -s /dev/urandom /dev/random
```

이제 다시  GnuPG에서 개인키를 생성해보자.

```
gpg --gen-key
```

앞에서와 달리 **/dev/urandom**을 **/dev/random**으로 심볼릭링크를 만든 후 gpg 키를 생성하면 기다리는 시간 없이 키를 생성할 수 있다.

```text
gpg (GnuPG) 1.4.16; Copyright (C) 2013 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 2048
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 0
Key does not expire at all
Is this correct? (y/N) y

You need a user ID to identify your key; the software constructs the user ID
from the Real Name, Comment and Email Address in this form:
    "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

Real name: saltfactory
Email address: saltfactory@gmail.com
Comment: demo-gpg
You selected this USER-ID:
    "saltfactory (demo-gpg) <saltfactory@gmail.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
You need a Passphrase to protect your secret key.

gpg: gpg-agent is not available in this session
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
.+++++
....+++++
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
..+++++
..+++++
gpg: /root/.gnupg/trustdb.gpg: trustdb created
gpg: key 28D3DDF6 marked as ultimately trusted
public and secret key created and signed.

gpg: checking the trustdb
gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
pub   2048R/28D3DDF6 2015-07-16
      Key fingerprint = ACA0 4DE6 BB49 8ADD 05A5  E89F CDD8 EF49 28D3 DDF6
uid                  saltfactory (demo-gpg) <saltfactory@gmail.com>
sub   2048R/70100803 2015-07-16

```

![gpg 키생성 성공](http://asset.hibrainapps.net/saltfactory/images/9c42d065-5638-4323-8103-f575800bd3e8)


## GnuPG Key 목록 보기

`gpg --gen-key`로 키를 생성하고 난 뒤 키는 **~/.gnupg/** 디렉토리에 만들어진다. 생성된 키를 확인하기 위해서는 다음과 같이 확인할 수 있다

**공개키(public key)**를 확인하기 위해서는 **--list-keys** 옵션으로 확인할 수 있다.

```
gpg --list-keys
```
**개인키(private key)**를 확인하기 위해서는 **--list-secret-keys** 옵션으로 확인할 수 있다.

```
gpg --list-secret-keys
```

![gpg list keys](http://asset.hibrainapps.net/saltfactory/images/f30ffc31-0505-43e5-8753-21134f32360c)

## gpg Key를 사용하여 파일 암호화하기

개인키를 생성했으니 이제 키 기반으로 파일을 암호화해보자. docker 이미지에 예제를 위해 **/data/seed.data** 파일을 넣어두었다. 다음과 같이 **gpg --encrypt** 명령어를 사용하여 파일을 암호화 한다. 이때 **--recipient** 옵션에 키를 생성할 때 입력한 ID를 입력한다. 생각나지 않으면 `gpg --list-secret-keys`를 사용하여 확인할 수 있다.

```
gpg --output /data/seed.data.gpg --encrypt --recipient saltfactory /data/seed.data
```

![파일 암호화 결과 ](http://asset.hibrainapps.net/saltfactory/images/3ac1a8a8-e3ba-4c22-a33d-a23c25f508be)

## gpg Key를 사용하여 파일 복호화하기

암호화된 파일을 복호화해보자. 만약 실수로 파일윽 삭제했거나 필요에 의해서 파일을 복원해야하는 일이 생길 수 있다. 이때 암호화된 파일을 원래의 파일로 복호화하는 작업이 필요하다.

기존의 원본 데이터를 삭제한다.

```
rm /data/seed.data
```
암호화된 파일을 복호화하기 위해서는 **gpg --decrypt** 옵션을 사용해야한다. 복호화할 때는 **개인키(private key)**를 생성할 때 설정한 비밀번호를 물어본다. 비밀번호를 입력하면 파일 복호화가 진행이 된다.

```
gpg --output /data/seed.data --decrypt /data/seed.data.gpg
```

이렇게 복호화된 파일은 원래 파일과 동일하다.

![파일복호화 결과](http://asset.hibrainapps.net/saltfactory/images/4c536675-c8df-4edf-87f6-50cd5215ffad)


## 공개키 배포

만약에 생성된 키를 기반으로 다른 서버에서 어떤 작업을 할 때 **공개키(public key)**를 배포하여 생성된 공개키 기반으로 작업을 할 수 있다.

```
gpg --armor --output demo-server-gpg.pub --export "saltfactory"
```

![gpg export public key](http://asset.hibrainapps.net/saltfactory/images/7ee72c4d-c8a9-48fb-873d-68b9000f944d)

이렇게 생성한 공개키를 다른 서버에 전송해서 다음과 같이  gpg 데이터베이스에 임포트하여 사용할 수 있다.

```
gpg --import demo-server-gpg.pub
```

이렇게 공개키를 다른 서버에서 전달하면 **gpg Key**로 암호화하고 복호화하는 과정이 동일하다.

## GPG Key 삭제

생성한 GPG key를 삭제하고 싶을 경우는 **--delete-secret-key**와 **--delete-key**로 할 수 있다. 키 삭제는 반드시 개인키를 먼저 삭제해야한다. 만약 **--delete-key**를 먼저하게 되면 개인키가 있다는 메세지를 보이고 삭제되지 않는다.

![delete key 에러](http://asset.hibrainapps.net/saltfactory/images/f01a3a07-9f3f-42cd-957c-7e8c60bf47b6)

개인키부터 삭제를 해보자. **--delete-secret-key** 뒤에 ID를 입력한다.

```
gpg --delete-secret-key "saltfactory"
```

개인키가 삭제되더라도 공개키가 삭제가 되지 않는다는 것을 주의하자.

![secret key 삭제](http://asset.hibrainapps.net/saltfactory/images/f0afb043-3855-4290-bc5f-f1c59f1fd8a9)

이제 공개키를 삭제한다.

```
gpg --delete-key "saltfactory"
```
이제 GPG Key가 모두 삭제 되었다.

![](http://asset.hibrainapps.net/saltfactory/images/a753cd41-af02-4a22-9b5a-8ba9bbaed3bb)

## 결론

**docker**의 발전으로 많은 서비스가 docker 위에서 컨테이너 독립적으로 서비스를 운영할 수 있 수 있게 되었다. 기존의 서비스를 docker로 이전하면서 발생하는 메이저한 문제부터 마이너한 문제까지 다양한 문제를 만날 수 있는데 이 때 원래 리눅스 시스템에서 사용하던 기존의 원리를 잘 연구하면 방법을 해결할 수 있다. 실제 **GunPG**로 키를 생성할 때 , **/dev/random**은 꼭 docker가 아니더라도 특정 서버에서 행아웃이 걸릴 수 있다. 이때 **/dev/urandom**으로 대처해서 **GnuPG**의 키를 생성할 수 있다. **GnuPG**는 고가의 암호화/복호화 소프트웨어를 구입하지 않고도 훌륭하게 파일(디렉토리) 암호화를 할 수 있다. 이미 많은 오픈소스에서 **GnuPG** 암호화를 사용하고 있다. docker에서 서비스를 운영할 때, **GnuPG** 키를 생성하지 못하는 문제를 해결하고 다양한 방법으로 파일(디렉토리) 보안 서비스를 할 수 있기를 기대한다.

## 소스

- https://github.com/saltfactory/docker-ubuntu-tutorial/tree/master/gpg

## 참고

1. http://thejohnreed.com/2014/08/23/gnupg-2-on-ubuntu/#Generating_a_private_key
2. https://en.wikipedia.org/wiki//dev/random
3. http://marc.info/?l=kroupware&m=116375188915536&w=2
4. http://www.onkarjoshi.com/blog/191/device-dev-random-vs-urandom/
5. https://myonlineusb.wordpress.com/2011/06/10/what-is-the-difference-between-devrandom-and-devurandom/
6. http://egloos.zum.com/studyfoss/v/5168232

