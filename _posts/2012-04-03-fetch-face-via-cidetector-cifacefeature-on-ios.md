---
layout: post
title: CIDetector와 CIFaceFeature를 이용하여 사진에서 얼굴 이미지 추출하기
category: ios
tags: [ios, objective-c, cidetector, cifacefeature, opencv]
comments: true
redirect_from: /144/
disqus_identifier : http://blog.saltfactory.net/114
---

## 서론

Mac에는 iPhoto라는 사진편집 및 관리하는 툴이 있는데 iPhoto에 사진을 추가하게 되면 내부적으로 사진에 포함된 얼굴을 찾아서 자동으로 인덱싱해주는 기능이 있다.
<!--more-->

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/af8dd815-28a5-4a70-97f7-e0b5e99c91dc)

이런 일련된 사진에서 얼굴 이미지를 추출하는 작업을 하기 위해서는 얼굴 패턴 인식을 하는 이미지 프로세싱을 해야하는데 이러한 작업은 패턴 인식을 처리하는 전공자가 아니면 하기 매우 어려운 작업이다. 이미지에서 얼굴의 특징을 찾아내는 특징(features)를 찾아내는 작업 자체가 힘든 작업이다. OpenCV (Open Source Computer Vision)을 이용해서 얼굴 인식을 할 수 있지만 C 기반으로 만들어진 이 라이브러리를 설치하고 사용하는 것 차체도 여간 어려운일이 아니다. 이렇게 사진에서 자동으로 사람의 얼굴을 찾아내기란 매우 어려운 일이지만, 맥에서는 iPhoto 에서 오래전부터 서비스해 왔고, 이러한 기능은 사용자들에게 편리함을 높여주고 다양한 활용성을 제공하였다. iOS SDK 5.1 부터는 이젠 사진에서 얼굴 이미지를 추출하는데 어렵지 않게 구현할 수 있게 되었다. iOS 5.1 부터 CIDetector와 CIFaceFeature라는 클래스가 포함되었는데 이 두가지를 이용해서 위의 복잡하고 어려운 부분을 간단히 API를 이용하여 사용할 수 있게 해준다. CIDetector를 이용하기 위해서는 CIImage를 이용하는데 이것은 CoreImage.framework가 필요하다. 그리고 나중에 사진의 이미지 중에 얼굴 부위만 표시하는 도형을 그리기 위해서 QuartzCore.framework를 사용한다. 이 아티클에 사용된 코드를 만들기 위해서 여러가지 블로그를 참조했으며 그에 대한 각각의 자세한 내용은 아티클 마지막 참조의 링크를 확인하기 바란다. 또한 소스코드의 일부는 인용한 것이기 때문에 개발자의 동의 없이 소스코드를 무단으로 상용으로 사용할 수 없음을 밝힌다.

이제 시작해보자. 이 예제는 사진에서 얼굴 이미지를 검색해서 표시고 얼굴 이미지만 잘라내어서 디바이스에 저장하는 예제이다.

먼저 간단하게 Single View Project를 생성한다. 그리고 간단하게 사진 한장을 추가하자. 여기서 테스트하는 사진은 2007년도 하이브레인넷 연구소에서 야유회의 사진으로 테스트한다. 얼굴들이 모두 잘 나와있고 모두 9명의 사람이 있다. 그리고 한명은 얼굴이 반쯤 가려지고 눈만 보이고 코는 거의 일부만 보인다. (그 사람이 바로 저예요^^;) 이 사진을 예제 프로그램을 실힝하면 디바이스의 Caches 폴더로 얼굴 이미지만 저장할 수 있게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d1d0f253-bd33-4245-ba7b-dd85f678c51c)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/aea56ca7-b0ce-40c4-bc38-5af757eb672a)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ad54c8eb-43cc-4beb-86d9-bcccc7b4bff6)

앞에서도 말했듯 CIDetector와 CIFaceFeature를 사용하기 위해서는 CoreImage.framework가 반드시 필요하다. 그리고 QuartzCore.framework를 프로젝트에 추가한다. 사진 이미지가 크기 때문에 이미지를 스크롤해서 볼 수 있게 하기 위해서 UIScrollView를 이용하였고 그 안에 UIImageView를 추가하였다.

```objective-c
//
//  SFViewController.h
//  SaltfactoryiOSTutorial
//
//  Created by SungKwang Song on 4/3/12.
//  Copyright (c) 2012 saltfactory@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@end
```

