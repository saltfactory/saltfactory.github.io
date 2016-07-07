---
layout: post
title: Dropbox를 이용하여 서버없이 iOS 테스트용 앱 배포하기(Ad-Hoc distribution)
category: ios
tags: [ios, dropbox, ad-hoc]
comments: true
redirect_from: /242/
disqus_identifier : http://blog.saltfactory.net/242
---

## 서론

iOS 개발을 하게 되면 개발자들은 보통 자신의 맥에 아이폰을 USB로 연결해서 디바이스 디버깅을 한다. 하지만 개발이 완료후 베타 테스트를 진행할 때는 사내 사원들이나 가까운 지인에서 설치하여 테스트를 진행하는 경우가 많다.

Apple에서는 임의의 테스트 사용자가 앱을 테스트를 진행할 수 있게 provisioning file에 디바이스를 등록하여 등록된 기계에는 앱 스토어에 앱을 설치하지 않고도 테스트할 수 있게 허용하고 있다. 좀 더 편리하게 각각 디바이스를 USB로 연결해서 설치하는 것이 아니라 웹을 통해서 간단하게 다운로드 할 수 있는 테스트용 앱 배포 기능을 제공하고 있는데 이것이 바로 Ad-Hoc distribution 이다. Ad-Hoc에 관한 자세한 설명은 [Apple의 공식 문서](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/TestingYouriOSApp/TestingYouriOSApp.html)를 참조하길 바란다.

이 포스팅에서는 iOS 앱을 개발 후 Ad-Hoc으로 앱을 배포하는 방법을 설명한다.

<!--more-->

## iOS 앱 만들기

먼저, 간단한 앱을 만들어보자. Ad-Hoc 배포하는 방법만 설명할 것이기 때문에 간단하게 Empty Application 템플릿으로 앱을 생성하였다. 앱을 생성한 정보는 다음과 같다.

- **Product Name** : SFAdHocDemo
- **Organization Name** : SungKwang Song
- **Company Identifier** : net.saltfactory
- **Bundle Identifier** : net.saltfactory.tutorial
- **Class Prefix** : SF
- **Devices** : iPhone

위의 정보중에서 다른 정보는 별로 중요하지 않지만 코드인증을 위해서 ***Bundle Identifier***는 매우 중요하다. 이것은 앱의 유일한 식별자일 뿐만 아니라 코드인증과 개발자인증에 매우 중요한 정보가 된다.


## Provisioning Profile 만들기

