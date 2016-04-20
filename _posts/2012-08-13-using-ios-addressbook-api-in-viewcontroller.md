---
layout: post
title: iOS 주소록 API를 뷰컨트롤러에 연결하여 사용하기
category: ios
tags: [ios, api, sdk, group, addressbook, contacts, objective-c]
comments: true
redirect_from: /168/
disqus_identifier : http://blog.saltfactory.net/168
---

## 서론

우리는 이전 아티클  iOS 주소록 API를 이용해서 아이폰 주소록 그룹 다루기를 통해 Unit Test로 테스트를 해보았다. 이번 포스팅에서는 이전 아티클에서 사용한 테스트 코드를 이용해서 실제 UI와 함께 사용해서 아이폰 주소록에 데이터를 접근해서 아이폰 주소록 그룹에 관련된 작업을 처리할 수 있도록 할 것이다. 우선 테스트를 하기 위해서 프로젝트를 생성해야하는데 이전 아티클에서 사용한 프로젝트를 그대로 사용해도 된다. 우리는 t5-addressbook 브랜치의 소스코드에다가 파일을 더 추가할 것이다. 소스코드를 git를 이용해서 clone 하고 난 다음 git checkout으로 t5-addressbook으로 브랜치를 변경한다.

<!--more-->

```
git clone https://github.com/saltfactory/Saltfactory_iOS_Tutorial.git
```

```
git checkout -t t5-addressbook
```

t5-addressbook 브랜치로 변경후 프로젝트 파일을 열어서 확인하면 이전 아티클에서 테스트한 프로젝트 파일이 열리게 될 것이다. SFAddressbookTutorial 프로젝트는 생성할 때 empty project로 생성하였기 때문에 AppDelegate 를 제외하고 아무런 파일이 존재하지 않는다. 그리고 단위 테스트를 했기 때문에 SFAddressbookTutorialtests에는 테스트한 코드들이 존재를 한다.

우리는 간단하게 그룹을 추가/수정/삭제 테스트를 할 것이기 때문에 UITableViewController 을 상속받은 SFGroupsTableViewController를 프로젝트에 추가해보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/449c491b-db11-45ef-afd0-1b144a96d7da)

다음은 AppDelegate에서 UINavigationController를 생성해서 방금 추가한 SFGroupsTableViewController를 추가하여 rootViewController가 되게 한다.

```objective-c
//
//  SFAppDelegate.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/10/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFAppDelegate.h"
#import "SFGroupsTableViewController.h"
@implementation SFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    SFGroupsTableViewController *groupsTableViewController = [[SFGroupsTableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:groupsTableViewController];
    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];
    return YES;
}
... 생략...
```

빌드하고 실행해보면 다음과 같은 화면이 나타날 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a53c32f3-6a92-447d-9e90-83574531faab)

이제 SFGroupsTableViewController.m을 열어서 뷰 컨트롤러에 타이틀을 지정하고 그룹을 추가하고 편집할 수 있는 버튼을 추가한다. 버튼은 오른쪽 상단에 "+" 버튼을 추가하여 그룹을 추가할 수 있는 액션을 연결할 것이고, 왼쪽에는 "Edit" 버튼을 추가해서 현재화면을 편집할 수 있는 액션을 연결할 것이다.


```objective-c
//
//  SFGroupsTableViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupsTableViewController.h"

@interface SFGroupsTableViewController ()
- (IBAction)onAddButton:(id)sender;
- (IBAction)onEditButton:(id)sender;
@end

... 생략 ...

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"주소록 그룹";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButton:)];
}

... 생략...

#pragma mark - IBAction henadler
- (IBAction)onAddButton:(id)sender
{

}

- (IBAction)onEditButton:(id)sender
{

}
```

이제 onAddButton 안에 이전 아티클에서 테스트한 그룹을 추가하는 코드를 넣으면 된다. 하지만 우리는 좀더 View와 Logic을 분리해서 코드의 재사용성과 유지보수를 효율적이고 효과적으로 할 수 있도록 하길 원하기 때문에 SFGroupService라는 서비스객체를 만들어서 추가한다. NSObject를 상속받은 SFGroupService 라는 객체를 생성하고 delegate를 선언해서 추가한다. 이유는 서비스 객체의 재사용성과 코드의 유연성을 위해서이다. 실제 데이터를 핸들잉하는 것은 서비스객체에서 처리하고 뷰와 연관된 작업들은 뷰 컨트롤러에게 delegate로 위임시켜서 처리하고 싶기 때문이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ca847265-36c4-40e5-bc8d-c58f0b00496a)