뷰 컨트롤러가 로드되면 스크롤뷰와 이미지뷰를 추가할 것이고 그 곳에서 샘플 사진을 불러오게 할 것이다. 스크롤뷰는 화면 크기가 벗어나면 스크롤 될 수 있게 하기 위해서 스크린 사이즈에 맞게 크기를 고정하고 contentSize는 사진의 크기로 한다. 그리고 스크롤링할 수 있는 속성들을 활성화 한다.

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 테스트 사진 추가
    UIImage *image = [UIImage imageNamed:@"sample3.jpg"];

    // 스크롤뷰 추가
    photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:photoScrollView];
    photoScrollView.contentSize = image.size;
    photoScrollView.scrollEnabled = YES;
    photoScrollView.pagingEnabled = YES;
    photoScrollView.showsHorizontalScrollIndicator = YES;
    photoScrollView.showsVerticalScrollIndicator = YES;

    // 이미지뷰 추가
    photoImageView = [[UIImageView alloc] initWithImage:image];
    photoImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [photoScrollView addSubview:photoImageView];

}
```

컴파일과 빌드 후 실행 시키보면 이렇게 사진이 들어가고 사진을 드래그하면 스크롤링 되면서 전체 사진을 모두 볼 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/4532fc18-355b-4b6f-86c6-d8689161f4e8)

제 부터는 사진에서 얼굴 이미지를 찾는 작업을 할 차례이다. 이 예제 프로그램에는 총 3가지의 메소드가 사용된다. 하나는 사진 이미지에서 얼굴을 찾아내는 작업을하는 findFacesFromImage: 이고, 다른 하나는 얼굴을 찾아낸 좌표를 가지고 사진에서 그 이미지를 디바이스에 저장하는 saveFaceWithFrame:메소드이다. 마지막으로 CImage로 작업하면 다시 말해서 CoreImage로 작업하면 좌표계가 뒤집어지는데 이렇게 뒤집어진 이미지를 다시 돌려서 원래 좌표계의 이미지로 가져오게하는 메소드이다.

```objective-c
//
//  SFViewController.h
//  SaltfactoryiOSTutorial
//
//  Created by SungKwang Song on 4/3/12.
//  Copyright (c) 2012 saltfactory@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFViewController : UIViewController<UIScrollViewDelegate>
{
    NSInteger faceImageIndex;
}
@property (strong, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

- (void)findFacesFromImage:(UIImage *)image;
- (void)saveFaceWithFrame:(CGRect)rect;
- (UIImage *)rotateImage:(UIImage *)image degree:(CGFloat)degrees;
@end
```

첫번째로 살펴본메소드는 findFacesFromImage: 이다.

CIDetector 클래스는 사진에서 사진의 특징을 발견해내는 객체인데 detectorOfType에서 얼굴을 발견하는 작업을 하기 위해서 CIDetectorTypeFace를 사용한다. 그리고 CIDetector는 정확도에 대한 옵션을 추가할 수 있다. 예제에서는 CIDetectorAccuracy를 사용했다. 이 옵션은 정확도에 대한 설정인데, 정확도를 높이면 섬세하게 계산하지만 속도는 늦어진다. 속도와 성능의 반비례적 관계에서 필요한 부분을 선택하여 사용하면 된다. 예제이기 때문에 성능을 높이기 위해서 CIDetectorAccuracyHigh를 사용했다. 속도가 중요하다면 CIDetectorAccuracyLow를 선택하면 된다.

CIDetector는 CIImage를 이용하여 (CoreImage.framework)를 이용하여 작업하기 때문에 UIImage를 CIImage로 변경해줘야한다. CIDetector는 CIImage에서 얼굴을 특징을 추출해서 CIFaceFeature가 담긴 배열을 반환하다. 여기서 UIGraphicsGetCurrentContext를 이용해서 얼굴 이미지 위에다가 사각형을 표시하게 하였다. CoreImage로 작업하기 때문에 사각형의 위치를 뒤집기 위해서 CGContextTranslateCTM과 CGContextSacleCTM을 이용하였다. 이 두가지 값을 제외하고 실행하면 180도 뒤집힌 곳에 사각형이 그려진다.

```objective-c
- (void)findFacesFromImage:(UIImage *)image
{

    NSDictionary *options = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];

    CIImage *cImage = [[CIImage alloc] initWithImage:image];
    NSArray *features = [detector featuresInImage:cImage];

    UIGraphicsBeginImageContextWithOptions(image.size, YES, 0);
    [image drawInRect:photoImageView.bounds];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0, photoImageView.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);

    for (CIFaceFeature *feature in features) {

        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddRect(context, feature.bounds);
        CGContextDrawPath(context, kCGPathFillStroke);

//        [self saveFaceWithFrame:feature.bounds];
    }

    photoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}