프로덕트를 만들면 필요한 것이 바로 ***provisioning profile***이다. 이것은 코드 인증을 담당하고 디바이스 인증을 담당하고 있는 앱 개발에 중요한 프로파일이다. Apple 개발자 사이트에 로그인을 하여 iOS provisioning profile을 하나 만든다. 이전 포스팅 중에 Node.js로 APN 서버를 만들때 Apple 개발자 사이트에서 iOS provisioning profile을 만드는 방법을 설명했는데 다음 링크를 참고하면 최근 iOS provisioning profile을 만드는데 도움이 될 것이다. (http://blog.saltfactory.net/215)

우리가 필요한 것은 Ad-Hoc의 provisioning profile을 만드는 것이다. Apple 개발자 사이트에서 Provisioning Profiles 중에서 **distribution**을 클릭한다. 이미 만들어진 앱스토어 등록하거나 ad-hoc 테스트를 진행한 적이 있으면 provisioning profile들이 보일 것이고 그렇지 않으면 비어 있을 것이다.  

![provisioning profiles](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/ca782683-836f-40ab-9f68-b0ad495148c9)

**+ 버튼**을 클릭하자. 우리는 Ad-Hoc 배포를 위한 provisioning profile을 만들 것이기 때문에 Ad Hoc을 선택하고 Continue를 선택한다.

![distribution ad-hoc](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/f2a06d0e-120d-490d-a3b1-e66ad0967a58)

다음은 provisioning profile에 인증될 앱을 선택하는 화면이 나오는데 해당하는 ***App ID***를 선택한다.

![select app id](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/e84d1d2b-1e88-4da9-9993-7f6ecf8dbbff)

위 사진에서 만약 App ID가 나타나지 않거나 다른 App ID를 등록해서 선택하고 싶을 경우는 사이트 왼쪽 메뉴에서 Identifiers 카테고리 아래의 App IDs를 선택해서 새롭게 등록하면 된다. App ID를 선택하고 난 다음 **개발자의 Certificates**를 선택한다.

![select certificates](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/65e2b2e2-3d0c-4ac0-ab9c-c286bdca4a22)

유일한 앱 ID와 개발자 Certificates 선택 다음에는 디바이스 인증을 위해서 **등록된 디바이스를 선택**한다. provisioning profile을 가지고 인증 확인을 할 때, App ID, Certificates, Devices를 검사하게 되기 때문이다. Ad-Hoc 으로 배포해서 설치될 디바이스를 선택한다. 만약에 배포하고 싶은데 디바이스가 등록되어 있지 않으면 추가 등록하고 싶은 디바이스의 UUID를 알아서 새롭게 등록한 후 선택하여 추가한다.

![select device](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/f3f54c72-2fb7-4675-a974-54cdbe03fc8c)

마지막으로 **provisioning profile의 이름**을 입력한다. 우리는 saltfactory_tutorial_ad-hoc 으로 저장하였다.

![name generate](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/9918df37-e4a3-405f-b0c3-e398c0cabd9a)

**generate**를 선택하면 distribution provisioning profile이 만들어 질 것이다.

![generated profile](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/73de4a7c-b3ff-4314-9b55-a237b8320939)

![generated profile lists](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/2dc67877-c39d-4917-bd8b-883a03291cbc)

## Build Scheme and Archive

이렇게 만든 provisioning profile을 다운로드 받은 후 Xcode에 추가해서 새로생성한 프로덕트의 **code sign**에 매칭한다.

Xcode에서 **빌드 스키마** 창을 연다. option 키를 누르고 Run 버튼을 누른다. 그리고 **archive**를 선택한다. Scheme는 우리가 생성한 프로덕트 이름이고 **Destination**은 **iOS Device**로 수정한다(기본은 simulator로 되어 있다)

![build scheme](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/832f2a01-24fc-4c3a-8fac-82f2d3cac065)

**Archive 버튼**을 누른다. 만약에 provisioning profile 정보와 code sign의 정보가 일치되지 않을 경우 다음과 같은 에러를 만나게 된다.

![code sign error](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/7358ee3d-ed5c-4e7f-99f6-799ce4e9353f)

provisioning profile과 code sign이 이상없이 인증이 완료되면 다음과 같이 **Organizer 창**이 나타난다.

![organizer window](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/1eef2553-2523-4499-9461-ae8b718a41fb)

만약 앱을 앱 스토어에 등록하기 위해서는 Validate... 버튼을 선택하면되고 Ad-Hoc 배포를 하기 위해서는 Distribute 버튼을 선택한다. 우리는 Ad-Hoc 배포를 할 것이기 때문에 **Save for Enterprise or Ad Hoc Development** 를 선택하고 Next를 누른다.

![distribution method](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/bc8c0a87-38f1-48f2-8dd8-b0ea003e5094)

우리가 앞에서 만든 provisioning profile인 saltfactory_tutorial_ad-hoc을 선택하고 Export를 하도록 한다.

![choose profile sign](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/7cbf9c68-1920-4878-b804-fb4c9b120049)

## export files

위 과정이 마치고 나면 우리는 이제 Ad-Hoc으로 앱을 설치할 수 있는 준비를 모두 마친것이다. **export**를 누르면 다음과 같은 화면이 나온다. 이 것은 OTA를 설정하는 화면으로 실제 앱의 속성을 저장하고 있는 .plist 파일과 실제 앱 바이너리 파일인 .ipa 파일이 만들어지고 서버에 이 두 파일을 저장하게 된다.

![export files](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/13c17b39-30bc-468f-a657-170f4bbf964d)

여기서 Application URL은 앱의 정보를 저장하고 있는 파일인데 서버에 두 파일을 저장한 이후, 아이폰에서 모바일 safari 브라우저에  http://dev.saltfactory.net/ota/SFAdHocDemo.plist 링크를 입력하면 자동으로 앱이 다운로드 되어 설치하게 된다.

## Dropbox 디렉토리 사용

하지만 우리는 서버가 없다. 서버가 없기 때문에 우리는 dropbox를 이용할 것이다.
dropbox를 맥에 설치하거내 dropbox웹을 열어보자. dropbox에서 홈 디렉토리 밑에 `ota`라는 디렉토리를 만들어보자.

![create ota directory](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8ad4c546-8cec-4826-8251-df27441b585d)

맥에 설치했다면 다음과 같이 finder에서 dropbox 디렉토리 안에 ota 디렉토리가 동기화 되어 생성된 것을 확인할 수 있다.

![created ota directory](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/5437aad5-f34b-46b6-9cfe-af8aa61a2531)

ota directory에 **SFAdHocDemo.plist** 이름을 가진 파일과 **SFAdHocDemo.ipa** 파일을 추가한다. 그리고 추가한 파일에 오른쪽 마우스를 클릭해서 **Share Dropbox Link**를 선택하여 dropbox의 URL을 복사한다.

![copy share link](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/fceb6823-4ae4-42b9-84b7-de4af7a70252)

그리고 다시 Xcode의 **Oraginizer**로 돌아가보자. 그리고 복사한 Dropbox URL을 다음과 같이 **Application URL**에 붙여넣기를 한다.

```
https://www.dropbox.com/s/y852vcepgtaopvu/SFAdHocDemo.ipa
```
![application url](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/4c011264-c3f3-4926-ba68-24f7ebba975f)

하지만 이것은 dropbox의 페이지 URL 이다. 우리는 파일을 바로 다운로드 받을 수 있게 해야하기 때문에 다음과 같이 URL을 변경한다.

```
https://www.dropbox.com/s/y852vcepgtaopvu/SFAdHocDemo.ipa
```

to

```
https://dl.dropboxusercontent.com/s/y852vcepgtaopvu/SFAdHocDemo.ipa
```

그리고 파일을 dropbox의 디렉토리 중에 우리가 만든 ota 디렉토리 안으로 저장하게 한다. 그러면 다음과 같이 dropbox의 생성한 ota 디렉토리 안에 **SFAdHocDemo.plist**와 **SFAdHocDemo.ipa** 두개의 파일이 저장된 것을 확인할 수 있다.

![files](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/7f6d2e48-1e40-435c-b8f8-78972a25d569)

마지막으로 OTA를 사용할 수 있게 HTML 파일을 ota 디렉토리에 하나 추가해서 만들자. 파일 이름은 **download.html**로 정한다.

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
        <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1.0, maximum-scale=1.0"/>
    <meta name="apple-mobile-web-app-capable" content="yes" />

  <title>OTA Ad-Hoc 설치 페이지</title>
        <style>
                li {margin: 10px;}
        </style>
</head>
<body>
<p>
이 페이지는 비공개 앱 OTA 테스트(Closed OTA Test) 페이지 입니다.
<font color="red">디바이스 권한의 없으면 OTA를 설치할 수 없습니다.  </font>
<br/>
문의 사항은 <a href="mailto:saltfactory@gmail.com">saltfactory@gmail.com</a> 으로 메일을 보내어 주십시오.
</p>
  <ul>
        <li><a href="itms-services://?action=download-manifest&url=https://dl.dropboxusercontent.com/s/sx5z0mewbcbooic/SFAdHocDemo.plist">SFAdHocDemo OTA 설치</a></li>
  </ul>
  </ul>
</body> </html
```

![download.html](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/95d791af-16fb-43b6-b897-5bfd520d3369)

이제 아이폰에서 safari로 download.html 링크를 열어보자. download.html에서 오른쪽 마우스로 Share Dropbox Link를 선택하거나 dropbox 웹 사이트에서 download.html 파일을 선택해서 share를 한 뒤 링크를 아이폰으로 문자나 메일로 보낼 수 있다.

![send url to iphone](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/5ce51685-b69a-46f6-8100-06b1b1ebd700)

메세지로 받은 링크를 열어보면 다음과 같이 열린다.

![message income {width:320px;}](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/e7b8aaba-aaab-40b7-9a6f-8faf0dfe363b)
![open mobile safari {width:320px;}](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/3031e2b2-f18a-41f6-97c2-c2ec831aeca4)
![open ota site {width:320px;}](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/f3206cd3-6dd1-4ccc-963f-8438728b1060)

이렇게 설치할 수 있는 download.html 이 열리게 되는데 SFAdHocDemo.ipa를 다운받을 수 있는 링크를 눌러보자. 아래와 같이 다운받을 앱이 나타나고 install을 선택하면 아이폰에 설치가 진행된다.

![push install message {width:320px;}](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/5d076208-61e7-4aca-8449-4c14a83a0c34)
![install app on iphone {width:320px;}](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/c3854d17-0eaa-4c47-8665-aed1777b8eba)

## 결론

아이폰도 이젠 더이상 단일 디바이스가 아니다. iPhone3gs, iPhone4, iPhone5, iPhone5s 등 여러개의 실제 디바이스에 테스트를 진행해봐야한다. 이렇게 디바이스를 모두 USB를 연결하여 개발을 한다면 개발자는 많은 시간적 비용을 소비하게 된다. 그리고 앱을 개발 후 마켓에 등록하기 전에 실제 사용하면서 디버깅할 수 있는 베타 테스트가 필요한데, Apple은 Ad-Hoc distribution이라는 것을 사용해서 앱 스토어 업로드하기 전에 개발 폰으로 등록된 아이폰에 USB 연결없이 원격에서 설치할 수 있는 기능을 제공한다. 하지만 이렇게 원격지에서 앱을 설치하기 위해서는 웹 서버가 필요하다. 뿐만 아니라 iOS 7.1 부터는 Ad-Hoc distribution으로 OTA 설치를 하기 위해서는 https만 지원을 한다. 이전에는 http 도 지원했기에 특별히 보안서비스를 구입하지 않아도 사용 가능했지만 https를 사요하는 순간 서버에 ssl을 적용해야하기 때문에 많은 비용이 발생된다. Dropbox는 이런 서버기능을 대신해줄 수 있는 좋은 클라우드 서비스이다. 원래 Dropbox는 파일을 서버에 올려서 스마트 폰이나 PC등 다양한 디바이스에 파일을 자동으로 동기화하는 클라우드 서비스인데 Dropbox가 https로 동작을 하고 있고, html 파일 등 다양한 파일을 업로드할 수 있고 share 기능으로 외부에서 URL을 사용할 수 있기 때문에 Ad-Hoc distiribution을 사용해서 설치할 수 있는 서버 환경을 만들어줄 수 있는 것이다. 이제 더이상 복작하고 많은 비용이 발생하는 서버를 구축하거나 구입하지 않고 단순히 Dropbox에 가입하는 것만으로 Ad-Hoc distiribution을 구현해 낼 수 있다.

## 참고

1.	http://stackoverflow.com/questions/20276907/enterprise-app-deployment-doesnt-work-on-ios-7-1
2.	https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/TestingYouriOSApp/TestingYouriOSApp.html

