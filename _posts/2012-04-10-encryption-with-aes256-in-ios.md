---
layout: post
title: iOS에서 AES256으로 데이터 암호화/복호화하기
category: ios
tags: [ios, encrypt, decrypt, aes256]
comments: true
redirect_from: /118/
disqus_identifier : http://blog.saltfactory.net/118
---

## 서론

iOS는 보안상 자신의 앱에서 접근할 수 있는 Sandbox를 제외하고 접근하면 앱 리뷰에서 reject를 당한다. 보안상 앱이 접근할 수 있는 Diectory는 제한이 되어 있다.  아래 그림은 아이폰 앱에서 접근할 수 있는 Sandbox를 그림으로 표현한 것이다. Documents는 iCloud가 서비스가 오픈되고 나서 부터는 백업이 가능한 디렉토리로 임시 파일을 저장하면 reject의 사유가 된다. Library 안의 Caches 디렉토리에 파일을 저장하면 iCoud 자동 백업 목록에서 제외하여 저장할 수 있도록 되었다.
<!--more-->

![](http://cfile29.uf.tistory.com/image/197AC43F4F83D0AD045FE1)

위 그림과 같이 아이폰 앱들은 각각 Sandbox에 보호되어서 있어서 다른 앱의 Sandbox에 접근할 수 없게 되어 있지만 Jailbreak 를 한 아이폰에서는 다른 디렉토리에 접근이 가능하게 될 수도 있다. 또는 다른 방법으로 다른 앱의 디렉토리에 접근할 수 있는 방법도 있지만 그 내용은 이 포스팅에서 작성하지는 않겠다. 다만 이렇게 일반 텍스트로 파일을 디렉토리에 저장하면 보안상 문제가 생길 수 있다는 것이다.

이런 보안적 취약성을 보완하기 위해서 데이터를 저장할 때 암호화하여 파일을 저장하면 외부 접근이 가능하도 파일을 열수 있는 방법에 제한을 둘 수 있다. 물론 암호화 알고리즘 자체도 크래킹 될 수 있지만 단기간 될 수 있는 것은 아니며 일반 텍스트로 저장되는 것 보다는 1차적으로 보안을 높일 수 있는 방법이다.

MD5나 SHA와 같이 해시 알고리즘을 통해서 간단히 데이터를 비교할 수 도 있지만 해시 함수의 특징상 해시는 복호화 할 수 없는 단방향 암호화이기 때문에 우리는 양방향 암호화를 위해서 AES 암호화 방법을 사용할 것이다. AES(Advanced Encryption Standard)는 미국 정부에서 표준으로 지정된 블록 암호 방식이다. 이전에는 DES 대칭키 암호를 사용했지만 DES의 56비트 암호비트가 현재 컴퓨팅 능력에 비해서 적고, 취약점이 발견되어서 존 데이먼와 빈센트 라이먼(Rijndael)에 의해서 만들어졌다. AES는 128비트로 가지고 있고, 128비트 이상의 32배수 길이의 키를 사용할 수 있다. (128, 160, 192, 224, 256 등)  

Objective-C에서 AES256 encrypt/decrypt에 관한 코드를 검색하면 많은 자료들이 검색될 것이다. 하지만 암호 방식이 공개된 것이지 암호화 키가 없이 암호화 방식만 가지고 복호화하는 것은 어렵기 때문에 공개된 소스코드를 가지고 암호화 메소드를 구현할 수 있다. (어떤 블로그는 공개되어 있는 소스코드를 자신의 것 처럼 다시 블로그에 포스팅하지만 컨텐츠 보호법을 지켜주면서 출처를 밝히거나 라이센스에 주의해서 사용해야 할 것이다.)

대부분 포스팅에 참조된 AES256 암호화 방식은 http://stackoverflow.com/questions/8287727/aes256-nsstring-encryption-in-ios-5 에서 나온 방법과 거의 비슷하다. 여기 소개된 방법에 대한 자세한 설명은 http://robnapier.net/blog/aes-commoncrypto-564 블로그에 포스팅 되어 있다. 여기에서 제안하는 암호화 방법은 애플에서 오픈소스로 공개한 CommonCrypto (http://opensource.apple.com/source/CommonCrypto/)를 이용하여 암호화/복호화를 하는데 이것을 사용하기 위해서는 Secruity.framework를 프로젝트에 포함시키면 사용할 수 있다. (아래 코드는 원 저작권자의 소스코드로 재사용시 원 저작권자의 동의가 필요함 )

```objective-c
#import <CommonCrypto/CommonCryptor.h>
@implementation NSData (AESAdditions)
- (NSData*)AES256EncryptWithKey:(NSString*)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)

    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [self length];

    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);

    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);

    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }

    free(buffer); //free the buffer;
    return nil;
}

- (NSData*)AES256DecryptWithKey:(NSString*)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)

    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [self length];

    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);

    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);

    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }

    free(buffer); //free the buffer;
    return nil;
}
@end
```

http://robnapier.net/blog/aes-commoncrypto-564 블로그에서는 위 코드로 AES를 암호화하는 방법 말고 https://github.com/rnapier/RNCryptor 오픈소스(MIT 라이센스)를 이용하여 간단하게 데이터를 암호화/복호화 하는 방법도 소개하고 있다. 위 코드로 소개된 자료들이 대부분 많기 때문에 여기서 소개하려는 오픈 소스는 RNCryptor 이다. https://github.com/rnapier/RNCryptor에서 소스를 clone 하고 난 뒤 clone 된 디렉토리 안에 RNCRyptor 디렉토리를 프로젝트로 복사한다. 테스트를 위해서 테스트 클래스에 "RNCryptor.h"를 임포트하고 키로 사용될 변수를 추가한다.

```objective-c
//
//  SaltfactorySecurityLibTests.h
//  SaltfactorySecurityLibTests
//
//  Created by Song SungKwang on 4/10/12.
//  Copyright (c) 2012 saltfactory@me.com. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "RNCryptor.h"

@interface SaltfactorySecurityLibTests : SenTestCase
{
    NSString *secretKey;
}
- (void)testRNCryptorEncrypt;
- (void)testRNCryptorDecript;
@end
```

단위 테스트가 실행되기 전에 키 값을 할당하고 각각 암호화와 복호화를 진행하며 test.dat라를 파일에 암호화된 내용을 저장하거나 읽어서 처리하도록 테스트한다. RNCryptor를 이용하여 AES256 암호화를 할 때는 `-encryptData:password:error` 메소드를 사용하고 복호화 할 때는 `-decryptData:password:error` 메소드를 사용한다.

```objective-c
//
//  SaltfactorySecurityLibTests.m
//  SaltfactorySecurityLibTests
//
//  Created by Song SungKwang on 4/10/12.
//  Copyright (c) 2012 saltfactory@me.com. All rights reserved.
//

#import "SaltfactorySecurityLibTests.h"

@implementation SaltfactorySecurityLibTests

- (void)setUp
{
    [super setUp];

    // Set-up code here.
    secretKey = @"saltfactory";
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void)testRNCryptorEncrypt
{
    NSString *text = @"Hello, Saltfactory";

    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;

    NSData *encryptedData = [[RNCryptor AES256Cryptor] encryptData:data password:secretKey error:&error];

    if (!error) {

        [encryptedData writeToFile:@"./test.dat" atomically:YES];
    } else {
        NSLog(@"%@", [error localizedDescription]);
    }

}

- (void)testRNCryptorDecript
{
    NSData *data = [NSData dataWithContentsOfFile:@"./test.dat"];
    NSError *error;
    NSData *decriptedData = [[RNCryptor AES256Cryptor] decryptData:data password:secretKey error:&error];

    if (!error) {
        NSLog(@"%@", [[NSString alloc] initWithData:decriptedData encoding:NSUTF8StringEncoding]);
    } else {
        NSLog(@"%@", [error localizedDescription]);
    }
}


@end
```

Hello, Saltfactory라는 텍스트는 AES 256 암호화를 통해서 다음과 같이 파일에 저장이 된다. 그리고 이 파일을 읽어서 같은 키 값을 가지고 복호화하면 다시 Hello, Saltfactory가 콘솔창에 출력되는 것을 확인 할 수 있다.

![](http://cfile2.uf.tistory.com/image/172B024A4F83DD4905502B)

RNCryptor를 사용하여 프로젝트에 적용하기 위해서 SFSecurityHelper라는 클래스를 만들어서 `-encryptText:``와 `-decryptData:` 메소드를 정의하고 각각 `-securityHelperDidEncryptText:encrypted:` 와 `-securityHelperDidDecryptData:text:` 딜리게이트 메소드를 호출하게 하였다. 암호화나 복호화 오류 발생시 UI에서 처리하기 위해서 `-securityHelperFailWithError:` 딜리게이트 메소드도 추가하였다.

```objective-c
//
//  SFSecurityHelper.h
//  SaltfactorySecurityLib
//
//  Created by Song SungKwang on 4/10/12.
//  Copyright (c) 2012 saltfactory@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFSecurityHelperDelegate <NSObject>
- (void)secruityHelperDidEncryptText:(NSString *)planText encrypted:(NSData *)data;
- (void)secruityHelperDidDecryptData:(NSData *)data text:(NSString *)planText;
@required
- (void)secruityHelperFailWithError:(NSError *)error;

@end

@interface SFSecurityHelper : NSObject
{
    id<SFSecurityHelperDelegate>delegate;
    NSString *secretKey;
}
- (id)initWithDelegate:(id<SFSecurityHelperDelegate>)aDelegate secretKey:(NSString *)aSecretKey;
- (void)encryptText:(NSString *)planText;
- (void)decryptData:(NSData *)data;
@end
```

```objective-c
//
//  SFSecurityHelper.m
//  SaltfactorySecurityLib
//
//  Created by Song SungKwang on 4/10/12.
//  Copyright (c) 2012 saltfactory@me.com. All rights reserved.
//

#import "SFSecurityHelper.h"
#import "RNCryptor.h"

@implementation SFSecurityHelper

- (id)initWithDelegate:(id<SFSecurityHelperDelegate>)aDelegate secretKey:(NSString *)aSecretKey
{
    self = [super init];
    if (self)
    {
        delegate = aDelegate;
        secretKey = aSecretKey;
        return  self;
    } else {
        return nil;
    }
}

- (void)encryptText:(NSString *)planText
{
    NSData *data = [planText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;

    NSData *encryptedData = [[RNCryptor AES256Cryptor] encryptData:data password:secretKey error:&error];

    if (!error) {
        [delegate secruityHelperDidEncryptText:planText encrypted:encryptedData];
    } else {
        NSLog(@"%@", [error localizedDescription]);
        [delegate secruityHelperFailWithError:error];
    }
}

- (void)decryptData:(NSData *)data
{
    NSError *error;
    NSData *decriptedData = [[RNCryptor AES256Cryptor] decryptData:data password:secretKey error:&error];

    if (!error) {
        [delegate secruityHelperDidDecryptData:data text:[[NSString alloc] initWithData:decriptedData encoding:NSUTF8StringEncoding]];
    } else {
        NSLog(@"%@", [error localizedDescription]);
        [delegate secruityHelperFailWithError:error];
    }
}

@end
```

테스트를 위해서 단위테스트 클래스를 다음과 같이 변경하여 테스트 하자.

```objective-c
//
//  SaltfactorySecurityLibTests.h
//  SaltfactorySecurityLibTests
//
//  Created by Song SungKwang on 4/10/12.
//  Copyright (c) 2012 saltfactory@me.com. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SFSecurityHelper.h"

@interface SaltfactorySecurityLibTests : SenTestCase<SFSecurityHelperDelegate>
{
    SFSecurityHelper *securityHelper;
    BOOL done;
}
- (void)testEncryptText;
- (void)testDecryptData;
@end
```

```objective-c
//
//  SaltfactorySecurityLibTests.m
//  SaltfactorySecurityLibTests
//
//  Created by Song SungKwang on 4/10/12.
//  Copyright (c) 2012 saltfactory@me.com. All rights reserved.
//

#import "SaltfactorySecurityLibTests.h"

@implementation SaltfactorySecurityLibTests

- (void)setUp
{
    [super setUp];

    // Set-up code here.
    done = NO;
    securityHelper = [[SFSecurityHelper alloc] initWithDelegate:self secretKey:@"saltfactory"];
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

#pragma mark - SFSecurityHelper delegate method
- (void)secruityHelperFailWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
    done = YES;
}

- (void)secruityHelperDidEncryptText:(NSString *)planText encrypted:(NSData *)data
{
    [data writeToFile:@"./test.dat" atomically:YES];
    done = YES;
}

- (void)secruityHelperDidDecryptData:(NSData *)data text:(NSString *)planText
{
    NSLog(@"%@", planText);
    done = YES;
}

#pragma mark - SFFileManager test methods
- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];

    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    } while (!done);

    return done;
}

