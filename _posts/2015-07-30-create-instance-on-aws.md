---
layout: post
title: AWS(Amazon Web Services)에서 Ubuntu 5분만에 시작하기
category: aws
tags:
  - aws
  - amazon
  - ubuntu
  - instance
comments: true
images:
  title: 'http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/09d82608-45b2-4a40-a28e-0a978dd0ac83'
---

## 서론

최근에는 웹 서비스를 하기 위해서 비싼 서버를 구입하거나 서버 구축을 위한 전문 지식이 없이도  **클라우드 컴퓨팅 서비스**를 사용하여 빠르고 쉽게 웹 서비스 환경을 구축할 수 있다. 연구소에서 **클라우드 컴퓨팅 서비스** 도입을 검토하기 위해서 여러가지 서비스를 사용해보기로 결정하였다. 클라우드 컴퓨팅에 관해서는 기본적인 배경 지식이 많이 필요하고 설명해야하는 부분도 많다. 우리가 이 서비스를 도입하려고 했던 이유는 크게 다음과 같다.

1. 서비스가 증가하면서 늘어나는 서버를 유연하게 하고 싶다.
2. 서버 관리에 들어가는 시간을 줄이고 비즈니스 개발에 집중하고 싶다.
3. 서버에 문제가 발생하면 대체 운영할 수 있는 서버 인프라가 필요하다.
4. 중요한 데이터를 분실하지 않게 효율적인 보안 및 백업 서비스 환경이 필요하다.

