---
layout: post
title: iOS 주소록 API를 이용하여 아이폰 주소록 다루기
category: ios
tags: [ios, addressbook, api, sdk, objective-c]
comments: true
redirect_from: /167/
disqus_identifier : http://blog.saltfactory.net/167
---

## 서론

아이폰에서는 주소록 API를 이용해서 주소록 데이터를 접근해서 조회하거나 저장할 수 있다. 이번 포스팅에서는 아이폰 앱 개발을 할 때 주소록 API를 사용하는 방법에 대해서 예제를 통해 살펴보기로 할 것이다. 주소록 API를 이용해서 사용할 수 있는 범위가 다양하고 또한 API 사용법 역시 다양하기 때문에 몇개의 아티클로 나누어서 포스팅을 할 예정이다. 그 첫번째로 iOS 주소록 API를 이용해서 주소록에 있는 그룹을 다루는 방법에 대해서 살펴보자.

<!--more-->

우선 예제를 테스트할 프로젝트를 만들어보자. 각자 원하는 이름으로 프로젝트를 생성한다. 이 포스팅에서 사용한 프로젝트 이름은 SFAddressbookTutorial 이다.

![](http://asset.hibrainapps.net/saltfactory/images/9bd30cba-ccd0-4e1e-bf9c-ac34cf110413)

이번 프로젝트부터는 Unit Tests를 활용할것이다. 프로젝트를 진행하면서 단위테스트는 매우 중요한 것이라고 생각하고 있기 때문에 단위테스트를 하는 습관을 가질 필요가 있다. 프로젝트를 생성하면 단위테스트를 하기위한 샘플 파일이 자동으로 생성이된다.

![](http://asset.hibrainapps.net/saltfactory/images/d351a8c1-9840-4077-8fe1-b76354be9f31)

Xcode에서 Objective-C를 단위테스트하기 위한 방법에 대해서는 다음에 자세히 설명하도록 하겠다.
단위테스트를 할 수 있는 테스트프로젝트에 주소록 API를 사용할 수 있도록 Library를 추가한다.
프로젝트 파일을 선택하여 Targets 중에 SFAddressBookTutorialTests 타켓을 선택한다. 그리고 Build Phases를 선택하여 Link Binary with Libraries를 열어서 Addressbook.framework와 AddressbookUI.framework를 추가한다.

![](http://asset.hibrainapps.net/saltfactory/images/3e47ba46-650a-4f43-ada0-4d1fbc043c71)

이제 iOS에서 주소록 API를 사용할 준비가 모두 마쳤다.
SFAddressBookTutorialTests.m 파일을 열어서 -testSelectAllGroups 메소드를 추가한다.

```objective-c
- (void)testSelectAllGroups
{

}
```

다음은 단위 테스트 중에서 이 메소드만 테스트하고 싶기 때문에 alt 키를 누른 상태에서 Run 버튼을 클릭하여 Test하는 메소드 중에서 testSelectallGroups만 제외하고 모두 체크를 해제한다.

![](http://asset.hibrainapps.net/saltfactory/images/a0977c91-50fb-4272-aaa6-27d2c62634d6)

다음은 Test를 선택하거나 테스트를 진행하거나 command + U 를 선택해서 단위 테스트를 시작한다.
지금은 테스트메소드 안에 아무런 코드가 없어서 특별한 에러나 오류 없이 테스트가 성공적으로 끝나게 될 것이다.

## ABAddressBook

아이폰의 주소록은 ABAddressBook 이라는 객체로 접근을 할 수 가 있다. 그렇기 때문에 주소록의 데이터를 가져오기 위해서는 ABAddressBook을 생성해야 한다.
다음 코드를 추가해서 다시 단위테스트를 진행해보자. ABaddressBook은 NSObject 타입이 아니다. 그렇기 때문에 STAssertNotNil과 같이 id 타입으로 테스트를 진행할 수 있다. 또한 NSObject 타입이 아니고 ARC를 사용할 수 없기 대문에 메모리를 할당하는 작업을 한 뒤에는 반드시 CFRelease를 해줘야한다. 다음 코드는 ABAddressBookCreate()를 이용해서 메모리를 할당받고 난 다음에 그것이 NULL이 아닌지를 테스트한 코드이다.


```objective-c
- (void)testSelectAllGroups
{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    STAssertTrue(addressBookRef != NULL, @"addressBookRef is NULL");
    CFRelease(addressBookRef);
}
```

만약 로직상 잘못된 로직을 테스트한다면 다음과 같이 에러를 만나게 된다. 위 코드를 다음과 같이 수정한다.

```objective-c
- (void)testSelectAllGroups
{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    STAssertTrue(addressBookRef == NULL, @"addressBookRef is NULL");
    CFRelease(addressBookRef);
}
```

![](http://asset.hibrainapps.net/saltfactory/images/36948878-17e3-4bd3-a9fd-5feeda1fc6c7)

![](http://asset.hibrainapps.net/saltfactory/images/fb57fc71-d83c-4576-8e83-9032207de5c7)

이렇게 단위테스트에서 로직을 간단하게 테스트할 수 있다.

## ABAddressBookCopyArrayOfAllGroups

이제 아이폰 주소록에 있는 그룹 목록을 가져오기 위해서 ABAddressBookRef에서 모든 Group을 가져오는 코드를 추가한다.

```objective-c
- (void)testSelectAllGroups
{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    STAssertTrue(addressBookRef != NULL, @"addressBookRef is NULL");

    CFArrayRef groupsRef = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    STAssertTrue(groupsRef != NULL, @"groupsRef is NULL");
    CFRelease(groupsRef);

    CFRelease(addressBookRef);
}
```

단위테스트를 진행하면 아무런 에러가 나지 않는다. 그래서 실제 아이폰 주소록의 데이터를 확인해보았는데 지금 시뮬레이터의 아이폰 주소록에는 어떤 연락처도 존재하지 않는다.

![](http://asset.hibrainapps.net/saltfactory/images/83377a1f-ca66-4917-91c6-c8f135bbb2f9)

우리는 ABAddressBookRef에서부터 그룹 목록을 가져오고 난 뒤에 그룹의 갯수를 알아보기로 하는 코드를 추가한다.

```objective-c
- (void)testSelectAllGroups
{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    STAssertTrue(addressBookRef != NULL, @"addressBookRef is NULL");

    CFArrayRef groupsRef = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    STAssertTrue(groupsRef != NULL, @"groupsRef is NULL");

    CFIndex numberOfGroup = ABAddressBookGetGroupCount(addressBookRef);
    STAssertTrue(numberOfGroup != 0, @"groupsRef count is 0");

    CFRelease(groupsRef);

    CFRelease(addressBookRef);

```

다시 단위 테스트를 실행해보니 다음과 같이 에러가 발생한다.

![](http://asset.hibrainapps.net/saltfactory/images/b55330d3-c00d-482d-acf2-3903b28c1e8c)

즉, 현재 테스트하고 있는 아이폰 주소록에는 그룹이 하나도 존재하고 있지 않다는 것이다.

## ABAddressBookSave

이제 우리는 ABAddressBookRef에 새로운 그룹을 하나 추가하는 테스트를 진행할 것이다. -testCreateGroup 이라는 단위테스트 메소드를 만들어보자.


```objective-c
- (void)testCreateGroup
{
    CFErrorRef errorRef = NULL;
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    STAssertTrue(addressBookRef != NULL, @"addressBookRef is NULL");

    ABRecordRef groupRef = ABGroupCreate();
    STAssertTrue(groupRef != NULL, @"groupRef is NULL");

    CFStringRef name = (CFStringRef)@"테스트그룹";
    ABRecordSetValue(groupRef, kABGroupNameProperty, name, &errorRef);

    STAssertTrue(errorRef == NULL, @"error is not NULL");

    ABAddressBookAddRecord(addressBookRef, groupRef, &errorRef);
    ABAddressBookSave(addressBookRef, &errorRef);

    NSInteger groupId = ABRecordGetRecordID(groupRef);
    STAssertTrue(groupId > 0, @"group is not created");

    CFRelease(groupRef);
    CFRelease(addressBookRef);

}
```

ABAddressBookRef 에 그룹을 추가하기 위해서는 ABRecordRef 타입의 그룹정보를 생성해서 ABAddressBook에 ABRecordRef 타입의 그룹 정보를 추가하고 추가된 ABAddressBook을 저장하면 된다. 테스트를 마치고 시뮬레이터의 주소록을 살펴보면 새로운 그룹이 생성된 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/352a5b77-c4a5-4645-bdd4-164b879737d5)

우선 ABGroupCreate()를 이용해서 그룹정보를 생성해서 저장할 준비를 한다.
다음은 ABRecordSetValue를 이용해서 방금 생성한 grouopRef를 kABGroupNameProperty 속성으로 이름을 가지고 저장한다.
이렇게 생성해서 이름까지 추가된 groupRef(즉, ABRecordRef)는 ABAddressBookAdRecord()로 새로운 레코드로 저장이 된다. 이때 생성해둔 addressBookRef에 추가하려고 만든 groupRef를 넘겨서 추가하게 한다. 그리고 마니막으로 ABAddressBookSave 메소드로 addressBookRef의 갱신된 정보를 완벽하게 저장하게 한다. 저장된 ABRecordRef 정보를 이용해서 ABRecrodID를 가져올 수 있는데 이것이 바로 방금전에 저장된 Group의 ABRecord의 ID  값이 되고 이것이 아이폰 주소록의 유일한 그룹의 identifier와 동일하다.

이제 다시 모든 그룹을 조회하는 단위테스트를 진행해보자. 이제 에러 없이 성공적으로 STAssertTrue(numberOfGroup != 0, @"groupsRef count is 0"); 테스트가 통과 될 것이다.
이제 주소록에서 모든 그룹을 가져와서 NSLog로 출력을 한번해도록 하자. (단위테스트에서는 Log를 출력하는 것이 그렇게 좋은 코드가 되지 못한다. 로직을 테스트하면 하도록 한다.)

```objective-c
- (void)testSelectAllGroups
{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    STAssertTrue(addressBookRef != NULL, @"addressBookRef is NULL");

    CFArrayRef groupsRef = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    STAssertTrue(groupsRef != NULL, @"groupsRef is NULL");

    CFIndex numberOfGroup = ABAddressBookGetGroupCount(addressBookRef);
    STAssertTrue(numberOfGroup != 0, @"groupsRef count is 0");


    for(int i = 0 ; i < numberOfGroup ; i++) {
        ABRecordRef groupRef = CFArrayGetValueAtIndex(groupsRef, i);

        CFStringRef groupNameRef = ABRecordCopyValue(groupRef, kABGroupNameProperty);

        NSInteger groupId = ABRecordGetRecordID(groupRef);
        NSLog(@"groupId : %d", groupId);

        if (groupNameRef != NULL) {
            NSLog(@"groupName : %@", (__bridge NSString *)groupNameRef);
            CFRelease(groupNameRef);
        }

    }

    CFRelease(groupsRef);

    CFRelease(addressBookRef);
}
```

위에 코드에서 보듯이 모든 그룹을 배열형태로 가져오고 그 배열을 순차적으로 돌면서 해당되는 index 의 그룹 정보를 출력하고 있다.

![](http://asset.hibrainapps.net/saltfactory/images/d215985c-e7c2-4194-8516-83e6ebc23948)

현재 테스트하고 있는 시뮬레이터의 주소록에서 ABRecordGetRecordID로 구한 groupId는 1이다. 우리는 이 groupId를 가지고 그룹을 삭제하는 테스트를 할 것이다.

## ABAddressBookRemoveRecord

그룹 삭제 테스트를 위해서 -testDeleteGroup 단위테스트 메소드를 추가한다.

```objective-c
- (void)testDeleteGroup
{

    NSInteger groupId = 1;

    CFErrorRef errorRef = NULL;

    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    STAssertTrue(addressBookRef != NULL, @"addressBookRef is NULL");

    ABRecordRef savedGroupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
    STAssertTrue(savedGroupRef != NULL, @"groupRef is not saved");

    if (savedGroupRef != NULL) {
        ABAddressBookRemoveRecord(addressBookRef, savedGroupRef, &errorRef);
        ABAddressBookSave(addressBookRef, &errorRef);

        savedGroupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
        STAssertTrue(savedGroupRef == NULL, @"groupRef is not deleted");

    }


    if (errorRef != NULL) {
        CFRelease(errorRef);
    }

    CFRelease(addressBookRef);
}
```

## 결론

이렇게 groupId를 이용해서 ABAddressBook에서 ABAddressBookGetGroupWithRecordID로 ABRecordRef를 찾은 다음 그것을 ABAddressBookRemoveRecord를 이용해서 제거한 다음에 변경된 ABAddressBook을 완전히 저장하도록 한다.

## 소스

* https://github.com/saltfactory/Saltfactory_iOS_Tutorial/zipball/t5-addressbook-group

## 참고

1. https://developer.apple.com/library/mac/#documentation/userexperience/Refere


