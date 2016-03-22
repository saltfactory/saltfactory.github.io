---
layout: post
title : NSPredicate를 이용하여 배열안의 내용검색하기
category : ios
tags : [ios, objective-c]
comments : true
redirect_from: /122/
disqus_identifier : http://blog.saltfactory.net/122
---

## 서론

데이터베이스를 이용하면 복잡한 데이터를 구조적으로 잘 저장하고 SQL이라는 대화형 언어로 원하는 데이터를 쉽게 가져올 수 가 있다. 상대적으로 파일 시스템에서 원하는 내용을 검색하기란 그렇게 쉬운 작업이 아니다. 그래서 우리는 iPhone에서 SQLite를 이용해서 데이터를 저장하고 검색하는데 사용하고 있다. 이러한 SQLite, XML의 구조적인 형태의 데이터 저장을 iPhone이나 Cocoa 프로그램에 사용할 수 있게 CoreData 라는 프레임워크를 이용해서 접근할 수 있는데, 이때 SQL의 조건절을 사용하듯, NSPredicate를 이용하여 원하는 데이터를 가져올 수 있게 필터링할 수 있다. (이후에 CoreData에 대한 포스팅을 따로 준비할 예정이다.) https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CoreData/Articles/cdFetching.html 에서 애플 개발자 다큐먼트에 공식적으로 공개한 NSPredicate의 예제를 확인 할 수 있다.

<!--more-->

```objective-c
NSManagedObjectContext *moc = [self managedObjectContext];
NSEntityDescription *entityDescription = [NSEntityDescription
                                          entityForName:@"Employee" inManagedObjectContext:moc];
NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
[request setEntity:entityDescription];

// Set example predicate and sort orderings...
NSNumber *minimumSalary = ...;
NSPredicate *predicate = [NSPredicate predicateWithFormat:
                          @"(lastName LIKE[c] 'Worsley') AND (salary > %@)", minimumSalary];
[request setPredicate:predicate];

NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                    initWithKey:@"firstName" ascending:YES];
[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
[sortDescriptor release];

NSError *error = nil;
NSArray *array = [moc executeFetchRequest:request error:&error];
if (array == nil)
{
    // Deal with error...
}
```

소스 코드를 살펴보면 Employee라는 테이블에서 lastname이라는 컬럼에 'Worsley'가 포함되어 있고, salary 값이 minnumSalary보다 큰 경우를 NSPredicate로 지정을 한다. 그리고 NSFetchRequest를 요청할 때 조건으로 만들어둔 NSPredicate를 적용하여 데이터를 검색하는 것을 확인 할 수 있다. 이것은 간단하게 SQL로 표현하면 다음과 같을 것이다.

```sql
SELECT * from employees WHERE lastname LIKE '%Worsley%' AND salary > mininumSallery
```

NSPredicate는 이렇게 NSFetchRequest에서 조건을 추가하기 위해서 사용하는 것으로만 알고 있는 사용자들이 많을 것이다. 이는 현재 판매되고 있는 아이폰 개발 도서에 대부분 CoreData 섹션 부분에서만 나오기 때문인데, 사실은 NSPredicate (https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSPredicate_Class/Reference/NSPredicate.html)를 살펴보면 검색 조건을 사용해서 페칭하거나 메모리 상의 데이터를 필터링하는 논리적인 조건을 정의하는 객체이다. 여기서 메모리 상의 데이터를 검색할 수 있다는 말이 나오는데 우리가 흔히 메모리상에 데이터가 논리적으로 저장되어 있는 것은 변수라고 하고 이러한 변수 중에서도 데이터의 집합을 가지고 있는 것은 배열로 알고 있다. 그럼 NSPredicate를 이용하여 배열안에 데이터를 검색할 수 있다는 말이 된다는 것을 눈치 챘을 것이다. NSPredicate를 사용하기 전에 간단한 예제를 살펴보자.

우리는 흔히 배열 속에서 데이터를 찾기 위해서 Loop를 이용해서 데이터를 순차적으로 탐색해서 검색하는 프로그램을 작성해야만 했다.
다음 예를 살펴보자.

```objective-c
//
//  CWNUMapTests.h
//  CWNUMapTests
//
//  Created by SungKwang Song on 4/2/12.
//  Copyright (c) 2012 saltfactory@me.com. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface CWNUMapTests : SenTestCase
{
    NSArray *array;
}
- (void)testSearchTextFromArray;
- (void)testPredicateTextFromArray;
@end


- (void)setUp
{
    [super setUp];

    // Set-up code here.
    array = [NSArray arrayWithObjects:@"aaa", @"abc", @"bbb", @"ccc", nil ];
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void)testSearchTextFromArray
{

    NSString *name = @"bbb";
    NSMutableArray *fetchedArray = [NSMutableArray array];

    for (int i = 0; i< [array count]; i++) {
        if ([[array objectAtIndex:i] isEqualToString:name]) {
            [fetchedArray addObject:[array objectAtIndex:i]];
        }
    }

    NSLog(@"find %@ from array", fetchedArray);
}
```