SFGroupService.h 파일을 열어서 프로토토입을 선언하고 delegate를 사용할 수 있도록 설정한다. 그리고 그룹조회,추가, 삭제, 업데이트를 할 수 있는 메소드와 이 메소드가 처리하고 난 다음 다시 뷰 컨트롤러에거 작업을 위임시키기 위한 delegate 메소드를 추가한다.

```objective-c
//
//  SFGroupService.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFGroupServiceDelegate <NSObject>

@required
- (void)groupServiceDidFailWithError:(NSError *)error;
- (void)groupServiceDidFindGroups:(NSArray *)groups;
- (void)groupServiceDidAddGroup;
- (void)groupServiceDidDeleteGroup;
- (void)groupServiceDidUpdateGroup;
@end

@interface SFGroupService : NSObject
{
    id<SFGroupServiceDelegate>delegate;
}
@property (nonatomic, strong) id<SFGroupServiceDelegate>delegate;

- (void)findAllGroups;
- (void)addGroupWithName:(NSString *)name;
- (void)deleteGroupWithGroupId:(NSInteger)groupId;
- (void)updateGroupWithName:(NSString *)name groupId:(NSInteger)groupId;

@end
```

이제 우리는 SFGroupService.m 파일에다 위의 선언들을 구현할 것인데 각 메소드에 들어가는 코드는 이전 아티클의 테스트를 참조해서 작성하면 된다. 먼저 -findAllGroups 메소드를 구현해보자. 이전 아티클에서 추가된 부분만 하이라이팅으로 표시를 해뒀다. 원래 단위테스트란 이렇게 메소드를 만드록 난 다음에도 단위 테스트를 실행해야하지만 포스팅이 길어지는 것을 원치않기 때문에 이 메소드에 대한 단위테스트는 이전 아티클의 로직테스트로 대처하기로 한다.

```objective-c
//
//  SFGroupService.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupService.h"
#import <AddressBook/AddressBook.h>

@implementation SFGroupService
@synthesize delegate;

- (void)findAllGroups
{

    NSMutableArray *groups = [NSMutableArray array];

    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    CFArrayRef groupsRef = ABAddressBookCopyArrayOfAllGroups(addressBookRef);

    CFIndex numberOfGroup = ABAddressBookGetGroupCount(addressBookRef);

    for(int i = 0 ; i < numberOfGroup ; i++) {
        NSMutableDictionary *groupInfo = [NSMutableDictionary dictionary];

        ABRecordRef groupRef = CFArrayGetValueAtIndex(groupsRef, i);

        CFStringRef groupNameRef = ABRecordCopyValue(groupRef, kABGroupNameProperty);

        NSInteger groupId = ABRecordGetRecordID(groupRef);
        [groupInfo setValue:[NSNumber numberWithInteger:groupId] forKey:@"groupId"];

        if (groupNameRef != NULL) {
            [groupInfo setValue:(__bridge NSString *)groupNameRef forKey:@"name"];
            CFRelease(groupNameRef);
        }

        [groups addObject:groupInfo];
    }

    CFRelease(groupsRef);
    CFRelease(addressBookRef);

    [self.delegate groupServiceDidFindGroups:groups];
}
```

이렇게 코드를 작성하고 빌드하려고 하면 다음과 같은 에러 메세지를 만나게 된다. warning은 현재 메소드를 선언하고 구현하지 않아서 발생하는 경고기 때문에 이후에 모두 구현하고 나면 사라지게 되어 있다. 하지만 에러는 현재 프로젝트에서 단위테스트하려는 타겟에만 iOS 주소록 API를 사용할수 있는 AddressBook.framework를 포함해서 이와 같이 나타나는 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6baa55b4-f702-4698-95cd-aef016195174)