- (void)testEncryptText
{
    NSString *text = @"Hello, Saltfactory";
    [securityHelper encryptText:text];
}

- (void)testDecryptData
{
    NSData *data = [NSData dataWithContentsOfFile:@"./test.dat"];
    [securityHelper decryptData:data];
}


@end
```

## 결론

테스트 결과 RNCryptor에서 사용하던 결과와 동일하다는 것을 확인 할 수 있다. 이렇게 딜리게이트화 시킨 이유는 이후에 포스팅할 정적 라이브러리 (static library)를 이용하여 협업하기 위해서 이다. 이 포스트에서는 RNCryptor를 이용해서 간단하게 일반 텍스트를 보안성을 높일 수 있는 AES 256 암호화를 이용해서 파일을 저장하는 방법에 대해서 알아 보았다. 앱을 개발할 경우 여러가지 이유로 인해 디바이스에 영구적인 파일을 저장해야할 경우 일반 텍스트로 저장하는 것 보다 이렇게 암호화하여 저장한다면 좀 더 안전한 앱을 만들 수 있을 거라 예상된다.

## 참고

1. http://developer.apple.com/library/mac/#documentation/FileManagement/Conceptual/FileSystemProgrammingGUide/FileSystemOverview/FileSystemOverview.html
2. http://ko.wikipedia.org/wiki/고급_암호_표준
3. http://stackoverflow.com/questions/8287727/aes256-nsstring-encryption-in-ios-5
4. http://robnapier.net/blog/aes-commoncrypto-564
5. https://github.com/rnapier/RNCryptor

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