이렇게 고전적으로 작성하던 for 문을 NSPredicate로 소스를 간소화 시킬 수 있다.

```objective-c
- (void)testPredicateTextFromArray
{
    NSString *name = @"bbb";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", name];
    NSArray *fetchedArray = [array filteredArrayUsingPredicate:predicate];

    NSLog(@"find %@ using predicate", fetchedArray);
}

```

NSArray에는 -filteredArrayUsingPredicate: 라는 메소드가 존재한다. 외부에서 NSPredicate를 사용하여 조건을 명시적으로 작성한 다음 배열객체에 포함되어 있는 -filteredArrayUsingPredicate:를 이용하여 원하는 데이터의 집합을 반환할 수 있다. 위에서 사용한 SELF 라는 키워드는 배열의 객체 하나의 자체를 나타내고 있다. 위의 예제는 단순하게 NSString의 배열이기 때문에 조건에 lastName 같은 필드명을 넣을 수 가 없다. 이러한 경우에는 배열 하나하나 그 자체인 SELF라는 것을 이용해서 객체를 비교할 수 있게 되는 것이다.

만약 필드를 가지는 객체를 배열로 저장되어 있고 그 배열 속에서 특정 필드의 값에 가지고 검색하려고 한다고 생각해보자.

```objective-c
- (void)setUp
{
    [super setUp];

    // Set-up code here.
    //array = [NSArray arrayWithObjects:@"aaa", @"abc", @"bbb", @"ccc", nil ];
    array = [NSArray arrayWithObjects:
             [NSDictionary dictionaryWithObject:@"aaa" forKey:@"name"],
             [NSDictionary dictionaryWithObject:@"abc" forKey:@"name"],
             [NSDictionary dictionaryWithObject:@"bbb" forKey:@"name"],
             [NSDictionary dictionaryWithObject:@"ccc" forKey:@"name"],
             nil ];

}
```

역시나 Loop를 이용하여 프로그램을 작성했다면 다음과 같이 검색하는 코드를 작성했을 것이다.

```objective-c
- (void)testSearchNameFromArray
{
    NSMutableArray *fetchedArray = [NSMutableArray array];
    NSString *name = @"bbb";
    for (int i = 0; i< [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        if ([[dic valueForKey:@"name"] isEqualToString:name]) {
            [fetchedArray addObject:dic];
        }
    }

    NSLog(@"find %@ from array", fetchedArray);

}
```

이렇게 필드명이 있는 경우, 그 중에서도 NSDictionary의 집합으로 구성되어 있는 배열에서 데이터를 검색할 때 다음과 같이 사용한다.

```objective-c
- (void)testPredicateNameFromArray
{
    NSString *name = @"bbb";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *fetchedArray = [array filteredArrayUsingPredicate:predicate];

    NSLog(@"find %@ using predicate", fetchedArray);

}
```

NSPredicate를 이용하면 코드가 훨씬 간결해지는 것을 확인할 수 있다. NSPredicate는 조건을 만들기 위한 syntax가 존재하는데 이것은 https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html 에서 확인 할 수 있다.
여기서 bbb라는 이름을 대문자 BBB로 저장 되어 있거나 소문자가 섞여서 저장되어 있다고 생각해보자. 그러면 아마도 다음과 같이 NSString의 `-uppercaseString:` 이라는 메소드를 이용하여 작성을 하였을 것이다.

```objective-c
- (void)testSearchNameFromArray
{
    NSMutableArray *fetchedArray = [NSMutableArray array];
    NSString *name = @"bbb";
    for (int i = 0; i< [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        if ([[[dic valueForKey:@"name"] uppercaseString] isEqualToString:name]) {
            [fetchedArray addObject:dic];
        }
    }

    NSLog(@"find %@ from array", fetchedArray);

}
```

하지만 NSPredicate를 이용하면 컬럼 안에 있는 데이터를 가져와서 -uppercaseString:을 적용할 수가 없다.


```objective-c
- (void)testPredicateNameFromArray
{
    NSString *name = @"bbb";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *fetchedArray = [array filteredArrayUsingPredicate:predicate];

    NSLog(@"find %@ using predicate", fetchedArray);

}
```