```

여기까지 작업하고 viewDidLoad 메소드에 findFacesFromImage: 메소드를 호출하게 수정하고 실행해보자.

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 테스트 사진 추가
    UIImage *image = [UIImage imageNamed:@"sample3.jpg"];

    // 스크롤뷰 추가
    photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:photoScrollView];
    photoScrollView.contentSize = image.size;
    photoScrollView.scrollEnabled = YES;
    photoScrollView.pagingEnabled = YES;
    photoScrollView.showsHorizontalScrollIndicator = YES;
    photoScrollView.showsVerticalScrollIndicator = YES;

    // 이미지뷰 추가
    photoImageView = [[UIImageView alloc] initWithImage:image];
    photoImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [photoScrollView addSubview:photoImageView];

    [self findFacesFromImage:photoImageView.image];  
}
```

지금까지의 코드를 실행시키면 다음과 같이 사진에서 얼굴을 찾아서 사각형으로 표시를 하게 해주는 것을 확인할 수 있다. 사진을 드래그해보면 9명 전원의 얼굴을 찾아서 사각형이 그려진 것을 확인할 수 있다. 나중에 OpenCV로 동일한 작업을 포스팅할 예정이지만 OpenCV로 작업하는 것 보다 너무나 쉽게 사람 얼굴을 찾아 낼 수 있다. (정확도에 대해서는 지금 말하지 않겠다)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7ee43b08-f6f5-45d0-9933-0af2ce858595)

이제 얼굴 이미지를 찾았으니 이 이미지를 디바이스에 저장해 보기로 한다. 이미지를 저장하는 부분은 saveFaceWithFrame: 이라는 메소드가 처리하는데 실제 사진 이미지에서 얼굴 이미지가 가지고 있는 좌표를 가지고 이미지를 Cropping(잘라내기)하여 저장하도록 한다. 이미지 그래픽 처리를 위해서 CGContext를 사용한다. 그리고 Crop 되어질 영역을 지정해서 새로운 CGContextDrawImage로 이미지를 그리고 그 그래픽처리한 컨텍스트에서 cropImage를 추출한다. 여기서 crop 이미지를 만들때 -1 값을 곱한 이유는 좌표를 대칭하기 위한 작업이다. 그런다음에는 Caches 디렉토리에다 사진을 저장하는데 저장할때는 얼굴 배열의 index 번호로 파일 이름을 만든다.

```objective-c
- (void)saveFaceWithFrame:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect cripToRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect(context, cripToRect);

    CGRect drawRect = CGRectMake(rect.origin.x *-1, rect.origin.y*-1, photoImageView.image.size.width, photoImageView.image.size.height);
    CGContextDrawImage(context, drawRect, photoImageView.image.CGImage);

    UIImage *cropImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIImage *image = [self rotateImage:cropImage degree:180];
//    UIImageWriteToSavedPhotosAlbum([self rotateImage:cropImage degree:180], nil, nil, nil);

    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [[pathList objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", faceImageIndex]];
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(cropImage, 1.0)];
	[data writeToFile:cachePath atomically:YES];

    faceImageIndex++;
    UIGraphicsEndImageContext();
}
```

위에서 작업한 findFacesFromImage: 안에서 CIFaceFeature의 배열이 루프를 도는 작업 안에 saveFaceWithFrame: 메소드를 추가하자. 그리고 컴파일과 빌드후 실행 후 Caches 디렉토리에서 생성된 이미지 파일들을 살펴보자.

```objective-c
- (void)findFacesFromImage:(UIImage *)image
{

    NSDictionary *options = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];

    CIImage *cImage = [[CIImage alloc] initWithImage:image];
    NSArray *features = [detector featuresInImage:cImage];

    UIGraphicsBeginImageContextWithOptions(image.size, YES, 0);
    [image drawInRect:photoImageView.bounds];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0, photoImageView.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);

    for (CIFaceFeature *feature in features) {

        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddRect(context, feature.bounds);
        CGContextDrawPath(context, kCGPathFillStroke);

        [self saveFaceWithFrame:feature.bounds];
    }

    photoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}
```