이제 우리는 실제 앱을 실행될 프로덕트 타겟을 선택해서 AddressBook.framework를 추가하도록 한다. 이렇게 타겟에다 AddressBook.framework를 추가하면 링크 에러는 사라지게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d96a3ce0-aac0-438e-ab90-388242fd4716)

이제 우리는 SFGroupService의 나머지 메소드들을 더 구현할 것이다. 다음은 그룹을 추가하기 위한 -addGroupWithName: 메소드를 구현한다.

```objective-c
-(void)addGroupWithName:(NSString *)name
{
    CFErrorRef errorRef = NULL;
    ABAddressBookRef addressBookRef = ABAddressBookCreate();

    ABRecordRef groupRef = ABGroupCreate();

    CFStringRef nameRef = (__bridge CFStringRef)name;
    ABRecordSetValue(groupRef, kABGroupNameProperty, nameRef, &errorRef);

    ABAddressBookAddRecord(addressBookRef, groupRef, &errorRef);
    ABAddressBookSave(addressBookRef, &errorRef);

    CFRelease(groupRef);
    CFRelease(addressBookRef);

    if (errorRef != NULL) {
        NSError *error = (__bridge NSError *)errorRef;
        [self.delegate groupServiceDidFailWithError:error];
        CFRelease(errorRef);
    }

    [self.delegate groupServiceDidAddGroup];
}
```

다음은 그룹을 삭제하기 위한 메소드 -deleteGroupWithGroupId: 메소드를 구현한다.

```objective-c
- (void)deleteGroupWithGroupId:(NSInteger)groupId
{

    CFErrorRef errorRef = NULL;

    ABAddressBookRef addressBookRef = ABAddressBookCreate();

    ABRecordRef savedGroupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);

    if (savedGroupRef != NULL) {
        ABAddressBookRemoveRecord(addressBookRef, savedGroupRef, &errorRef);
        ABAddressBookSave(addressBookRef, &errorRef);

        savedGroupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
    }


    if (errorRef != NULL) {
        NSError *error = (__bridge NSError *)errorRef;
        [self.delegate groupServiceDidFailWithError:error];


        CFRelease(errorRef);
    }

    CFRelease(addressBookRef);
    [self.delegate groupServiceDidDeleteGroup];
}

```

마지막으로 -updateGroupWithName:groupId: 메소드를 구현해보자. 이전 아티클에서 update에 관한 테스트는 하지 않았지만 방법은 groupId와 해당되는 ABRecordRef를 찾아서 이름을 변경시키고 다시 ABAddressBook을 저장하면 된다. 다음 코드를 보고 확인하자

```objective-c
-(void)updateGroupWithName:(NSString *)name groupId:(NSInteger)groupId
{
    CFErrorRef errorRef = NULL;

    ABAddressBookRef addressBookRef = ABAddressBookCreate();

    ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);

    if (groupRef != NULL) {
        CFStringRef nameRef = (__bridge CFStringRef)name;
        ABRecordSetValue(groupRef, kABGroupNameProperty, nameRef, &errorRef);
        ABAddressBookSave(addressBookRef, &errorRef);
    }


    if (errorRef != NULL) {
        NSError *error = (__bridge NSError *)errorRef;
        [self.delegate groupServiceDidFailWithError:error];

        CFRelease(errorRef);
    }

    CFRelease(addressBookRef);
    [self.delegate groupServiceDidUpdateGroup];
}
```

이렇게 만든 SFGroupService를 뷰 컨트롤러에서 사용하기 위해서 SFGroupsTableViewController.h에 다음과 같이 추가한다.

```objective-c
//
//  SFGroupsTableViewController.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFGroupService.h"

@interface SFGroupsTableViewController : UITableViewController<SFGroupServiceDelegate>
{
    SFGroupService *groupService;
}
@end
```


다음 SFGroupService를 사용하기 위해서 alloc을하고 delegate를 지정한다. 그리고 delegate 메소드를 추가한다. SFGroupsTableViewController.m을 열어서 다음 코드들을 추가한다.

```objective-c
...생략..

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        groupService = [[SFGroupService alloc] init];
        groupService.delegate = self;
    }

    return self;
}

...생략...

#pragma mark - SFGroupService delegate methods
- (void)groupServiceDidFailWithError:(NSError *)error
{

}

- (void)groupServiceDidFindGroups:(NSArray *)groups
{

}

- (void)groupServiceDidAddGroup
{

}

- (void)groupServiceDidDeleteGroup
{

}

- (void)groupServiceDidUpdateGroup
{

}
```

