---
layout: post
title: GCD와 Block을 이용한 URL 이미지 비동기 로딩
category: ios
tags: [ios, objective-c, objc, gcd, block]
comments: true
redirect_from: /97/
disqus_identifier : http://blog.saltfactory.net/97
---

## 서론

**UITableView**에서 각 cell 마다 이미지를 로드하거나 특정 시점이 아닌 비동기적으로 이미지를 로드하기 위한 방법이 필요할 때가 있다. 이미지 로드가 완료될때까지 기다렸다가 다음 프로세스를 진행하게 되면 UI가 멈추거나 인터렉티브한 프로그램을 만드는데 많은 제약이 생기기 때문이다. 이러한 이유로 이전부터 비동기 형식으로 이미지를 로드하는 방법과 예제가 블로그와 책에 소개가 많이 되어왔다. 이러한 비동기 방식으로 이미지 로드는 iPhone 로컬의 이미지를 로드하기보다 원격지에 있는 URL을 이용해서 이미지를 로드할때 그 필요성이 더 필요하다. 네트워크를 통해서 이미지를 가져온다는 것은 바이너리 이미지를 로드하는 시간보다 네트워크에서 데이터를 전송하는 시간이 더 많이 걸리기 때문이다. 만약 원격 이미지를 비동기 방식으로 로드하지 않게 되면 UI가 멈추어 버리기 때문에 사용자들은 앱이 죽었다고 생각하거나 답답해서 그 앱을 두번다시 사용하지 않을지도 모른다.

비동기 방식으로 이미지를 로드하는 예제들

* http://developer.apple.com/library/ios/#samplecode/LazyTableImages/index.html
* http://www.markj.net/iphone-asynchronous-table-image/
* http://gazapps.com/wp/2011/06/29/asynchronous-images-on-ios/
* http://avishek.net/blog/?p=39

위에서 사용하는 방법은 [NSURLConnection](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLConnection_Class/index.html)을 이용해서 delegate method를 이용하는 방법을 보통 사용한다. delegate pattern은 작업 처리를 하는 객체에게 위임을하거나 비동기적으로 객체에 메소드를 호출할때 매우 유용한 방법이다. 하지만 delegate를 사용하면 delegate 메소드가 필요하게 되고 delegate 메소드 안에서 처리할 작업을 정의해 두어야 한다.

<!--more-->

## GCD와 Block을 이용한 비동기 처리

이미지를 비동기 방식으로 로드하고 비동기 방식으로 로드하면서 외부에서 그 이미지를 처리하는 메소드까지 선언해줄수 있는 방법으로 [block](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Blocks/Articles/00_Introduction.html)과 [GCD (grand centeral dispatch)](https://developer.apple.com/library/mac/documentation/Performance/Reference/GCD_libdispatch_Ref/)를 이용하는 방법을 참조하였다. block은 Python이나 Ruby 등에서 사용하는 closure 개념과 비슷하다. Block은 C 레벨의 문법과 런타임 특징이다. 이것은 C의 기본 함수와 비슷하지만 실행가능한 코드를 추가할 수가 있고 stack 또는 heap 메모리를 바인딩하는 변수를 포함할 수 있다. 이러한 특징 대문에 Block은 실행되는 동안에 어떠한 행위를 위해서 데이터의 상태를 유지할 수 있는 특성을 가진다. Block에 관해서는 다시 한번 Block의 주제에 관해서 다시 포스팅을 할 예정이다. GCD는 애플에서 개발한 기술로써 멀티코어 프로세서에 최적화된 어플리케이션을 지원하기 위해서 만들어진 기술이다. GCD는 병렬처리와 쓰레드 풀을 기반한 기술이다. GCD에 대한 상세한 내용역시 다른 포스팅으로 준비 중이다. Block과 GCD를 이용하면 기존에 사용하던 방법(delegate로 처리하는 방법)과는 다르게 원하는 방법을 구현할 수 있을 것이라는 생각을 가지고 검색해서 다음 블로그를 찾을 수 있게 되었다.  http://www.geekygoodness.com/2011/06/17/uiimage-from-url-simplified/  이 블로그에서는 아주 간단한 설명만 남겨 두었지만 Block과 GCD를 이용해서 이미지를 로드하는 방법을 소스코드로 잘 표현해 주고 있다. Block은 iOS4 이상에서만 사용이 가능하다.

```objective-c
void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}
```

이 코드를 iOS에서 사용하면 다음과 같은 warning이 나타난다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/3fbd0a84-966a-43e8-bcb0-5d46f673d570)

이것은 UIImageFromURL가 미리 선언되어 있지 않아서 발생하는 경고인데 .h 파일 안에 미리 선언해주면 이 경고는 사라진다.