이러한 경우 NSPredicate의 syntax를 사용하면 효과적으로 조건을 만들 수가 있다. == 은 MATCHES 나 LIKE, CONTAINS 로 바꾸어서 사용할 수 있다. MATCHES는 정규 표현식이 매칭되는 것이고 LIKE는 SQL의 like 연산과 동일하고 CONTAINS는 문자열에 포함된 단어가 있는지 확인 할 때 상요하는 것이다. 그리고 c[case insensitive](대 소문자 구분 하지 않음), d[diacritic insensitive](발음기호 구분하지 않음) 옵션을 사용하면 된다.

```objective-c
- (void)testPredicateNameFromArray
{
    NSString *name = @"bbb";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name MATCHES[c] %@", name];
    NSArray *fetchedArray = [array filteredArrayUsingPredicate:predicate];

    NSLog(@"find %@ using predicate", fetchedArray);

}
```

NSDictionary가 아니 사용자가 정의한 클래스가 배열 속에서 집합으로 존재할 때 검색하는 방법을 살표보자.
Person이라는 객체가 있고 name과 age라는 필드가 있고 NSString과  NSInteger 형이라고 생각하자.

```objective-c
@interface Person : NSObject
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSInteger age;
@end

@implementation Person
@synthesize name, age;
- (id)initWithName:(NSString *)aName age:(NSInteger)aAge
{
    self = [super init];

    if (self) {
        name = aName;
        age = aAge;
    }

    return self;
}
@end
```

```objective-c
- (void)setUp
{
    [super setUp];

    // Set-up code here.
    //array = [NSArray arrayWithObjects:@"aaa", @"abc", @"bbb", @"ccc", nil ];
//    array = [NSArray arrayWithObjects:
//             [NSDictionary dictionaryWithObject:@"aaa" forKey:@"name"],
//             [NSDictionary dictionaryWithObject:@"abc" forKey:@"name"],
//             [NSDictionary dictionaryWithObject:@"BBB" forKey:@"name"],
//             [NSDictionary dictionaryWithObject:@"ccc" forKey:@"name"],
//             nil ];
    array = [NSArray arrayWithObjects:
             [[Person alloc] initWithName:@"aaa" age:20],
             [[Person alloc] initWithName:@"abc" age:22],
             [[Person alloc] initWithName:@"BBB" age:26],
             [[Person alloc] initWithName:@"ccc" age:30],
             nil ];
}
```

이렇게 필드명을 가진 배열에서 name이라는 필드로 검색할 때는 앞에서 NSPredicate를 만들어서 사용하던 조건과 동일하다 NSObject를 상속 받은 객체에서 필드의 이름을 가지고 검색을 하기 때문이다.

```objective-c
- (void)testPredicateNameFromArray
{
    NSString *name = @"bbb";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name MATCHES[c] %@", name];
    NSArray *fetchedArray = [array filteredArrayUsingPredicate:predicate];

    NSLog(@"find %@ using predicate", fetchedArray);

}
```

NSPredicate는 조건을 보다 복잡하게 사용자가 정의해서 만들 수가 있는데 이 때 -predicateWithBlock: 을 사용해서 할 수 있다. 사실 이 예제는 궂이 block을 사용하지 않아도 할 수 있지만, block을 사용해서 조건을 만드는 방법을 예제로 들기 위해서 만든 것이다. Person의 만 나이가 25보다 크며 "ccc"라는 이름을 가지는 경우는 참이 되어 해당되는 데이터들을 검색하라는 의미의 조건이다.

```objective-c
- (void)testPredicateBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings){
        return (([[evaluatedObject valueForKey:@"age"] integerValue]-1 > 25) &&  [[evaluatedObject valueForKey:@"name"] isEqualToString:@"ccc"]);
    }];


    NSArray *fetchedArray = [array filteredArrayUsingPredicate:predicate];

    NSLog(@"find %@ using predicate", fetchedArray);

}
```

## 결론

이렇게 배열 객체에도 NSPredicate를 사용할 수 있다. NSPredicate를 이용하면 기존의 for 나 while 등의 Loop를 사용하여 코드를 작성하는 것 보다 보다 간결하게 코드를 작성할 수 있고 객체의 내부의 필드 이름을 가지고 비교할 수 있게 된다. 그리고 block을 이용하여 객체를 검색할 때 객체마다 복잡한 조건이 맞는지를 검사할 수가 있다. NSPredicate를 이용하여 배열안의 내용을 검색할 수 있다는 것을 알고 Loop를 이용하여 검색하는 루틴에 적용하면 좋을 것 같다.

## 참고

1. https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSPredicate_Class/Reference/NSPredicate.html
2. https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html