SFGroupsTableViewController가 열리면 가장 먼저 현재 주소록의 그룹을 찾아와서 그룹을 목록화 하는 일을 해야한다. 그래서 -viewDidLoad에서 -findAllGroups를 호출한다. 그리고 목록에 필요한 데이터소스를 저장하기 위해서 NSMutableArray 타입의 items를 선언해서 사용한다. 이렇게 저장된 items를 사용해서 UITableView의 data source와 delegate를 이용해서 목록을 UITableView 위에 나타나게 한다.

```objective-c
//
//  SFGroupsTableViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupsTableViewController.h"

@interface SFGroupsTableViewController ()
{
    NSMutableArray *items;
}
- (IBAction)onAddButton:(id)sender;
- (IBAction)onEditButton:(id)sender;
@end

@implementation SFGroupsTableViewController

... 생략 ...

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"주소록 그룹";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButton:)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGroupEditorViewControllerNotification:) name:@"SFGroupEditorViewControllerNotification" object:nil];


    [groupService findAllGroups];
}

... 생략 ...

#pragma mark - SFGroupService delegate methods
- (void)groupServiceDidFailWithError:(NSError *)error
{
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)groupServiceDidFindGroups:(NSArray *)groups
{
    items = [NSMutableArray arrayWithArray:groups];
    [self.tableView reloadData];
}

... 생략 ...

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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[items objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
}

... 생략 ...
```

이제 빌드하고 실행해보면 우리가 전 아티클에서 만든 테스트그룹이 보일 것이다. 아니면 아이폰 주소록에 이미 포함되어져 있는 그룹들이 목록으로 나타난것을 확인할 수 있을 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f9158b46-7a37-41be-a014-13b66d1cedc3)

이제 "+" 버튼을 누르면 새로운 그룹을 생성할 수 있는 SFGroupEditorViewController를 추가해보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d1bec68a-760a-4167-b8cb-2944d6524cd1)

SFGroupEditorViewController는 그룹이름을 입력받을 수 있는 UITextField로 구성되어 있다. SFGroupEditorViewController.m 파일을 열어서 다음 코드를 추가한다.

```objective-c
//
//  SFGroupEditorViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupEditorViewController.h"

@interface SFGroupEditorViewController ()
{
    IBOutlet UITextField *textField;
}
- (IBAction)onDoneButton:(id)sender;
- (IBAction)onCancelButton:(id)sender;
@end

... 생략 ...

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"새로운 그룹";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelButton:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    textField = nil;
}

... 생략 ...

#pragma mark - IBAction handlers
- (IBAction)onDoneButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onCancelButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

... 생략 ...

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;


        textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.adjustsFontSizeToFitWidth = YES;
        textField.textColor = [UIColor blackColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.textAlignment = UITextAlignmentLeft;

        textField.clearButtonMode = UITextFieldViewModeAlways;
        [textField setEnabled: YES];
        [cell addSubview:textField];
        [textField becomeFirstResponder];

        textField.placeholder = @"그룹명을 입력하세요";

    }

    cell.textLabel.text = @"그룹명";

    return cell;

}
```

이제 SFGroupsTableViewController 에서 -onAddButton: 메소드에서 SFGroupEditorViewController를 나타나게 하는 코드를 추가한다.

```objective-c
//
//  SFGroupsTableViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupsTableViewController.h"
#import "SFGroupEditorViewController.h"

... 생략...
#pragma mark - IBAction henadler
- (IBAction)onAddButton:(id)sender
{
    SFGroupEditorViewController *groupEditorViewController = [[SFGroupEditorViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:groupEditorViewController];
    [self presentModalViewController:navigationController animated:YES];
}

```

다시 빌드하고 실행시켜보자. 그리고 SFGroupsTableViewController의 "+" 버튼을 누르면 modalViewController로 그룹명을 입력시킬 수 있는 창이 나타날 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/17c9ff5b-4d07-4c36-bf1d-71be745033e0)