얼굴 이미지는 제대로 추출하였지만 얼굴이 뒤집혀서 저장된 것을 확인할 수 있다. 이제 이 문제를 해결하기 위해서 파일을 저장하기 전에 이미지를 돌리는 작업을 해보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a8411fe4-849e-4432-9eb9-ff4227362a10)

우선 이미지를 회전 시키기 위해서 UIImage 객체를 radian 값을 이용하여 CGAffineTransformMakeRotation을 시켜야하기 때문에 degreesToRadians 매크로를 만든다. 그리고 회전시킨 값을 가지고 위에서 작업한 것과 동일하게 GCContext를 상용하여 다시 이미지를 그려서 회전시킨다음에 회전된 이미지를 반환한다.

```objective-c
#define degreesToRadians(degrees) ((degrees)/180.0 * M_PI)


- (UIImage *)rotateImage:(UIImage *)image degree:(CGFloat)degrees
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;

    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);

    CGContextRotateCTM(bitmap, degreesToRadians(degrees));

    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}
```

이제 UIImage를 회전시키는 작업까지 완료했으니 저장하기 전에 이 메소드를 호출하도록 saveFaceWithFrame: 메소드 안에서 호출한다.

```objective-c
- (void)saveFaceWithFrame:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect cripToRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect(context, cripToRect);

    CGRect drawRect = CGRectMake(rect.origin.x *-1, rect.origin.y*-1, photoImageView.image.size.width, photoImageView.image.size.height);
    CGContextDrawImage(context, drawRect, photoImageView.image.CGImage);

    UIImage *cropImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *rotateImage = [self rotateImage:cropImage degree:180];

    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [[pathList objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", faceImageIndex]];
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(rotateImage, 1.0)];
	[data writeToFile:cachePath atomically:YES];

    faceImageIndex++;
    UIGraphicsEndImageContext();
}
```

이제 다시 컴파일 후 시행해보자. 뒤집혔던 이미지들이 정상적으로 저장되는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f90c0037-6d4f-4fb5-8f70-973f508b5ced)

## 결론

iOS 5.1 부터는 사진에서 얼굴 인식을 하여 이미지를 추출하기 위해 복잡한 알고리즘을 구현하는 것을 CIDetector와 CIFaceFeature를 통해서 구현할 수 있게 되었다. 이런 API가 추가됨으로 우리는 좀더 다양하고 재미있는 애플리케이션을 만들 수 있게 될지도 모른다. 하지만 테스트 결과 고려해야할 부분들이 있어서 말해본다. CIDetector는 CoreImage.framework를 사용하는데 이에 사용하는 이미지 자표계가 반대되어서 이미지를 회전시키는 작업을 필요하다. iOS 5.1 버전 이하의 사용자들도 많이 있다. 그렇기 때문에 모든 버전의 사용자에게 서비스하기 위해서는 현재 시점에서 CIDetector와 CIFaceFeature를 도입한다는 것은 고객 대상을 협소하게 만들 수 있는 문제가 발생한다. 그리고 가장 아쉬운 부분은 CIDetector에서 추출한 CIFaceFeature의 클래스에 사람의 눈,코, 입의 자표계 말고는 고유 값( 얼굴 인식과 매칭을 하기위한 eigen face 값, 특징 벡터 값)을 가져 올 수 없었다. 이 값이 없으면 어떻게 특징을 비교할 수 있을지 생각되는 부분이다. 아마도 이 값은 일부러 API에서 공개하지 않은 것 같다는 생각이 들었다.  하지만, CIDetector와 CIFaceFeature의 추가로 다양한 분야에서 복잡하지 않는 얼굴인식을 쉽고 편리하게 구현하여 서비스 할 수 있을것 같다.

## 참고

1. http://www.bobmccune.com/2012/03/22/ios-5-face-detection-with-core-image/

2. http://iphonedevelopment.blogspot.com/2008/10/demystifying-cgaffinetransform.html

3. http://stackoverflow.com/questions/5017540/how-to-i-rotate-uiimageview-by-90-degrees-inside-a-uiscrollview-with-correct-ima

4. http://stackoverflow.com/questions/7253270/how-to-crop-the-uiimage-in-iphone

