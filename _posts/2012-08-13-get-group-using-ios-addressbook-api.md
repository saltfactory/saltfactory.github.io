---
layout: post
title: iOS 주소록 API를 이용하여 그룹별 연락처 조회하기
category: ios
tags: [ios, api, sdk, group, addressbook, contacts, objective-c]
comments: true
redirect_from: /169/
disqus_identifier : http://blog.saltfactory.net/169
---

우리는 앞서 [iOS 주소록 API를 이용하여 아이폰 주소록 그룹 다루기](http://blog.saltfactory.net/167) 와  [iOS 주소록 API를 이용하여 아이폰 주소록 그룹 뷰컨트롤러 연결하기](http://blog.saltfactory.net/168)편 에서 iOS의 AdddressBook.framework를 이용해서 주소록 데이터 중에서 그룹에 관련된 작업을 처리하는 방법에 대해서 함께 테스트하였다. 이번 포스팅은 주소록에서 연락처 조회에 관한 방법에 대해서 살펴볼 것이다. 테스트를 위해서 프로젝트를 생성해야한다. 지금까지 iOS  주소록 API 에 관련된 글을 계속 같이 해왔더라면 다음과 같이 github 에서 소스코드를 clone 하여 사용하면 된다.

<!--more-->

## 소스코드 clone

```
git clone https://github.com/saltfactory/Saltfactory_iOS_Tutorial.git
```

```
checkout -t origin/t6-addressbook-group
```

위 소스가 이 포스팅 이전의 소스코드들이다. 이 소스코드에서 이어서 함께 진행하면 된다. 만약 zip이나 tar 형태로 다운로드 받아서 테스트하길 원하는 분들은 https://github.com/saltfactory/Saltfactory_iOS_Tutorial/tags 에서 t6-addressbook-group 의 zip이나 tar.gz을 다운받아서 사용하면 된다.

앞이서 우리는 그룹에 관한 데이터 처리를 하기 위해서 SFGroupService라는 것을 만들었다. 마찬가지로 우리는 연락처에 대한 작업을 처리하기 위해서 SFContactService라는 객체를 만들어서 사용할 것이다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/43ad7992-e56f-48e3-ae81-7c348cce0832)

이 포스트 이전에 우리는 SFGroupService에서 그룹 목록을 출력시키는 기능을 구현했었다. UITableView에 그룹 목록들이 나타나는데, 해당 그룹을 선택하여 Cell을 선택하면 groupId를 가지고 그룹을 찾아서 그 그룹에 해당된 연락처를 조회해서 이름을 출력시키도록 해보자.

```objective-c
//
//  SFContactService.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFContactServiceDelegate <NSObject>

@required
- (void)contactServiceDidFailWithError:(NSError *)error;
- (void)contactServiceDidFindContacts;
@end

@interface SFContactService : NSObject
{
    id<SFContactServiceDelegate>delegate;
}
@property (nonatomic, strong) id<SFContactServiceDelegate>delegate;
- (void)findContactsWithGroupId:(NSInteger)groupId;
@end
```

ABAddressBook에서 groupId로  그룹을 찾는다는 것은 ABRecordRef를 찾는 다는 말과 같다. ABRecordRef는 ABAddressBookGetGroupWithRecrodID 함수로 찾아낼 수 있다. 그리고 ABGroupCopyArrayOfAllMembers라는 함수는 ABRecord 에 포함되는 멤버를 CFArrayRef 형태로 배열을 리턴하게 되는데 이 배열을 순차적으로 탐색하면서 각각 해당되는 ABRecordRef 정보를 CFArrayGetValueAtIndex로 찾아서 조회할 수 있다.

```objective-c
//
//  SFContactService.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFContactService.h"
#import <AddressBook/AddressBook.h>
@implementation SFContactService
@synthesize delegate;


- (void)findContactsWithGroupId:(NSInteger)groupId
{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();

    ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
    CFArrayRef membersRef = ABGroupCopyArrayOfAllMembers(groupRef);

    NSMutableArray *contacts = [NSMutableArray array];

    if (membersRef != NULL) {
        for (int i= 0; i < CFArrayGetCount(membersRef); i++) {
            NSMutableDictionary *personInfo = [NSMutableDictionary dictionary];

            ABRecordRef personRef = CFArrayGetValueAtIndex(membersRef, i);

            NSInteger personId = ABRecordGetRecordID(personRef);

            [personInfo setValue:[NSNumber numberWithInteger:personId] forKey:@"personId"];


            CFStringRef lastName = ABRecordCopyValue(personRef, kABPersonLastNameProperty);
            if (lastName != NULL) {
                [personInfo setValue:(__bridge NSString *) lastName forKey:@"lastName"];
                CFRelease(lastName);
            }

            CFStringRef firstName = ABRecordCopyValue(personRef, kABPersonFirstNameProperty);
            if (firstName != NULL) {
                [personInfo setValue:(__bridge NSString *) firstName forKey:@"firstName"];
                CFRelease(firstName);
            }

            [contacts addObject:personInfo];
        }
        CFRelease(membersRef);
    };

    CFRelease(addressBookRef);

    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [contacts sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    [self.delegate contactServiceDidFindContacts:contacts];
}
@end
```

앞의 글에서 그룹을 목록화 해서 사용했던 SFGroupTableViewController의 Cell을 선택하면 그 그룹에 해당되는 멤버들의 연락처들을 보기 위해서 SFContactsTableViewController를 추가하도록 하자.

