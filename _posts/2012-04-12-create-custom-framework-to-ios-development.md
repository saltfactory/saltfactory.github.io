---
layout: post
title: iOS 개발 할 때 iOS용 framework를 만들어서 배포하기
category: ios
tags: [ios, objective-c, xcode, framework]
comments: true
redirect_from: /120/
disqus_identifier : http://blog.saltfactory.net/120
---

우리는 이전의 아티클에서 [iOS 개발 할 때 정적 라이브러리(static library)를 사용하여 팀 프로젝트 협업하기](http://blog.saltfactory.net/119) 라는 제목으로 정적 라이브러리를 사용해서 코드 재사용성을 높이고 팀 프로젝트나 협업을 할 수 있는 방법을 학습했다. 정적 라이브러리 프로젝트를 생성하여 개발하고 그 코드를 재사용하기 위해서 우리는 프로젝트에 정적 라이브러리 프로젝트를 추가하여 build settings에 헤더 파일을 추가했다. 개발자에게 이미 만들어진 라이브러리와 리소스 등을 좀더 근사하게 UIKit.framework나 MKMap.framewrof 와 같이 배포하여 사용되기를 바랄 수 있다. 하지만 Cocoa Touch 프로젝트에서는 framework를 위한 프로젝트를 생성할 수 없다.
<!--more-->

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/26076b1f-6b77-4bd5-9521-342dcee217ff)

이러한 이유 때문에 Cocoa framework 처럼 iOS framework 처럼 만들 수 있는 템플릿을 만들어서 사용하기도 한다. https://github.com/kstenerud/iOS-Universal-Framework 에서 소스코드를 받아서 템플릿을 만들어서 사용할 수 있다. 이 포스팅에서 소개할 것은 iOS framework를 어떻게 생성해서 배포할 수 있을지에 대해서 고민하고 찾아보는 가운데 http://spin.atomicobject.com/2011/12/13/building-a-universal-framework-for-ios/ 블로그에서 Aggregate(여러개의 타겟을 한번에 빌드할 때 하나의 타겟으로 빌드할 수 있다) 를 이용해서 framework를 생성할 수 있는 방법이 있어서 실제 적용해보고 포스팅하기로 했다. 우리는  iOS 개발 할 때 정적 라이브러리(static library)를 사용하여 팀 프로젝트 협업하기 아티클에서 정적 라이브리로 만든 것 중에서 A개발자가 만든 파일을 저장하는 SFFileManager가 포함된 SaltfactoryiOSLib를 framework로 배포하여 사용할 수 있게 수정할 것이다.

SaltfactoryiOSLib의 프로젝트에서 타겟을 Aggregate의 Target을 추가하자. 이때 이름은 SaltfactoryiOS라고 하였다. 이것은 나중에 프레임워크의 이름이 되는데 import `<SaltfactoryiOS/SFFileManager.h>` 라고 사용 할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/9a9b102b-eec1-4d9d-835b-78029b0dd586)

Target에 Aggregate 가 추가되면 Build Phases 탭에서 Add Build Phase 버턴을 클릭해서 Add Run Script를 추가하여 Build Universal Framework와 Build Static Lib라고 이름을 변경한다. 그리고 Add Build Phase 버턴을 클릭해서 Add Copy Files를 하나 추가한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/03f55c72-c22a-46f4-8457-1e20f26dc56d)

Build Static Lib는 정적 라이브러리를 빌드하는 스크립트가 포함된다.

```bash
echo "BUILD DIRECTORY ${BUILD_DIR}"
xcodebuild -project ${PROJECT_NAME}.xcodeproj -sdk iphonesimulator -target ${PROJECT_NAME} -configuration ${CONFIGURATION} clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator

xcodebuild -project ${PROJECT_NAME}.xcodeproj -sdk iphoneos -target ${PROJECT_NAME} -configuration ${CONFIGURATION} clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos
```