우리는 위와 같은 요구사항을 해소하기 위해서 첫번째 전세계 가장 많은 사람들이 사용하고 있는 [AWS(Amazon Web Servers)](http://aws.amazon.com/ko/)를 사용해보기로 하였다.

<!--more-->

## AWS 시작하기

Amazon이 한국 지사를 세우고 빠르게 한국어 서비스를 지원하고 있다. 아직 많은 부분이 영문으로 되어 있지만 점점 한국어 서비스가 늘어나고 있다. AWS는 유료서비스이다. AWS의 유료 정책은 매우 다양하기 때문에 아무런 준비없이 무턱대고 시작했다가는 혼란스러움을 겪을 수 있다. 가장 좋은 방법은 AWS에서 제공하고 있는 **Free Tier**를 사용해보는 것이다. [AWS](http://aws.amazon.com/ko/)에 접속해서 AWS 계정을 만든다.

AWS 계정을 만들어서 AWS 서비스를 시작하려면 **카드정보**가 필요하다. Free Tier 플랜으로는 **750시간/월**로 **1년**동안 무료로 사용할 수 있다. 다소 리소스가 제한적이기도 하지만 테스트하기에는 충분한 리소스를 제공받을 수 있다. 이 플랜 이외에 더 많은 리소스를 사용하고 싶을 경우는 카드결제가 진행되기 때문에 처음에 카드정보를 입력 받는다. 카드정보 없이는 AWS 계정은 생성되지만 AWS 서비스를 사용할 수 없다.

### 결제 정보

만약 결제정보가 없어서 AWS 인스턴스를 생성할 수 없을 경우 다음과 같이 결제정보를 요구하게되며 **카드정보**오 **연락처정보**를 업데이트해야한다.

카드 정보와 내 연락처를 입력한다. 카드 정보를 입력하면 카드 정보를 확인하기 위해 내 카드에서 **$1**가 결제되지만 이것은 확인용이라 다시 취소가 된다. 학생일 경우 **체크카드**를 사용해도 무방하다. 다만 해외결제가 되는 체크카드로 진행해야한다. 요즘 해외결제되는 체크카드를 은행에서 만들 수 있으니 학생들도 원한다면 체크카드를 생성하여 카드정보를 업데이트할 수 있다. 이 예제를 위해서 **체크카드**를 사용하여 진행하였다.

![연락처정보](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/0027f201-3fe8-41ee-9fe7-b0a3ae2c8a35)

### ID 확인

카드정보와 연락처 정보를 입력하고 난 다음에는 **ID확인**이 진행된다. 이 때, 전화번호를 입력하는 화면이 나오는데 전화번호를 입력하고 확인 작업을 할 때, Amazon에서 전화가 걸려온다. 겁낼필요가 없다. 전화인증 작업은 한국어로 진행이된다.

![결제정보](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/58edd0fb-6584-4cbc-8ef0-0bd2d870fddb)

전화 인증을할 때 AWS에서 발생한 **PIN**값을 전화기에 입력하면 된다. 어렵지 않다.
![PIN 정보](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/14dde885-7675-4a82-a5e7-b464bcab8eda)

### 계획지원

우리는 먼저 **기본(무료)**를 사용해볼 것이기 때문에 체크하고 다음으로 넘어간다.

![계획지원](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/209c6a49-f902-4ecf-ad6d-86532768e2de)

![가입완료](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/df95239a-9ac0-4dfc-8a5f-15fd3c3fabbb)

이렇게 **연락처 정보**, **결제정보**, **ID확인**, **계획지원**을 모두 완료하면 AWS 서비스를 시작할 수 있다.

## AWS 관리자콘솔

계정을 생성하고 난 다음 **관리자콘솔**로 들어가면 AWS의 서비스를 한눈에 확인할 수 있다. 대한민국에서 서비스하기 위해서는 **Asia Pacific(Tokyo)**를 선택하면된다. 그냥 기본적으로 위 과정을 진행하면 자동으로 Asia Pacific(Tokyo)가 선택될 것이다. 우리는 **Ubunut** 인스턴스를 AWS에서 동작시키기 위해서 [EC2(Elastic Compute Cloud)](http://aws.amazon.com/ko/ec2/) 인스턴스를 만들 것이다.

![AWS 관리자콘솔](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/35d6a138-f00e-4607-a125-82f46ffe9fdb)

AWS 서비스중에 EC2를 클릭하면 **EC2 Dashboard**로 이동한다.

![EC2 dashboard](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/df5a09f5-42c3-4355-9fc5-c0cf8ce9170e)

현재 아무런 인스턴스가 없기 때문에 위와 같은 화면이 나타날 것이다.

## 인스턴스 생성

EC2 인스턴스를 생성해보자. EC2 Dashboard 가운데에 있는 **Create Instance** 의 **Launch Instance** 버튼을 클릭한다.

**Step 1.Choose an Amazon Machine Image(AMI)**

가장 먼저 해야할 것은 운영체제 이미지를 선택하는 것이다. AWS는 AWS에 최적화된 RedHat 기반의 **AWS Linux**부터 Ubuntu, Windows 등 다양한 운영체제 이미지를 제공한다.

![Choose AMI](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/93f12a97-6399-4773-b993-76de0bece8db)

우리는 **Free Tier** 플랜을 사용하기 때문에 Free Tier 체크박스를 체크하여 무료로 사용할 수 있는 운영체제 이미지를 선택하면 된다. 우리는 기존에 Ubuntu 서버를 사용하고 있고 AWS에서 Ubuntu 서버를 운영하기 위해서 **Ubuntu 14.04LTS(HVM), SSD Volum Type** 이미지를 선택한다.

**Step 2. Choose an Instance Type**

![Choose an Instance Type](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/e6174334-e994-4862-b65f-1727e5dbd8f2)

같은 운영체제 이미지라고 할지라도 인스턴스 타입에 따라 성능 구별된다. CPU, Memory 갯수, Network Performance 등에 따라 가격이 다르다. 자신의 서비스에 최적화된 리소스를 선택하면 된다. 인스턴스 타입에 대한 자세한 정보는 [Instance Type](http://aws.amazon.com/ko/ec2/instance-types/)에서 참조할 수 있다. 우리는 **Free Tier** 플랜에 사용하는 **t2.micro**를 선택한다.

다음은 인스턴스를 상세 설정할 수 있는 **Configure Instance Details**과 기본설정으로 인스턴스를 생성하기 위한  **Review and Launch**를 선택할 수 있다. 기본적인 설정으로 인스턴스를 생성해보자.

**Step7. Review Instance Launch**

인스턴스를 생성하면 **SSH**를 사용하여 AWS 인스턴스에 접속할 수 있다.

![Review Instance Launch](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/e6dafd94-fa8f-4469-b6be-1d5281a0f8e8)

**Launch** 버튼을 클릭하면 AWS 서비스를 위한 **public key**와 **private key**를 생성할 수 있다. **private key**는 생성후 내 컴퓨터 저장하여 AWS에 접속할 때 **private key**을 사용한다. 이미 생성한 적이 있으면 생성된 키를 사용하면되고 처음이라면 **Create a new key pair**를 선택하고 **Key pair name**에 파일 이름을 저장한다. 예제를 위해서 **aws-saltfactory**라는 이름으로 키를 생성하였고, 생성된 **private key**는 **Download Key** 버튼으로 다운로드 한다. 다운로드되는 파일 이름은 **aws-saltfactory.pem**과 같이 **.pem** 파일로 다운로드 된다.

![create a new key](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/455f2cf8-b5dc-4e5e-840d-23ecbc09a283)

다운로드 받은 **private key**는 **~/.ssh/** 디렉토리로 복사한다.

```
cp ~/Downloads/aws-saltfactory.pem ~/.ssh/aws-saltfactory.pem
```

파일권한을 설정한다.

```
chmod 400 ~/.ssh/aws-saltfactory.pem
```

이후 AWS에 SSH로 접속할 때 이 key 정보를 사용하여 로그인할 것이다.

이제 기본적인 설정으로 인스턴스 생성이 완료되었다. 인스턴스 생성이 완료됨과 동시에 런칭되어 동작하기 시작한다.

![Launch Status](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/09cd4805-c451-412a-880b-4b88e1786d56)

EC2 Dashboard로 돌아가보자.

![EC2 Dashboard](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/5a066576-3b3c-4eea-949d-5915b1b0c22b)

앞에서 인스턴스를 생성하지 않았을 때와 달리 지금은 **1 Running instances**와 **1 Volumes** 그리고 **1 key Pairs**로 표시가 된다. **1 Runnings Instance**를 클릭하자.

![Running Instances](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/c741e258-ff58-4b7a-8461-508f5023b139)

생성된 인스턴스에 관련된 정보가 보일 것이다. AWS에 접근하기 SSH 로 접근하기 위해서 **Public DNS** 와 **Public IP** 정보를 살표보자. 이 예제에서는 **ec2-52-69-138-20.ap-northeast-1.compute.amazonaws.com** 로 만들어졌다. 이 Public DNS와 Public IP는 인스턴스를 생성할때마다 새롭게 할당되어진다. *이 예제에서 사용한 인스턴스는 삭제할 것이기 때문에  블로그에 포스팅하고 난 이후 이 정보들은 존재하지 않는 값이 되어질 것이다.*

## SSH로 AWS 접속하기

우리는 앞에서 **Key Pairs**를 새롭게 생성하면서 **Public Key**와 **Private Key**를 만들었고 **Private Key**를 다운로드하여 **~/.ssh/** 디렉토리 아래로 복사를 하였다. 이제 SSH로 AWS에 접속해보자. 접속하는 기본 계정은 **ubuntu** 이다.

```
ssh -i ~/.ssh/aws-saltfactory.pem ubuntu@ec2-52-69-138-20.ap-northeast-1.compute.amazonaws.com
```

![ssh](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/3b4a7bdd-4bc4-409f-b734-36f0ab999e4d)

이제 나만의 리눅스 서버가 만들어졌다.  지금부터는 Ubuntu를 사용하는 방법과 동일하다.

## 결론

서비스에 필요한 서버가 많아지기 시작하면서 우리는 좀 더 유연하고 서버 관리에 종속적이지 않고 비즈니스 개발에 집중할 수 있는 환경이 필요하게 되었다. 기존에는 독립적인 서비스를 위해서 서버 갯수를 늘리는 작업이 필요했고, 제한된 인원으로 점점 증가하는 서버를 관리하기 힘들어졌다. 뿐만 아니라 서버 백업과 미러링, 그리고 스캐일링을 효과적으로 할 수 있는 클라우드 컴퓨팅 서비스를 도입하기로 결정했다. AWS는 우리가 원하는 서비스를 제공하고 있고 실제 서비스를 운영하기 전에 사전 조사를 위해서 직접 실험해보기로 했다. 이제 AWS에 첫 걸음을 내딛고 시작한다. 분명한 사실은 이젠 더이상 예전처럼 운영체제를 설치하기 위해서 전산실에서 밤늦게까지 패키지를 설치하고 복잡한 서버 환경을 구축할 필요가 없다는 것이다. AWS에서는 기본 설정으로 설치하면 5분만에 내가 원하는 운영체제를 설치해서 서비스를 시작할 준비를 할 수 있다. 우리는 Ubuntu 서버에 익숙하지만 AWS Linux를 사용하면 서비스 개발을 바로 시작할 수 있는 패키지까지 설치되어 있는 인스턴스를 사용할 수 있다. AWS에 대해서는 서비스를 개발하며 운영하는 과정을 하나씩 블로그를 통해서 공유하려고 한다. 이미 국내에도 한국어로된 AWS 책들이 몇권 나와있다. 이젠 AWS를 시작하는 일만 남았다. Free Tier 플랜을 사요하면 1년간 무료로 테스트를 할 수 있다. 물론 **1개의 인스턴스**와 **750시간/월** 이라는 제한이 있지만 AWS를 경험하기에는 충분하다고 생각한다. AWS에서는 EC2 뿐만아니라 고급기술을 요구하는 클라우드 서비스 및 다양한 서비스 인프라를 구축하였다. 이 모든 서비스를 사용할 수 없지만 우리 서비스를 이전하면서 최대한 많은 서비스를 경험해 보려고한다. 이 포스팅은 AWS 시작을 망설이는 개발자들을 위해서 최대한 간단하게 AWS EC2 기본설정으로 5분안에 Ubuntu 운영체제를 사용할 수 있는 환경을 소개하였다.

## 참고

1. http://aws.amazon.com/ko/what-is-cloud-computing/
2. http://aws.amazon.com/ko/ec2/
3. http://aws.amazon.com/ko/console/
4. http://aws.amazon.com/ko/getting-started/
5. http://docs.aws.amazon.com/ko_kr/gettingstarted/latest/awsgsg-intro/gsg-aws-tutorials.html
6. http://aws.amazon.com/ko/free/
7. http://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/LaunchingAndUsingInstances.html