여기서 우리는 그룹을 새로 추가하기 위해서 -addGroupWithName: 을 가진 SFGroupService를 SFGroupEditorViewController에 추가해줘야한다. 하지만 같은 객체를 또한번 만들어주거나 새로운 뷰 컨트롤러에 파라미터로 넘기지 않고 에디터 뷰 컨트롤러 자체를 그냥 단순하게 데이터를 입력시키는 컨트롤러로만 사용하고 싶을 경우는 데이터 처리를 SFGroupsTableViewController에 넘겨서 처리할 수 있기도 하다. 그래서 우리는 이렇게 다른 뷰 컨트롤러에게 또는 다른 객체에게 메세지를 전송하기 위해서 NSNotificationCenter를 이용할 것이다. 우선 SFGroupsTableViewController에 Notification을 사용할 수 있도록 등록을 한다. 이때 Notification 메세지를 받게 되면 userInfo로 넘겨온 데이터 중에서 groupName 키의 값을 가지고 -addGroupWithName: 메소드를 실행하고 이 메소드가 실행하고 난 다음에 delegate로 위임하게 되는 delegate  메소드 -groupServiceDidAddGroup 메소드에서 저장후 다시 목록을 갱신시키기 위해서 -findAllGroups 메소드를 호출하게 한다.

```objective-c
//
//  SFGroupsTableViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupsTableViewController.h"
#import "SFGroupEditorViewController.h"

@interface SFGroupsTableViewController ()
{
    NSMutableArray *items;
}
- (IBAction)onAddButton:(id)sender;
- (IBAction)onEditButton:(id)sender;
- (void)receiveGroupEditorViewControllerNotification:(NSNotification *)notification;
@end

@implementation SFGroupsTableViewController

... 생략 ...


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"주소록 그룹";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButton:)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGroupEditorViewControllerNotification:) name:@"SFGroupEditorViewControllerNotification" object:nil];


    [groupService findAllGroups];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SFGroupEditorViewControllerNotification" object:nil];
}

... 생략 ...

#pragma mark - NSNotification handlers
- (void)receiveGroupEditorViewControllerNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *groupName = [userInfo valueForKey:@"groupName"];

    [groupService addGroupWithName:groupName];
}

#pragma mark - IBAction henadler
- (IBAction)onAddButton:(id)sender
{
    SFGroupEditorViewController *groupEditorViewController = [[SFGroupEditorViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:groupEditorViewController];
    [self presentModalViewController:navigationController animated:YES];
}

- (IBAction)onEditButton:(id)sender
{

}

#pragma mark - SFGroupService delegate methods
- (void)groupServiceDidFailWithError:(NSError *)error
{
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)groupServiceDidFindGroups:(NSArray *)groups
{
    items = [NSMutableArray arrayWithArray:groups];
    [self.tableView reloadData];
}

- (void)groupServiceDidAddGroup
{
    [groupService findAllGroups];
}

... 생략 ...

@end
```

이렇게 NSNotificationCenter에 "SFGroupEditorViewControllerNotification"으로 등록을 했으면 SFGroupEditorViewController에서 새로운 이름을 입력하고 Done 버튼을 누르면 NSNotificationCenter로 post 하여 메소드를 전송시킨다. SFGroupEditorViewController.m 파일에 다음 코드를 추가한다.

```objective-c
#pragma mark - IBAction handlers
- (IBAction)onDoneButton:(id)sender
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:textField.text forKey:@"groupName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SFGroupEditorViewControllerNotification" object:nil userInfo:userInfo];
    [self dismissModalViewControllerAnimated:YES];
}
```

다시 빌드후 실행을 해보자. 새로운 그룹명을 입력하고 "Done" 버튼을 누르면 새로운 그룹이 추가된 목록을 확인할 수 있게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/3158af3a-8277-4f35-8e99-bac553cb1f43)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/3b9c67b5-8cd8-4119-9d4c-1480732c85aa)

이제 우리는 새로 생성된 그룹을 삭제하는 것을 만들 것이다. 우리는 지금까지 delegate를 이용해서 데이터 처리를 하고 난 다음에 viewController에게 데이터를 가지고 뷰를 구성하는 것을 위임했다. 하지만 delete에서는 조금 다르게 뷰의 animation과 동기적으로 행동하기 위해서 delegate를 구현하는 것이 아니라 객체가 완전히 삭제될때까지 return을 기다렸다가 동작하는 Synchronize 형태의 메소드 진행을 할 것이다. 그래서 우리는 SFGroupService의 -deleteGroupWithGroupId: 메소드를 다음과 같이 수정을 한다.