그리고 Build Universal Framework에는 정적 라이브러리를 빌드한 파일들을 framework가 필요하는 폴더를 만들거나 링크파일을 만들고 필요한 파일을 복사하는 스크립트가 포함된다. 이때 빌드가 성공적으로 이루어지면 Products 디렉토리(빌드 디렉토리 밑에 존재)안에 (Debug|Release)-universal  형태의 디렉토리 안에 SaltfactoryiOS.framework 형태의 프레임워크 디렉토리가 만들어진다. 이 스크립트는 Simulator와 Device에 사용되는 정적 라이브러리를 함께 사용해서 universal용 프레임워크를 만드는 스크립트이다.

```bash
SIMULATOR_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/lib${PROJECT_NAME}.a" &&
DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/lib${PROJECT_NAME}.a" &&
UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal" &&
UNIVERSAL_LIBRARY_PATH="${UNIVERSAL_LIBRARY_DIR}/${PRODUCT_NAME}" &&
FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${PRODUCT_NAME}.framework" &&


# Create framework directory structure.
rm -rf "${FRAMEWORK}" &&
mkdir -p "${UNIVERSAL_LIBRARY_DIR}" &&
mkdir -p "${FRAMEWORK}/Versions/A/Headers" &&
mkdir -p "${FRAMEWORK}/Versions/A/Resources" &&

# Generate universal binary for the device and simulator.
lipo "${SIMULATOR_LIBRARY_PATH}" "${DEVICE_LIBRARY_PATH}" -create -output "${UNIVERSAL_LIBRARY_PATH}" &&

# Move files to appropriate locations in framework paths.
cp "${UNIVERSAL_LIBRARY_PATH}" "${FRAMEWORK}/Versions/A" &&
ln -s "A" "${FRAMEWORK}/Versions/Current" &&
ln -s "Versions/Current/Headers" "${FRAMEWORK}/Headers" &&
ln -s "Versions/Current/Resources" "${FRAMEWORK}/Resources" &&
ln -s "Versions/Current/${PRODUCT_NAME}" "${FRAMEWORK}/${PRODUCT_NAME}"
```

Copy Files 에는 실제 복사되어질 파일을 넣어주면 되는데 .h 파일이 framework 폴더에 ${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal/${PRODUCT_NAME}.framework/Versions/A/Headers/ 라는 폴더로 복사되게 지정한다. 이때 Destination을 Absolute Path로 지정한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/5f3fbb4b-de91-421c-9a03-80f3509be631)

이제 SatfactoryiOS 타겟을 지정하고 빌드해보자. 보통 framework는 배포용으로 만들기 때문에 Release로 빌드하도록 한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/2371b60a-6d51-4769-85e3-71ad1891b9ed)

빌드를 시작하면 다음과 같은 에러가 발생되면서 빌드가 실패될 것이다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/746c610d-50c2-473f-bc1a-1b02862b5890)

이것은 libSaltfactoryiOSLib.a를 찾지 못해서 발생하는 문제이다. 정적 라이브러리를 찾는 경로를 살펴보면 빌드 디렉토리 밑에 Build/Products/Release-iphonesimulator/libSaltfactoryiOSLib.a를 찾지 못하고 있다. 이것은 복사하려는 정적 라이브러리가 만들어져 있지 않기 때문인데 이런 에러가 나타나면 SaltfactoryiOSLib 프로젝트에서 Simulator와 Device 스키마를 설정해서 모두 Release로 빌드한 후 에 다시 SaltfactoryiOS 타겟(Appregate)을 다시 빌드하면 정상적으로 빌드가 완료되고 Release-iphoneuniversal 이라는 디렉토리 밑에 SaltfactoryiOS.framework 라는 프레임워크 폴더가 생성된 것을 확인 할 수 있다. tree 라는 command tool을 이용해서 SaltfactoryiOS.framework 디렉토리 구조를 살펴보면 다음과 같다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/591190b2-f64e-40c3-b7bb-be364170861c)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/af78ac65-5c6d-4764-9796-74ca2d46eb35)

이제 정적 라이브러리로 사용한 프로젝트를 framework를 이용해서 사용할 수 있도록 변경해보자.
우선 SaltfactoryiOSTutorial 프로젝트에서 사용한 libSaltfactoryiOSLib.a 정적 라이브러리를 제거한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/d8bdea52-54d5-43f0-b228-d17fc43859e7)

