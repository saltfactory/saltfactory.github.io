---
layout: post
title: mark2html을 이용하여 Markdown 파일을 HTML 파일로 변환
category: mark2html
tags: [markdown, mark2html]
comments: true
redirect_from: /252/
disqus_identifier : http://blog.saltfactory.net/252
---

## 서론

[mark2html](http://saltfactory.net/mark2html/)는 Markdown 파일을 html 파일로 변환시켜주는 모듈이자 작은 프로그램이다. makr2html을 사용하여 HTML으로 변화할 때 Markdown에 포함된 이미지 파일을 HTML 파일의 경로에 함께 복하하거나 이미지를 datauri로 변환시켜 포함시켜주는 기능을 가지고 있다. mark2html은  Node.js 프로그램에 상용할 수 있는 모듈과 명령어로 사용할 수 있게 CLI 설치가 가능하다. HTML 입력을 요구하는 블로그에 Markdown 파일을 포스팅할 때 mark2html을 유용하게 사용할 수 있다.

<!--more-->

## mark2html 개발 배경

***makr2html***를 개발하게 된 이유는 개인적으로 진행하고 있는 ***Markdown으로 Tistory 블로그 포스팅하기*** 를 위해서 만들어졌다. github를 사용할 일이 많아지면서 Markdown 문서를 작성할 일이 많아졌는데 그러면서 Markdown이 문서를 작성하는데 정말 편리한 포멧이라는 것을 알게 되었다.
그래서 Markdown을 사용하여 Tistory에 글을 작성하려고 하는데 몇가지 문제점 때문에 단순하게 사용할수는 없다는 결론을 내렸다.

Tistory에서 Markdown을 작성하면 다음과 같은 문제를 겪게 된다.

1. **Markdown 에디터가 없다** : [Tumblr](http://tumblr.com)에서는 웹에서 글을 작성할 때 Markdown 에디터를 통해서 글을 작성할 수 있다.
그렇기 때문에 사용자는 웹에서 HTML를 변경하지 않고 Markdown 마커를 가지고 바로 글을 작성할 수 있다.
하지만 Tistory는 WYSIWYG 에디터를 사용하기 때문에 HTML 입력을 사용한다.
이러한 이유 때문에 Markdown을 WYSIWYG이 아닌 HTML 모드로 입력을 하게되면 일반 plan text로 저장이 되어 버린다.

2. **Client-side JavaScript Markdown rendering Library 필요** : Tistory는 Daum editor를 사용하고 있는데 Markdown 문서를 WYSIWYG이 아닌 html 모드로 입력하게 되면 화면에 나타날때 Markdown 문서가 HTML으로 변환되지 않은 plan text가 바로 나타나버리게 된다. 그래서 서버가 아닌 브라우저에서 나타날때 HTML 코드로 변화시키는 client-side javascript markdown rendering library가 필요하다. 예를 들어 [marked](https://github.com/chjj/marked) 와 같은 라이브러리를 사용해야한다. 이것은 네트워크로 JavaScript 라이브러리 덩어리를 다운받게 해야한다.

3. **preloaded meta open graph property** : Tistory는 [open graph](http://ogp.me/) 지원을 위해서 웹 페이지가 열릴 때 해당 글의 내용을 미리 `<meta name="og:">`로 만들고 웹 페이지를 렌더링하는데 이러한 이유 때문에 html 모드에서 Markdown 형식으로 글을 작성하고 Client-side에서 HTML 문서로 렌더링을 하게되면 open graph에 사용하는 meta 정보들이 Markdown의 마커들이 붙어 있는채 만들어져 버리는 문제가 발생한다.

4. **HTML 모드로 작성하면 파일 업로드를 할 수 없다** : Tistory에서 Markdown으로 글을 작성해서 올리려면 html 모드로 글을 작성해야하는데 이 모드에서는 파일 업로드를 할 수 없는 문제가 있다. Tistory에서는 Daum editor를 사용해야지만 사진을 올릴 수 있기 때문에 Markdown에 필요한 이미지들은 모두 외부링크로 해야하는 문제가 있다.

이러한 이유 때문에 Markdown을 사용해서 Tistory에 글을 올리려고 한다면 로컬에서 Markdown을 HTML으로 변화시키고 변화시킨 HTML 코드를 포스팅해야 한다는 결론을 내렸다. 하지만 기존의  Makrkdown 렌더링 모듈은 일반적인 기능만 가지고 있었다. Tistory에 Markdown으로 글을 작성할때는 html 모드로 작성해야하고 HTML 모드로 작성하면 이미지를 업로드할 수 없기 때문에 문서 안의 이미지들을 파일이 아닌 datauri로 변경해서 렌더링하는 기능이 필요했는데 이런 기능을 가지고 있는 모듈은 없어서 ***mark2html*** 모듈을 직접 만들기로 했다.


## mark2html 특징

mark2html은 다음과 같은 특징이 있다.

1. Markdown 파일을 HTML 파일로 변환한다.
2. 파일 변환할 때 파일 안에 포함되어 있는 이미지 파일을 HTML 파일이 만들어지는 곳으로 복사한다.
3. 파일을 변환할 때 파일 안에 포함되어 있는 이미지 파일을 HTML 파일을 만들 때 datauri로 변환해서 만든다.
4. Markdown 파일 안에 포함되어 있는 이미지 파일을 datauri로 변환해서 적용된 Markdown 파일을 HTML 파일이 만들어지는 곳에 함께 복사본을 만든다.
5. Node.js 모듈과 CLI(Command Line Interface)를 지원한다.

## mark2html 내부 모듈

가장 처음 한 일은 Markdown 렌더링할 때 필요한 모듈을 찾는 것이였다. Markdown parser 모듈을 찾을 때 [Github Flavored Markdown](https://help.github.com/articles/github-flavored-markdown)을 지원하는 모듈을 찾았다. GFM(Github Flavoed Markdown)은 기존의 Markdown의 부족한 포멧을 github에서 지원하는 문법인데 사용하는 대부분의 Markdown 문서들이 GFM를 사용하고 있기 때문이였다.

1. [marked](https://github.com/chjj/marked):  Markdown parser와 compiler 모듈이다. 이 모듈은 다른 markdown과 달리 lexer 인터페이스를 제공한다. 실제 mark2html에서 이 모듈을 사용해 custom 하게 HTML 코드를 만드는 모듈을 따로 만들었다.
2. [pygmentize-bundle](https://github.com/rvagg/node-pygmentize-bundled): GMF의 syntax highlight를 렌더링하기 위한 모듈이다. github에서는 [pygments](http://pygments.org)를 사용해서 Markdown 안에 있는 code block을 코드를 syntax highlighing을 적용하는데 Node.js 모듈 중에서 pygments를 사용할 수 있게 wrapping한 것이 이 모듈이다.
3. [highight.js](http://highlightjs.org): Node.js의 강점이 JavaScript 라이브러리를 사용할 수 있는 것이데, 좀 더 화려한 syntax highlighting style을 사용하기 위해서 pygments 뿐만아니라 highight.js를 사용할 수 있게 이 모듈을 사용했다.

## mark2html 사용방법

mark2html은 크게 Node.js 모듈로 사용하는 방법과 CLI로 사용하는 방법이 있다.

### Node.js 모듈로 사용하기

mark2html을 사용하려는 프로젝트 안에서 `npm`으로 설치한다.

```
npm install mark2html
```

설치가 완료되면 `require`를 사용해서 모듈을  로드하고 mark2html에 필요한 옵션을 지정해서 `mark2html.convert(options)`를 한다.

```javascript
var mark2html = require('mark2html');
var options = {
	src: "/Users/saltfactory/Dropbox/Blog/posts/2014-07-28-test-mark2html.md", //Markdown 파일경로
	destDir: "/Users/saltfactory/Dropbox/Blog/output", //HTML 파일이 복사되는 디렉토리 경로
	imageCopy: true, //Makrkdown 파일에 포함된 이미지를 destDir에 복사
	datauri: true,	//HTML을 생성할 때 Markdown 파일 안의 이미지를 datauri로 변환해서 생성
	markdownCopy: true, //Markdown 파일도 destDir에 함께 복사
	markdownDatauri: true,	//Markdown 파일을 복사할 때 파일안의 이미지를 datauri로 변환해서 복사
	highlight: 1	//pygments로 syntax highlighting, 1:pygments, 2:hightlight.js
};

mark2html.convert(options)
```

### CLI 사용하기

mark2html을 CLI로 사용하기 위해서는 `npm install -g`로 설치를 하고 터미널에서 `mark2html` 명령어를 사용하면 된다. `mark2html` 명령어를 사용할 때도 옵션을 지정할 수 있다. 자세한 옵션은 [명령어 옵션](https://github.com/saltfactory/mark2html#mark2html-명령어-옵션)을 참조하면 된다.

```
npm install -g mark2html
```

```
mark2html -s /Users/saltfactory/Dropbox/Blog/posts/2014-07-28-test-mark2html.md \
-d /Users/saltfactory/Dropbox/Blog/output \
-img -md -datauri -mdatauri -code 1
```
### 글로벌 옵션 설정

mark2html은 옵션을 사용해서 Markdown 파일을 HTML으로 변환 시킨다. 하지만 매번 같은 옵션을 사용하려고 옵션 값을 변수에 지정하거나 명령어 옵션을 사용하면 불편함을 느낄 것이다. 그래서 컴퓨터에서 사용할 수 있는 글로벌 옵션 설정 파일을 만들어서 기본적인 옵션을 추가해 두면 된다.

글로벌 옵션 설정 파일은 `$HOME/.mark2html.json` 에 다음과 같이 저장할 수 있다.

```json
{
  "destDir": "/Users/saltfactory/Dropbox/Blog/output",
  "subDir": true,
  "imageCopy": true,
  "datauri": true,
  "markdownCopy": true,
  "markdownDatauri": true,
  "highlight": 1
}
```
글로벌 옵션 설정 파일을 만들어둔 상태에서 옵션을 추가적으로 사용할 수 있다. 만약 글로벌 옵션 설정 파일이 있는데 추가적으로 옵션을 사용하게 되면 없는 옵션은 추가가 될 것이고, 파일에 존재하는 옵션이 있다면 추가적으로 사용한 옵션값이 적용이 될 것이다.

## 결론

mark2html은 Markdown 파일을 HTML 파일로 만들어주는 모듈이다. `npm` 글로벌 설치를 하면 `mark2html` 명령어를 사용할 수 있다. mark2html은 단순히 Markdown 파일을 HTML으로 변환 시키는 것 뿐만 아니라 Markdown 파일안에 포함되어 있는 이미지를 처리할 수 있는 기능이 가지고 있다. 파일 안에 존재하는 이미지를 destDir에 복사하거나 이미지 파일을 사용하지 못하는 사이트에 datauri로 변환 시키는 기능도 포함하고 있다.
지금 이 글도 mark2html을 사용해서 Markdown으로 작성된 문서를 HTML으로 변환시켜 포스팅 될 것이다. Tistory에 글을 작성할 때 Markdown을 사용하기 위해서는 HTML 모드로 편집기를 사용해야하는데, 이때 이미지를 첨부할 수 없는 문제가 있다. 이때 mark2html을 사용해서 HTML으로 변환할 때 이미지를 datauri로 만들어서 HTML 파일 안에 포함시키면 된다. mark2html은 아직 개발단계이지만 Markdown을 사용해서 Tistory나  HTML 입력 모드를 지원하는 블로그에 글을 포스팅하고 싶을때 사용하면 유용할 것으로 생각된다.


