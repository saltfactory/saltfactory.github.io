---
layout: post
title: iTunes를 이용하여 아이폰과 데스크탑 파일 공유하기
category: ios
tags: [ios, iphone, mac, desktop, sharing]
comments: true
redirect_from: /173/
disqus_identifier : http://blog.saltfactory.net/173
---

## 서론

아이폰 사용자라면 아이폰에서 개인적으로 사용하는 데이터를 데스크탑으로 옮기고 싶은 생각을 항상가지고 있을 거라 예상된다. iCloud를 서비스가 존재하면서 사용자들은 사진, 음악, 동영상, 그리고 문서까지 모두 iCloud를 이용해서 애플의 디바이스에는 동기화를 할 수 있게 되었다. 하지만 특정 앱에서 발생하는 파일을 자신이 사용하는 데스크탑으로 파일을 전송하거나 가져오는 기능은 여전히 앱이 파일공유를 지원하는지의 여부에 따라서 개별로 파일을 공유할 수 있다. 아이폰과 데스트탑으로 파일을 공유하는 방법은 여러가지가 있는데 이번 포스팅에서는 USB를 이용해서 iTunes에 연결한 후에 아이폰과 데스크탑의 파일을 공유하는 방법에 대해서 살펴볼 것이다.

<!--more-->

## Desktop에서 iPhone으로 파일 공유

먼저 테스트를 위해 프로젝트를 생성한다.

![](http://cfile28.uf.tistory.com/image/11164935502DED8E0A6026)

다음은 iTunes와 iOS 어플리케이션의 파일 공유를 위해서 `{application}.plist` 파일에 **Application supports iTunes file sharing** 속성을 추가한다.

![](http://cfile22.uf.tistory.com/image/12050F3E502DEE2E0DE8C3)

**Application supports iTunes files sharing** 의 디폴트 값은 **NO**인데 **YES**로 변경한다. 그리고 아이폰 디바이스로 빌드하고 실행한 뒤에 iTunes를 열어보면 파일을 공유할 수 있는 앱으로 등록이 되어있다.

![](http://cfile7.uf.tistory.com/image/1377CC39502DEF950617CB)

이렇게 공유되는 파일들은 iOS 앱의 /Documents에 저장이 되는데 실제로 파일이 저장되는지 확인하기 위해서 테이블뷰컨트롤러를 하나 추가해서 다음 코드를 추가해보자.

![](http://cfile27.uf.tistory.com/image/111F953C502DF01E119FAA)

```objective-c
//
//  SFFilesTableViewController.m
//  SFFileSharingTutorial
//
//  Created by SungKwang Song on 8/17/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFFilesTableViewController.h"

@interface SFFilesTableViewController ()
{
    NSMutableArray *items;
}
@end

@implementation SFFilesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"공유파일목록";


    NSString *documentPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSFileManager *manager = [NSFileManager defaultManager];

    NSError *error;
    NSArray *filenames = [manager contentsOfDirectoryAtPath:documentPath error:&error ];

    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        items = [NSMutableArray arrayWithArray:filenames];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    return cell;
}

... 생략 ...
@end
```

그리고 AppDelegate.h를 수정한다.

```objective-c
//
//  SFAppDelegate.m
//  SFFileSharingTutorial
//
//  Created by SungKwang Song on 8/17/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFAppDelegate.h"
#import "SFFilesTableViewController.h"

@implementation SFAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    SFFilesTableViewController *filesTableViewController = [[SFFilesTableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:filesTableViewController];
    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];
    return YES;
}

... 생략...

@end
```

이제 iTunes에 공유하고 싶은 파일을 추가하고 iTunes와 iPhone을 동기화 한다. 테스트를 위해선 간단한 스트링문자열을 포함한 test.rtf 파일을 텍스트 에디터로 저장해서 그 파일을 공유 목록에 Add 버튼을 눌러서 추가한 다음에 동기화를 했다.

![](http://cfile10.uf.tistory.com/image/1909AF4F502DF0BB01B6D3)

## iPhone에서 Desktop으로 파일 공유

이제 아이폰의 /Documents 파일에 제대로 들어갔는지 앱을 빌드해서 실행시켜보자. iOS 시뮬레이터에서는 할 수 없기 때문에 아이폰으로 캡처를 받은 화면이다.

![](http://cfile9.uf.tistory.com/image/1576234C502DF132195C0A)

이렇게 간단하게 데스크탑의 파일을 앱으로 공유 시킬 수 있다.  
이제 앱에서 데스크탑으로 파일을 복사하려면 앱에서 /Documents 폴더로 파일을 저장한다. 테스트를 위해서 Xcode로 test.jpg 파일을 하나 추가했다. 이제 이것을 /Documents 폴더로 저장하는 코드를 추가한다.

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"공유파일목록";

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSFileManager *manager = [NSFileManager defaultManager];

    NSError *error;
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSString *destinationPath = [documentPath stringByAppendingPathComponent:@"test.jpg"];

    if([manager copyItemAtPath:sourcePath toPath:destinationPath error:&error]){
        NSLog(@"File successfully copied");
    } else {
        NSLog(@"Error description-%@ \n", [error localizedDescription]);
        NSLog(@"Error reason-%@", [error localizedFailureReason]);
    }


    NSArray *filenames = [manager contentsOfDirectoryAtPath:documentPath error:&error ];

    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        items = [NSMutableArray arrayWithArray:filenames];
    }
}
```

다시 앱을 빌드하고 실행시킨 후 에 iTunes를 확인해보자. 아래 그림과 같이 파일이 iTunes Documents 목록에 나타나게 된다. 여기서 Save to... 버튼을 선택해서 다른 곳으로 파일을 저장하면 간단하게 아이폰의 데이터를 데스크탑으로 저장할 수 있게 되는 것이다.

![](http://cfile10.uf.tistory.com/image/1314AA4C502DF39B036560)

만약 데스크탑에서 공유되고 있는 파일을 삭제하고 싶으면 파일이 선택되어 져 있는 상태에서 데스크탑의 delete 키를 누르면 다음과 같은 Alert 창이 나타나면서 삭제할 수 있다.

![](http://cfile6.uf.tistory.com/image/1275884B502DF44E32C6B2)

## 결론

이 예제는 아이폰과 데스크탑의 파일 공유를 위해서 USB를 연결해서 iTunes로 앱을 동기화 하여 앱 의 /Documents 디렉토리의 파일들을 공유하는 방법에 대해서 알아보았다. 다음에는 iTunes를 이용하지 않고 아이폰과 데스크탑의 파일을 공유하는 방법에 대해서 포스팅하기로 할 예정이다.

## 소스

* https://github.com/saltfactory/Saltfactory_iOS_Tutorial/tree/t8-filesharing

## 참고

1. http://developer.apple.com/library/ios/#documentation/general/Reference/InfoPlistKeyReference/Articles/iPhoneOSKeys.html
2. http://www.raywenderlich.com/1948/how-integrate-itunes-file-sharing-with-your-ios-app


## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