![](http://asset.blog.hibrainapps.net/saltfactory/images/6706bc8b-d757-44ba-b691-3b0332078ec4)

이 SFContacatsTableViewController는 SFGroupTableViewController의 cell을 선택하면 navigationViewController로 뷰를 push 하도록 하기 위해서 SFGroupTableViewController.m 파일에 다음 코드를 추가한다.

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
#import "SFContactsTableViewController.h"

... 생략 ...

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */

    NSDictionary *groupInfo = [items objectAtIndex:indexPath.row];

    if (tableView.editing) {

        SFGroupEditorViewController *groupEditorViewController = [[SFGroupEditorViewController alloc] initWithGroupInfo:groupInfo];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:groupEditorViewController];
        [self presentModalViewController:navigationController animated:YES];

    } else {
        SFContactsTableViewController *contactsTableViewController = [[SFContactsTableViewController alloc] initWithGroupInfo:groupInfo];
        [self.navigationController pushViewController:contactsTableViewController animated:YES];
    }
}

@end
```

다음은 SFContactsTAbleViewController에 -initWithGroupInfo: 를 추가하여 초기화 할 때 그룹 정보를 가져올 수 있도록 다음과 같이 코드를 추가한다.

```objective-c
//
//  SFContactsTableViewController.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/14/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFContactsTableViewController : UITableViewController
{
    NSDictionary *groupInfo;
}
- (id)initWithGroupInfo:(NSDictionary *)aGroupInfo;
@end

```

```objective-c
//
//  SFContactsTableViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/14/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFContactsTableViewController.h"

@interface SFContactsTableViewController ()

@end

@implementation SFContactsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithGroupInfo:(NSDictionary *)aGroupInfo
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        groupInfo = aGroupInfo;
    }

    return self;
}

... 생략 ...
@end
```

이제 우리가 그룹에 속하는 연락처들을 가져오기 위해서 만든 SFContactService 를 추가해보자.

```objective-c
//
//  SFContactsTableViewController.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/14/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFContactService.h"

@interface SFContactsTableViewController : UITableViewController<SFContactServiceDelegate>
{
    NSDictionary *groupInfo;
    SFContactService *contactService;
}
- (id)initWithGroupInfo:(NSDictionary *)aGroupInfo;
@end
```
```objective-c
//
//  SFContactsTableViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/14/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFContactsTableViewController.h"

@interface SFContactsTableViewController ()
{
    NSMutableArray *items;
}
@end

@implementation SFContactsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithGroupInfo:(NSDictionary *)aGroupInfo
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        groupInfo = aGroupInfo;
        contactService = [[SFContactService alloc] init];
        contactService.delegate = self;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [groupInfo valueForKey:@"name"];

    NSInteger groupId = [[groupInfo valueForKey:@"groupId"] integerValue];
    [contactService findContactsWithGroupId:groupId];
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

#pragma mark - SFContactService delegate method
- (void)contactServiceDidFailWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

- (void)contactServiceDidFindContacts:(NSArray *)contacts
{
    items = [NSMutableArray arrayWithArray:contacts];
    [self.tableView reloadData];
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDictionary *contactInfo = [items objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [contactInfo valueForKey:@"lastName"], [contactInfo valueForKey:@"firstName"]];

    return cell;
}
... 생략 ...

@end
```
iOS 시뮬레이터를 열고 테스트를 위해서 특정 그룹에 연락처를 추가해보자. 앞의 예제에서 만들었던 "창원대학교" 그룹에 연락처를 하나 추가했다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/be370277-cfd5-4334-a4ed-dfb60754057d)

이제 수정한 코드를 위해서 빌드하고 실행을 해보자.
다음과 같이 그룹 목록이 나오는 SFGroupTableViewController에서 "창원대학교"에 해당하는 Cell을 선택하면 SFContactsTableViewController가 navigationController에 push 되면서 "창원대학교에" 해당하는 연락처들을 조회해서 lastName과 firstName을 조합해서 UITableView에 나타내어 주게 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/e8600f3f-7fa1-4e62-88fb-9116bb295126)

![](http://asset.blog.hibrainapps.net/saltfactory/images/797163b0-a1fa-44f4-bb2a-90b79e13ac51)

## 결론

이번 포스팅에서는 간단하게 그룹별 연락처들의 목록을 조회하는 코드를 추가했다. 다음 포스팅에서는 그룹에 속한 연락처 목록을 조회한 뒤에 연락처 하나하나를 선택할 경우 연락처에 대한 자세한 정보를 출력하는 것에 대해서 포스팅을 할 에정이다. 이 포스팅에서 연락처 상세 조회까지 다루기에는 연락처 상세 조회에 대한 내용이 많기 때문에 분리하게 되었다. 이번 포스팅의 핵심은 그룹별 연락처를 조회할 때 groupId를 사용하는 것이다. 그리고 ABAddressBookGetGroupWithRecordID 함수를 이용해서 ABRecordRef 타입인 그룹 정보를 가져와서 ABGroupCopyArrayOfAllMembers 함수를 이용해서 NSArrayRef 형태의 연락처들의 정보를 배열로 가져올 수 있다는 것이다. 그리고 이 배열을 CFArrayGetValueAtIndex 함수를 이용해서 순차적으로 해당되는 연락처정보를 ABRecordRef 타입으로 가져와서 가각 해당되는 속성을 키 값으로 찾아오는데 있다. 이때 lastName의 키 값은 kABpersonLastNameProperty 이고 firstName의 키 값은 kABPersonFirstNameProperty 로 접근할 수 있다.


## 소스

*  https://github.com/saltfactory/Saltfactory_iOS_Tutorial/zipball/t7-addressbook-contact-findContactWithGroupId

