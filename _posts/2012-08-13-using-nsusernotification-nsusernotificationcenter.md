---
layout: post
title: Mac app에서 NSUserNotification과 NSUserNotificationCenter를 사용하여 알림기능 구현하기
category: mac
tags: [mac, apns, push notification, objective-c]
comments: true
redirect_from: /170/
disqus_identifier : http://blog.saltfactory.net/170
---

## 서론

Mountain Lion Mac OS X (10.8)에서 부터 NSUserNotificationCenter 을 사용해서 아이폰과 동일하게 푸시 알림(Push Notification) 쌓이는 것을 확인할 수 가 있다.

![](http://cfile10.uf.tistory.com/image/175321395028FBD42476CF)

그리고 아이폰에서 푸시알림 (Push Notification)이 도착해서 알림창이 나타나듯 NSUserNotification 을 사용해서 알림을 설정할 수 있게 되었다.

![](http://cfile10.uf.tistory.com/image/155179395028FC32296D3D)

<!--more-->

## 프로젝트 생성

이번 포스팅에서는 이렇게 새롭게 추가된 NSUserNotificationCenter와 NSUserNotification을 사용해서 알림(Notification) 기능을 구현하는 간단한 예제를 만들어 볼 것이다. 우슨 테스트를 위해서 Cocoa Application 프로젝트를 생성한다.

![](http://cfile29.uf.tistory.com/image/123980355028FCAA052C1C)

![](http://cfile21.uf.tistory.com/image/20264B3A5028FCED3EC7E2)

간단하게 Cocoa 프로젝트가 만들어졌다. 빌드해서 실행하면 단순하게 간단하게 윈도우하나만 나타나게 된다.

![](http://cfile29.uf.tistory.com/image/117B313F5028FD4034CBA7)


다음은 푸시를 발생시킬 버튼을 하나 추가해서 버튼을 누르면 푸시를 발생하게 해보자. MainMenu.xib를 열어서 Push Button을 하나 추가하고 버튼을 더블클릭해서 "알림 생성" 이라고 텍스트를 변경한다.

![](http://cfile25.uf.tistory.com/image/163920355028FEF113677B)

원래는 컨트롤러 객체를 만들어서 IBAction을 연결하는게 좋지만 테스트를 위해서 그냥 간단하게 AppDelegate로 IBAction을 연결하도록 하겠다. Assistant editor를  열어서 Push Button으로 부터 드래그하여 IBAction을 연결한다.

![](http://cfile24.uf.tistory.com/image/1243A1375028FF9D191069)

![](http://cfile29.uf.tistory.com/image/1870AE405028FFA8246E9E)

## NSUserNotification와 NSUserNotificationCenter 사용

이제 -onNotificationButton: 으로 생성한 IBAction과 연결된 메소드를 구현해보자.
NSUserNotification 객체를 생성하고 Title과 InformativeText를 설정하고 SoundName을 지정하면 간단하게 Notification이 만들어지는 것이다. 그리고 NSUserNotificationCenter에 deliverNotification으로 전달하면 되는데, 이 코드를 바로 실행하면 아무러 반응이 나타나지 않아서 당황할지도 모른다.

```objective-c
- (IBAction)onNotificationButton:(id)sender {

    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:@"Saltfacotory"];
    [notification setInformativeText:@"Test User Notification"];
    [notification setSoundName:NSUserNotificationDefaultSoundName];

    NSUserNotificationCenter *notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    [notificationCenter deliverNotification:notification];



}
```

이유는 Notification의 알림과 NotificationCenter에 알림이 쌓이는 것은 앱이 다른 앱 뒤에서 실행하거나 백그라운드로 들어갔을 때만 Notification이 알려지기 때문이다. 그럼 과연 Notification 알림은 제대로 이루어지고 있는지 알아보기 위해서 우리는 다음 코드를 추가해보자.

```objective-c
//
//  SFAppDelegate.h
//  SaltfactoryMacTutorial
//
//  Created by SungKwang Song on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SFAppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;
- (IBAction)onNotificationButton:(id)sender;

@end
```

```objective-c
- (IBAction)onNotificationButton:(id)sender {

    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:@"Saltfacotory"];
    [notification setInformativeText:@"Test User Notification"];
    [notification setSoundName:NSUserNotificationDefaultSoundName];

    NSUserNotificationCenter *notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    [notificationCenter setDelegate:self];
    [notificationCenter deliverNotification:notification];

}

#pragma mark - NSUserNotificationCenter delegate method
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification
{
    NSLog(@"%@, %@", NSStringFromSelector(_cmd), [notification description]);
}
```

다시 빌드하고 실행한 뒤에 버튼을 누르면 콘솔창에 다음과 같은 로그가 남는다.

![](http://cfile7.uf.tistory.com/image/166EFE39502904B935076C)

비록 눈에는 알림 창이 나타나지 않았지만 Notification이 앱에 전달된 것을 확인할 수 있다. 우리는 버튼이 클릭된 뒤에 조금 여유를 주기 위해서 코드를 다음과 같이 변경해보자. -performselector:withObject:afterDelay: 메소드를 이용해서 시간을 지연시켜 5초뒤에 Notification이 발생하게 하였다.


```objective-c
- (void)createNotificationWithNotification:(NSUserNotification *)notification
{

    NSUserNotificationCenter *notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    [notificationCenter setDelegate:self];
    [notificationCenter deliverNotification:notification];
}

- (IBAction)onNotificationButton:(id)sender {

    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:@"Saltfacotory"];
    [notification setInformativeText:@"Test User Notification"];
    [notification setSoundName:NSUserNotificationDefaultSoundName];

    [self performSelector:@selector(createNotificationWithNotification:) withObject:notification afterDelay:5.0];

}
```

이제 다시 빌드해서 앱이 실행한 뒤에 버튼을 누르고 앱을 다른 앱 뒤에 숨기거나 닫아두면 5초뒤에 Notification 알림이 나타나고 NotificationCenter에 알림이 쌓이게 된다.

![](http://cfile6.uf.tistory.com/image/1817DA34502906102FDB64)

NSUserNotificationCenter 는 이렇게 직접적으로 -deliverNotification:으로 Notification을 전다할 수 있을 뿐만 아니라 schedule 기능을 이용해서 특정 시간 뒤에 알림을 나타나게 할 수도 있다.

우리는 다음과 같이 코드를 변경해보자. -setDeliveryDate:를 이용해서 다음 주기의 시간을 지정하고, -scheduleNotification:을 이용해서 스케줄링을 만들어두면 일정 시간이 지나면 Notification 알림이 전달된다.

```objective-c
- (IBAction)onNotificationButton:(id)sender {

    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:@"Saltfacotory"];
    [notification setInformativeText:@"Test User Notification"];
    [notification setSoundName:NSUserNotificationDefaultSoundName];
    [notification setDeliveryDate:[NSDate dateWithTimeInterval:5 sinceDate:[NSDate date]]];

    NSUserNotificationCenter *notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    [notificationCenter setDelegate:self];
    [notificationCenter scheduleNotification:notification];

//    [self performSelector:@selector(createNotificationWithNotification:) withObject:notification afterDelay:5.0];

}
```

다음은 이렇게 전달된 NSUserNotification을 삭제하는 방법을 살펴보자. NSUserNotification은 전달이되면 NSNotificationDelegate의 딜리게이트 메소드에서 도착된 알림을 확인하거나 도착된 알림을 통해서 앱이 실행되면 전달되는 메소드가 있다. 노티가 도착하면 -userNotificationCenter:didDeliverNotification: 딜리게이트 메소드가 동작하고, 노티로 인해 앱이 실행되면 -userNotificationCenter:didActivateNotification: 딜리게이트 메소드가 동작한다. 우리가 노티를 통해서 앱이 열려졌다면 더이상 Notification은 가용되면 안되기 때문에 -userNotificationCenter:didActivateNotification: 메소드를 추가하여 다음과 같이 구현한다.

```objective-c
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
    NSLog(@"%@, %@", NSStringFromSelector(_cmd), [notification description]);
    [center removeDeliveredNotification:notification];
}
```

## 결론

이렇게 Mountain Lion Mac OS X (10.8) 부터는 앱에서 임의로 NSUserNotification과 NSUserNotificatonCenter를 이용해서 알림 정보를 만들거나 스케쥴 기능을 이용해서 특정 시점에 알림을 만들어서 앱으로 전달할 수 있다.

## 소스

* https://github.com/saltfactory/Saltfactory_Cocoa_Tutorial/tree/t1-NSUserNotification

## 참고

1. https://developer.apple.com/library/mac/#documentation/Foundation/Reference/NSUserNotification_Class/Reference/Reference.html
2. http://www.renssies.nl/2012/02/mountain-lion-the-new-notifications-center/

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