```objective-c
//
//  SFGroupService.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFGroupServiceDelegate <NSObject>

@required
- (void)groupServiceDidFailWithError:(NSError *)error;
- (void)groupServiceDidFindGroups:(NSArray *)groups;
- (void)groupServiceDidAddGroup;
- (void)groupServiceDidDeleteGroup;
- (void)groupServiceDidUpdateGroup;
@end

@interface SFGroupService : NSObject
{
    id<SFGroupServiceDelegate>delegate;
}
@property (nonatomic, strong) id<SFGroupServiceDelegate>delegate;

- (void)findAllGroups;
- (void)addGroupWithName:(NSString *)name;
- (void)deleteGroupWithGroupId:(NSInteger)groupId;
- (BOOL)deleteGroupWithGroupId:(NSInteger)groupId withError:(NSError **)error;
- (void)updateGroupWithName:(NSString *)name groupId:(NSInteger)groupId;

@end
```

```objective-c
- (BOOL)deleteGroupWithGroupId:(NSInteger)groupId withError:(NSError *__autoreleasing *)error
{
    BOOL success = NO;

    CFErrorRef errorRef = NULL;

    ABAddressBookRef addressBookRef = ABAddressBookCreate();

    ABRecordRef savedGroupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);

    if (savedGroupRef != NULL) {
        ABAddressBookRemoveRecord(addressBookRef, savedGroupRef, &errorRef);
        ABAddressBookSave(addressBookRef, &errorRef);

        savedGroupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
    }


    if (errorRef != NULL) {
        *error = (__bridge NSError *)errorRef;
        success = NO;
        CFRelease(errorRef);
    } else {
        success = YES;
    }

    CFRelease(addressBookRef);
    return success;
}

- (void)deleteGroupWithGroupId:(NSInteger)groupId
{

    NSError *error;

    if (error) {
        [self deleteGroupWithGroupId:groupId withError:&error];
    } else {
        [self.delegate groupServiceDidDeleteGroup];
    }

}
```

이제 이렇게 동기방식의 delete 메소드를 추가한 다음에는 SFGroupsViewController의 UITableView에서 삭제 로직을 추가해보자. -onEditButton: 메소드에 액션이 실행되면 상단의 버튼들이 사라지고 "Cancel" 버튼만 생기기 될 것이다. 그리고 UITableView는 editing 모드로 변환 될 것이다. 그리고 삭제 버턴을 누르면 groupService의 -deleteGroupWithGropuId:withError: 메소드기 실행되고 return으로 YES를 반환하면 items에 해당 데이터를 삭제하고 UITableView를 에니메이션 효과를 내며 해당 셀을 삭제하게 된다.

```objective-c
//
//  SFGroupsTableViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupsTableViewController.h"
#import "SFGroupEditorViewController.h"

@interface SFGroupsTableViewController ()
{
    NSMutableArray *items;
}
- (IBAction)onAddButton:(id)sender;
- (IBAction)onEditButton:(id)sender;
- (IBAction)onCancelButton:(id)sender;
- (void)receiveGroupEditorViewControllerNotification:(NSNotification *)notification;
@end

@implementation SFGroupsTableViewController

... 생략 ...

#pragma mark - IBAction henadler
- (IBAction)onAddButton:(id)sender
{
    SFGroupEditorViewController *groupEditorViewController = [[SFGroupEditorViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:groupEditorViewController];
    [self presentModalViewController:navigationController animated:YES];
}

- (IBAction)onEditButton:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelButton:)];
    [self.tableView setEditing:YES animated:YES];
}

- (IBAction)onCancelButton:(id)sender
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButton:)];

    [self.tableView setEditing:NO animated:YES];
}


... 생략 ...


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSError *error;
        NSDictionary *groupInfo = [items objectAtIndex:indexPath.row];
        NSInteger groupId = [[groupInfo valueForKey:@"groupId"] integerValue];
        BOOL success = [groupService deleteGroupWithGroupId:groupId withError:&error];

        if (success) {
            [items removeObject:groupInfo];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            NSLog(@"error : %@", [error localizedDescription]);
        }

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

... 생략 ...
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/35245077-db9d-400a-ae42-a4e9bcbddb92)

이제 마지막으로 그룹 이름을 변경해야하는데 우리는 그룹을 추가할 때 사용한 SFGroupEditorViewController를 다시 사용할 것이다. 그룹명을 수정하기 위해서는 groupId와 기존의 groupName이 필요하다. items는 groupId와 groupName을 가지고 있기 때문에 UITableView가 editing 모드일때 해당 cell을 선택하면 그룹편집창 (SFGroupEditorViewController)가 활성화되면서 기존의 내용을 가지고 편집할 수 있는 준비를 하면 된다. 그리고 수정후 "Done" 버튼을 누르면 NSNotificationCenter를 이용해서 메시지를 전송해서 처리하도록 한다.

```objective-c
//
//  SFGroupsTableViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupsTableViewController.h"
#import "SFGroupEditorViewController.h"

