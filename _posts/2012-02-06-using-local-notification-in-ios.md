---
layout: post
title : iOS에서 Local Notification 사용하기
category : ios
tags : [ios, notification, objective-c]
comments : true
redirect_from : /100/
disqus_identifier : http://blog.saltfactory.net/100
---

## 서론

운영체제 프로그램을 만들다보면 특별한 잡을 예약해두고 싶은 경우가 있다. 이런 경우 cron을 사용하거나 job schedule 데몬을 만들어서 사용한다. 만약 아이폰에서 서버에서 하는 예약 프로그램 처럼 어떤 스케줄을 등록 했다가 특정 시간이 되면 사용자에게 알람을 해주려면 어떻게 해야할까? 쉽게 생각하면 백그라운드 프로그램을 하면 된다고 생각할 수 있을지 모르나, 백그라운드 프로그램으로 동작한다는 자체가 우선 앱이 한번은 실행을 해야한다는 것을 의미한다. foreground 에서 실행하던 앱이 다른 앱이 foreground로 실행될때 background로 실행이 되는 것인데 흔히 우리가 사용하는 Music 앱이나 GPS 앱들이 그렇게 동작한다. 하지만 스케줄 알람을 위해서 앱을 계속 켜둘수가 없다. 또한 아이폰의 메모리 문제로 오래된 앱은 메모리에서 삭제되어진다. 즉, 앱이 구동되지 않아도 알아서 뭔가의 액션이 일어나야한다. 우리는 이렇게 비슷한 것을 이미 익숙하게 사용하고 있다. 바로 "푸시 알림 서비스"이다. Push Notification Services는 Apple의 푸시 서비스를 통해서 push 메세지를 전달 받아서 아이폰에서 뭔가 알림 정보를 받는 것이다. 만약 Push 서버 없이 나의 아이폰에 특정 시간에 push 알림이 발생하게 하면 어떨까? iOS 4 부터는 이런 기능이 제공된다. 바로 Local Notification 이라는 것이 이런 요구를 해결해 줄 수 있는 것이다.
<!--more-->

UILocalNotification 클래스는 특별한 날짜나 시간에 사용자에게 알림을 할수 있게 스케줄을 등록할 수 있는 클래스이다.

너무나 간단하게 스케줄을 등록할 수 있다는 사실에 이 포스팅을 통해 당장이 스케줄 프로그램을 만들 수 있게 될거라고 생각이 든다. 그만큼 애플 개발자들은 API를 잘 설계했다. 예제는 간단하게 사용자가 스케줄 시간을 입력하고 등록하면 그 시간이 되면 알림 정보를 나타나게 하는 것이다. 매우 간단하다.

우선 Single ViewController를 가지는 프로젝트를 만들고 xib 파일에 UITextField와 UIButton으로 다음과 같이 시간을 입력받을 입력 박스와 저장을 할 수 있는 버턴을 만든다.

![](http://asset.hibrainapps.net/saltfactory/images/c7bf08d9-4735-4f0b-8383-78d0f119e15d)

그리고 각각 IBOutlet과 IBAction으로 연결한다.

```objective-c
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;

- (IBAction)onSaveAlertTime:(id)sender;
@end
```

IBAction에 연결된 메소드를 구현해보자. ARC로 작성하였다. ARC를 사용하지 않는 프로젝트에서는 release를 추가해주면 된다.

```objective-c
- (IBAction)onSaveAlertTime:(id)sender {
    // Do any additional setup after loading the view, typically from a nib.
    UILocalNotification *localNofication = [[UILocalNotification alloc] init];

    if (localNofication == nil) return;

    NSDate *pushDate = [[NSDate date] dateByAddingTimeInterval:[timeTextField.text intValue]];

    localNofication.fireDate = pushDate;
    localNofication.timeZone = [NSTimeZone defaultTimeZone];
    localNofication.alertBody = @"Local Push Notification!";
    localNofication.alertAction = @"View";
    localNofication.soundName = UILocalNotificationDefaultSoundName;
    localNofication.applicationIconBadgeNumber = 1;

    NSDictionary *userInfo = [NSDictionary dictionaryWithObject: @"오늘의 일정은 로컬푸시를 테스트하는 것 입니다" forKey:@"message"];
    localNofication.userInfo = userInfo;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNofication];
}
```

이 예제는 간단하게 사용자로 부터 textField에 시간을 입력받는다. 좀더 좋은 일정관리 프로그램을 만들기 위해서는 date picker를 이용하여 사용하면 좋을 것이다. 이 예제의 요점은 사용자가 아이폰 기계에 특정한 시간에 job을 등록할 수 있다는 것이다. 그리고 마치 Push Notification을 설정하듯 알림 메세지, 알림음 뱃지 등을 설정할 수가 있다.

![](http://asset.hibrainapps.net/saltfactory/images/83d7601f-f01d-467c-b773-32e81ad2ba61)

Local Notification을 등록하는 방법이 이렇게 간단하다. 그럼 이렇게 등록한 Local Notification에서 뭔가 데이터를 받아서 처리하고 싶을 경우가 있다. 이러한 경우 알림이 왔을 때 어떻게 처리할 수 있는지 살펴보자. application:didReceiveLocalNotification: 이라는 메소드가 바로 Local Notification이 실행되면 동작하는 delegate method 이다. AppDelegate.m 파일에 이 메소드를 추가하여 Local Notification을 처리할 수가 있다. 이때 notification으로 부터 데이터를 받아오는 것은 userInfo라는 dictionary 객체인데, notification 객체에 dictionary 형태로 저장하여 등록하면 된다. 이 과정은 위의 코드에 나와 있다.

```objective-c
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
  // 푸시가 왔을때 처리하는 부분
}
```

또 한가지 생각해야 할 것은 Local Notification 으로 notification이 발생할때 앱이 foreground로 실행되고 있으면 위와 같은 알림 창이 나타나지 않는다. background로 돌고 있거나 앱이 실행되지 않을 때 위의 사진과 같이 알림 창이 발생한다. 그래서 Local Notification이 발생하면 동작하는 delegate method 인 application:didReceiveLocalNotification: 메소드 안에 다음과 같은 코드를 입력해 보았다. 이 코드는 만약 앱이 실행되고 있고 백그라운드 상태가 아니면 알림 창을 띄우는데 앱의 이름과 메세지를 출력시켜서 마치 앱이 실행되지 않을 때 받는 알림 창과 동일하게 만든 것이다. 이 때 앱의 이름을 가져오는 방법은 `[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]` 이렇게 번들에서 앱의 이름을 가져올 수 있다.

```objective-c
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

    if (([application applicationState] == UIApplicationStateActive) && ([application applicationState] != UIApplicationStateBackground)) {
        [[[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] message:[notification alertBody] delegate:self cancelButtonTitle:@"Close" otherButtonTitles:[notification alertAction], nil] show];
    }
}
```
이제 Local Notification이 발생할때 앱이 실행되지 않거나 실행되고 있거나 동일하게 알림 창을 통해서 알림 정보를 받을 수 있게 되었다.

![](http://asset.hibrainapps.net/saltfactory/images/fa8ea50f-b7e4-4d22-877c-510bb51de468)