```objective-c
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) );
@end
```

사용방법은 참조한 블로그에 나온 방법대로 사용하면 되는데 다음과 같이 사용하면 된다.

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIImageFromURL( [NSURL URLWithString:@"http://cfile30.uf.tistory.com/image/186A3A384EEAE043315B79"], ^( UIImage * image )
    {
        [self.view addSubview:[[UIImageView alloc] initWithImage:image]];
    }, ^(void){
        NSLog(@"%@",@"error!");
    });

}
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/488aef88-86bb-4933-8bf3-29c3f8b255df)

우리는 이 코드를 좀더 Objective-C에 익숙한 메소드와 파라미터 방식으로 변경하고 싶다고 생각했다. Objective-C의 메소드 선언 방법은 개발할때 파라미터에 대한 이름과 타입을 참조하는데 더 유용하기 때문이다. 그래서 이 코드를 다음과 같이 변경하여 인스턴스 메소드로 만들어서 사용할 수 있다.

```objective-c
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) );

- (void) loadAsyncImageFromURL:(NSURL *)url  imageBlock:(void (^) (UIImage *image))imageBlock errorBlock:(void(^)(void))errorBlock;
@end
```

```objective-c
- (void) loadAsyncImageFromURL:(NSURL *)url  imageBlock:(void (^) (UIImage *image))imageBlock errorBlock:(void(^)(void))errorBlock
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:url];
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}
```

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self loadAsyncImageFromURL:[NSURL URLWithString:@"http://cfile27.uf.tistory.com/image/1349CD374EA43DFB2EF0B6"]
                     imageBlock:^(UIImage *image){
                         [self.view addSubview:[[UIImageView alloc] initWithImage:image]];
                     }
                     errorBlock:^(void){
                         NSLog(@"%@", @"error!");
                     }];


//    UIImageFromURL( [NSURL URLWithString:@"http://cfile30.uf.tistory.com/image/186A3A384EEAE043315B79"], ^( UIImage * image )
//    {
//        [self.view addSubview:[[UIImageView alloc] initWithImage:image]];
//    }, ^(void){
//        NSLog(@"%@",@"error!");
//    });

}
```

이 방법을 이용해서 테이블에 이미지를 비동기 방식으로 로드하는 예제를 작성하면 다음과 같이 될 것이다. 간단하게 테이블에 URL 문자열을 가지는 items 배열을 가지고 사용하였지만, 실제 사용할때는 이 데이터 역시 json이나 xml에서 받아와서 만들 것으로 예상이 된다. `tableView:cellForRowAtIndexPath:` 메소드에서 cell의 작업을 할때 우리는 비동기 방식으로 처리하는 이 코드로 작업을 처리할 수 있다.
(이 예제는 정말 단순하고 간단한 예제 이다. 더욱 좋은 코드를 만들기 위한 방법을 이 포스트에서는 소개하지 않는다.)

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    items = [[NSArray alloc] initWithObjects:@"http://cfile30.uf.tistory.com/image/186A3A384EEAE043315B79",
             @"http://cfile30.uf.tistory.com/image/186A3A384EEAE043315B79",
             @"http://cfile30.uf.tistory.com/image/186A3A384EEAE043315B79",
             @"http://cfile30.uf.tistory.com/image/186A3A384EEAE043315B79",
             @"http://cfile30.uf.tistory.com/image/186A3A384EEAE043315B79",
             @"http://cfile30.uf.tistory.com/image/186A3A384EEAE043315B79",
             @"http://cfile30.uf.tistory.com/image/186A3A384EEAE043315B79",
             nil];
}
```

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    [self loadAsyncImageFromURL:[NSURL URLWithString:[items objectAtIndex:indexPath.row]]
                     imageBlock:^(UIImage *image){

                         [[cell.contentView viewWithTag:999+indexPath.row] removeFromSuperview];

                         UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                         imageView.frame = CGRectMake(04.0f, .0f, 44.0f, 44.0f);
                         imageView.tag = 999+indexPath.row;

                         [cell.contentView addSubview:imageView];
                     }
                     errorBlock:^(void){
                         NSLog(@"%@", @"error!");
                     }];
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    return cell;
}
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/3958633b-88a9-4662-8d51-a23be3fb9c39)

참조 원문 : http://www.geekygoodness.com/2011/06/17/uiimage-from-url-simplified/
코드의 저작권은 http://www.geekygoodness.com 에 있기 때문에 코드 사용시 원 저작권자에게 사용 요청을 받기 바랍니다.

http://blog.saltfactory.net/attachment/cfile5.uf@202A18504F2A3B7E319A00.gz