... 생략 ...

@implementation SFGroupsTableViewController

... 생략 ...


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"주소록 그룹";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButton:)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGroupEditorViewControllerNotification:) name:@"SFGroupEditorViewControllerNotification" object:nil];

    self.tableView.allowsSelectionDuringEditing = YES;

    [groupService findAllGroups];
}

... 생략 ...

#pragma mark - NSNotification handlers
- (void)receiveGroupEditorViewControllerNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *groupName = [userInfo valueForKey:@"name"];

    if ([[userInfo valueForKey:@"editMode"] isEqualToString:@"add"]) {
        [groupService addGroupWithName:groupName];
    } else {
        NSInteger groupId = [[userInfo valueForKey:@"groupId"] integerValue];
        [groupService updateGroupWithName:groupName groupId:groupId];
    }
}

... 생략 ...

#pragma mark - SFGroupService delegate methods
- (void)groupServiceDidFailWithError:(NSError *)error
{
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)groupServiceDidFindGroups:(NSArray *)groups
{
    items = [NSMutableArray arrayWithArray:groups];
    [self.tableView reloadData];
}

- (void)groupServiceDidAddGroup
{
    [groupService findAllGroups];
}

- (void)groupServiceDidDeleteGroup
{

}

- (void)groupServiceDidUpdateGroup
{
    [groupService findAllGroups];
}

#pragma mark - Table view data source

... 생략 ...

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView.editing) {
        NSDictionary *groupInfo = [items objectAtIndex:indexPath.row];

        SFGroupEditorViewController *groupEditorViewController = [[SFGroupEditorViewController alloc] initWithGroupInfo:groupInfo];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:groupEditorViewController];
        [self presentModalViewController:navigationController animated:YES];

    }
}

@end
```

다음은 SFGroupEditorViewController에서 그룹 수정일때와 새로운 그룹 추가할때의 설정을 위해 다음 코드를 추가한다.

```objective-c
//
//  SFGroupEditorViewController.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFGroupEditorViewController : UITableViewController
{
    NSDictionary *groupInfo;
}
- (id)initWithGroupInfo:(NSDictionary *)aGroupInfo;
@end
```

이제 빌드하고 실행을 시켜서 "Edit" 버튼을 선택하고 UITableView가 editing 모드일때 Cell을 선택하면 해당 그룹명을 수정할 수 있도록 SFGroupEditorViewController가 열리게 된다 그리고 수그룹 이름을 수정하고 "Done" 버튼을 누르면 해당 그룹명이 업데이트 되어지고 업데이트 후에 호출되는 -groupServiceDidUpdateGroup에서 -findAllGroups를 다시 호출해서 변경된 그룹명이 목록에 나타나게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f4e63138-a8d8-46bc-a277-fa118fd9f917)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/fd34dd63-29f5-4031-a2ca-bb572810a0c0)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7a82e00c-28e9-4e1d-bb20-fc60220f8897)]

## 소스

https://github.com/saltfactory/Saltfactory_iOS_Tutorial/tree/t6-addressbook-group

## 참고

1. http://developer.apple.com/library/ios/#documentation/uikit/reference/UITableVi

