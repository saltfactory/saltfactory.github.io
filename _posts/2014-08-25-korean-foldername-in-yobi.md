---
layout: post
title : Yobi 사용시 Safari 브라우저에서 한글폴더 문제 해결하기
category : git
tags : [git, yobi, safari]
comments : true
redirect_from : /259/
disqus_identifier : http://blog.saltfactory.net/259
---

## 서론

Safari 브라우저에서 **Yobi**를 사용할 때 git에 올린 **한글 디렉토리명**일 경우 디렉토리 내부로 네비게이션이 정상적으로 이루어지지 못하는 문제가 있는데 이 문제를 해결하기 위한 방법을 알아본다.
<!--more-->

## Yobi 와 Windows 사용자

[Yobi](http://yobi.io)를 프로젝트에 도입하고 난 뒤, 이전과 달라진 점은 git 활용도가 높아졌다는 것이다. git는 예전에는 git 명령어 특성상 Windows 사용자보다는 Mac OS X나 Linux 사용자들이 적극 사용했지만, Windows에 git client들이 점점 늘어나면서 Windows 사용자도 늘어나게 되었다.

우리 연구실에서도 Mac 사용자보다는 Windows 사용자가 많기 때문에 git의 활성화가 처음에는 어려웠지만, Yobi 도입 이후 Windows 사용자도 직관적으로 잘 사용하고 있다. 현재 개발자 뿐만 아니라 디자이너도 함께 git를 잘 사용하고 있는 것을 보면 Yobi가 국내 개발자들에 쉽게 접근할 수 있는 UI를 제공하고 있다는 것을 느낄 수 있다.

## Yobi에서 한글처리

Yobi를 Windows 사용자들이 함께 사용하면서 Linux 계열의 개발자와 협업할 때는 볼 수 없었던 것을 볼 수가 있는데 바로 **한글 폴더/파일명**이다. Mac이나 Linux를 사용하는 환경이라면 디렉토리명이나 파일명을 한글로 만들 생각은 좀처럼 하기 어렵다. 터미널 인터페이스에서 한글을 입력하는 것 자체가 어색하고 불편하기 때문이다. 반면, Windows는 대부분 디렉토리명으로 분류체계를 만들고 있기 때문에 디렉토리명을 알기 쉽게하기 위해서 **한글명**으로 만들어 놓는 경우가 많다. 여기에더 ***git***를 사용하게 되면 저장소에 한글이름이 그대로 적용되어 저장되어져 버리기 때문이다.

Yobi는 **UTF-8** 기반으로 운영되어지고 있다. 즉, 소스코드, 운영체제, 웹 서버를 모두 UTF-8으로 맞추게되면 한글이 문제없이 처리되어진다.

## Yobi 사파리 브라우저 버그

Yobi 환경을 모두 UTF-8로 설정을 하여 사용하더라도 **Safari** 브라우저에서 **한글 디렉토리명**을 클릭하면 URL 인코딩 문제가 발생해 버린다.

![error](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/cb199066-56b0-4f62-9e6b-03f4837814b7)

한글이 포함된 URL을 직접 주소창에 넣으면 한글 디렉토리명이 문제 없이 보여지며 디렉토리 내의 파일들이 보여진다. Safari 브라우저를 제외한 나머지 브라우저에서는 Yobi 에 **한글 디렉토리명**을 클릭해도 정상적으로 보여지는데 Safari 브라우저에서만 **한글 디렉토리명**을 클릭했을 때 정상적으로 나타나지 않는 버그를 발견했다.

## partial\_view\_folder.scala.html

우리가 지금 발견한 버그는 safari 브라우저에서 한글 디렉토리 명을 클릭했을 때 생기는 문제이다. 저장소의 목록을 보여주는 코드는 yobi 프로젝트의 `/app/views/code/partial_view_folder.scala.html` 파일이다. `partial_view_folder.scala.html` 파일을 열어보면  **listitem**을 만드는 코드는 아래와 같다.

```html
... 생략 ...
makeFileItem(file:org.codehaus.jackson.JsonNode, fileName:String, listPath:String) = {
    @defining(routes.CodeApp.codeBrowserWithBranch(project.owner, project.name, URLEncoder.encode(branch, "UTF-8"), listPath).toString()) { filePath =>
    @defining(fieldText(file, "type")) { fileType =>
    <div id="cb-@listPath@fileName" class="row-fluid listitem" data-path="@getDataPath(listPath, fileName)">
        <div class="span6 filename">
          <a href="@getCorrectedPath(filePath, fileName)@if(fileType.eq(" folder")){#cb-@listPath@fileName}"
                class="@getFileClass(file)" title="@fileName" @if(fileType.eq("folder")){data-type="folder"}
                data-targetPath="@getDataPath(listPath, fileName)">
                <span class="dynatree-icon vmiddle"></span>@fileName
            </a>
        </div>
        <div class="span5 commitMsg">
            @Html(getAvatar(file))
            <span class="ml5"><a href="@fieldText(file, "commitUrl")">@fieldText(file, "msg")</a></span>
        </div>
        <div class="span1 commitDate">@getFileAgoOrDate(file, "createdDate")</div>
    </div>
    }
    }
}
...생략...
```

이 코드를 살펴보면 디렉토리명을 선택했을 때, 해당 디렉토리 아래의 파일 목록들을 보여주기 위해서 URL을 이동하기 위해 `<a href="@getCorrectedPath(filePath, fileName)@if(fileType.eq(" folder")){#cb-@listPath@fileName}"` 와 같이 `<a/>` 태그를 사용하고 있다는 것을 알 수 있다. 실제 위 코드가 모드 파싱되어 웹 페이지로 만들어지면 `<a href="/Project1/code/master/카테고리분류"` 이런 식으로 만들어진다.

## location.href

Safari 브라우저 버그는 `<a/>` 태그의 링크를 클릭하면 인코딩 문제가 발생하고, 주소창에 주소를 그대로 입력하면 정상적으로 보이는 것을 확인했기 때문에 우리는 `<a/>` 태크로 주소를 이동하는 것 말고 `location.href`로 주소를 변경할 수 있도록 다음과 같이 코드를 변경했다.

```html
@makeFileItem(file:org.codehaus.jackson.JsonNode, fileName:String, listPath:String) = {
    @defining(routes.CodeApp.codeBrowserWithBranch(project.owner, project.name, URLEncoder.encode(branch, "UTF-8"), listPath).toString()) { filePath =>
    @defining(fieldText(file, "type")) { fileType =>
    <div id="cb-@listPath@fileName" class="row-fluid listitem" data-path="@getDataPath(listPath, fileName)">
        <div class="span6 filename">
          <!-- <a href="@getCorrectedPath(filePath, fileName)@if(fileType.eq(" folder")){#cb-@listPath@fileName}" -->
          <a onclick="location.href='@getCorrectedPath(filePath, fileName)@if(fileType.eq(" folder")){#cb-@listPath@fileName}'"
                class="@getFileClass(file)" title="@fileName" @if(fileType.eq("folder")){data-type="folder"}
                data-targetPath="@getDataPath(listPath, fileName)">
                <span class="dynatree-icon vmiddle"></span>@fileName
            </a>
        </div>
        <div class="span5 commitMsg">
            @Html(getAvatar(file))
            <span class="ml5"><a href="@fieldText(file, "commitUrl")">@fieldText(file, "msg")</a></span>
        </div>
        <div class="span1 commitDate">@getFileAgoOrDate(file, "createdDate")</div>
    </div>
    }
    }
}

```

한글 디렉토리명을 클릭해서 URL을 이동하는 대신에 `location.href`를 사용해서 URL을 이동하게 변경한 이후에 Yobi를 다시 실행하면 다음과 같이 **Safari** 브라우저에서도 정상적으로 동작하는 것을 확인할 수 있다.

![success](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/ba529613-4adc-47e8-8229-42e1db059d96)

## \_page.less

우리는 위에서 `<a href=""/>` 태그를  `location.href` 이벤트로 변경해버렸다. HTML 문서에서는 `<a href=""/>` 태그에 마우스 포인트를 올리면 자동으로 손가락 커서 모양이 나타게 되어 있는데 우리는 태그를 변경했기 때문에 마우스 포인트를 올려도 손가락 커서 모양이 나타나지 않는다. 그래서 우리는 stylesheet를 변경하기로 했다. Yobi는 [less](http://lesscss.org/)를 사용해서 dynamic하게 stylesheet를 만들어서 사용하고 있었다. 우리가 이벤트를 만든 **listitem**의 **filename** 아래에 있는 `<a/>` 태그에 커서모양을 변경하기 위해서 우리는 `/app/assets/stylesheet/less/_page.less`를 열어서 다음 스타일 속성을 수정하였다. `.listitem .filename a` 속성을 추가했다.



```css
... 생략 ...
    [class^="depth-"],[class*=" depth-"] {
        .listhead { display:none; }
        .listitem {
            .filename a { position:relative; }
            .commitMsg { .text-overflow; }
        }
        span.dynatree-icon:before {
           content:''; position:absolute; left:-10px;
           width:10px; height:10px;
           border:1px dotted #ccc;
           border-width:0px 0px 1px 1px;
        }
    }
... 생략 ...
```

다시 Yobi를 재시작하면 서비스가 로드되면서 수정한 `.scala.html` 파일과 `.less` 파일이 컴파일되는 것을 확인 할 수 있을 것이다. 서비스가 완벽하게 올라간 이후 Safari 브라우저에서 **한글 디렉토리명**을 클릭해보면 문제없이 한글 디렉토리가 열리고 내부에 있는 파일 목록들이 보이는 것을 확인할 수 있을 것이다. 현재 Yobi 프로젝트에 [pull request](https://github.com/naver/yobi/pull/773/)를 요청한 상태이다. 오픈소스로 운영되고 있는 Yobi의 장점이 아닌가 생각한다. 정확한 문제의 원인은 알 수 없지만 우리가 경험한 내용을 수정해서 프로젝트에 적용할 수 있도록 요청했다. 다른 원인으로부터 발생한 것이라면 contributor들이 또 수정해서 프로젝트에 반영할 것이다. 우선 우리는 Yobi를 사용하여서 소스코드를 관리하는데 **한글문제**로 어려움을 가졌고 사내에서 수정해서 사용하게 되어 pull request를 요청했다. 아마 다음 버전에는 우리가 제시한 방법이 아니더라도 **Safari 브라우저에서 한글 디렉토리명 문제**에 대해서 해결이 되어서 나올 것으로 기대가 된다.