다음은 Header Search Paths에서 포함시킨 헤더파일을 삭제한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/cb6e7868-8a16-4385-b0bd-a2ea0ba57e79)

이제 SaltfactoryiOS.framework를 추가한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/0e4a7974-3689-4c98-a833-be916e164801)

그리고 `#import "SFFileManager.h"`로 임포트한 것을 `#import <SaltfactoryiOS/SFFileManager.h>`로 변경한다.

```objective-c
//
//  SFViewController.h
//  SaltfactoryiOSTutorial
//
//  Created by SungKwang Song on 4/4/12.
//  Copyright (c) 2012 saltfactory@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SFFileManager.h"
#import <SaltfactoryiOS/SFFileManager.h>
#import "SFSecurityHelper.h"


@interface SFViewController : UIViewController<UITextFieldDelegate, SFFileManagerDelegate, SFSecurityHelperDelegate>
{
    SFFileManager *fileManager;
    SFSecurityHelper *securityHelper;
}
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UITextView *messagesTextView;
- (IBAction)onSaveButton:(id)sender;
- (IBAction)onClearButton:(id)sender;
@end
```

이렇게 이제 다시 SaltfactoryiOSTutorial  프로젝트를 빌드하여 실행해보면 이전에 정적 라이브러리를 사용해서 실행되는 결과와 동일하게 실행되는 것을 확인 할 수 있다. 프로젝트의 구조를 살펴보면 암호화와 복호화를 위해서 만든 SaltfactorySecurityLib 프로젝트의 libSaltfactorySecurityLib.a 정적라이브러리와 Aggregate를 이용해서 SaltfactoryiOS.framework로 만든 라이브러리를 사용하는 것을 볼 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/ad9f57c7-e202-4cc6-a105-0a171f2ed017)

정적 라이브러리를 사용 하는 것과 달리 SaltfactoryiOS.framework라는 프레임워크 폴더 자체를 프로젝트에서 마치 MKMap.framework를 추가하듯 Build Phases에 추가해서 간단하게 사용 할 수 있게 되었다. 프로젝트 파일들과 상관없이 이제 자신만의 프레임워크를 배포 할 수 있게 된 것이다.

## 결론

우리는 이전 포스팅에서 소스 코드의 재사용과 팀 프로젝트 작업의 효율성을 위해서 정적 라이브러리를 사용하는 방법을 살펴 보았다. 개발하는 입장에서는 정적 라이브러리 전체 프로젝트를 받거나 정적 라이브러리 파일과 헤더 파일을 복사해서 추가하는 방법을 사용하는데 별로 문제가 되지 않는다. 어차피 개발하는 입장에서 정적 라이브러리 코드가 git와 같은 소스 버전 관리 툴에서 내려 받고 업데이트할 수 있기 때문이다. 하지만 만약에 라이브러리를 만들어서 범용적으로 배포를 한다던지, 프로젝트 파일이나 소스코드 자체를 알 필요 없이 간단하게 framework를 추가하듯 배포하는 방법이 필요하다. 하지만 framework는 Cocoa Framework만 공식적으로 템플릿을 지원하기 때문에 iOS Framework를 만들 수 있는 템플릿은 다른 써드파티 템플릿을 이용해야한다. 이때 Aggregate라는 타겟을 추가하여 build script와 copy files를 이용해서 정적 라이브러리로 만들어진 파일과 헤더파일을 복사해서 framework 디렉토리로 만들어서 배포 할 수 있다는 것을 이 포스팅에서 소개했다. json 라이브러리로 알려진 yajl-objc 프로젝트에서도 framework 방식으로 라이브러리를 배포하고 있고 얼마전에 공개한 Daum의 모바일 앱 용 지도 라이브러리도 framework 방식으로 배포하고 있다. 정적 라이브러리를 잘 설계해서 만들거나, 커스텀 UI를 잘 설계해서 만든 다음 framework 로 만들어서 배포한다면 좀더 편리한 방법으로 라이브러를 배포 시키고 재사용할 수 있을 거라 예상된다.

## 참고

http://spin.atomicobject.com/2011/12/13/building-a-universal-framework-for-ios/

