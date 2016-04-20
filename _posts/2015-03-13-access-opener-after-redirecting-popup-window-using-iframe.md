---
layout: post
title: popup 창에서 리다이렉트 이후 window.opener 사라지는 문제 해결하기
category: javascript
tags: [javascript, opener, window]
comments: true
redirect_from : /268/
disqus_identifier : http://blog.saltfactory.net/268
---

## 서론

웹 프로그램을 개발할 때 현재 열려 있는 페이지를 그대로 유지하면서 사용자에게 다른 액션을 유도하기 위해서 우리는 **Popup**으로 새로운 창을 열도록 개발하는 경우가 있다. 예를 들어서 **i-PIN** 인증을 처리하는 경우 회원가입 화면에서 i-PIN 인증 화면을 Popup으로 열어서 사용자 인증을 거친 이후 인증이 완료되면 열었던 창으로 결과를 던져주는 경우가 있다. JavaScript로 Popup을 사용하여 새로운 창을 열고 Popup에서 처리한 결과를 Popup을 열게한 **window.opener**에 접근해서 이벤트를 전달하는 것은 어렵지않게 이미 알려진 방법으로 해결할 수 있다. 하지만 특정 브라우저에서 Popup한 창에 열려진 사이트가 **Redirect**를 하여 다른 host로 이동을 할 경우 window.opener 객체를 잃게 되버리는 문제를 발견했다. 이번 포스팅은 JavaScript로 Popup을 사용하는 방법 중에 Popup의 호스트가 이동후 opener에 접근할 수 있는 방법에 대해서 소개한다.

<!--more-->

> 설명의 편의를 위해 Popup을 생성하여 열게한 창을 **부모창**, Popup으로  새롭게 열려진 창을 **자식창**이라고 정의하고 설명한다.


## JavaScript로 Popup 열기

JavaScript로 Popup 창을 여는 방법은 여러가지가 있지만 가장 간단하게 다음과 같이 할 수 있다.
**부모창** 에서 `window.open()` 메소드를 사용하여 **자식창**을 새롭게 만들 수 있다. 이 때 **자식창**의 고유 이름을 지정하거나 `_self`, `_blank`와 같이 예약된 이름으로 만들 수 있고 **자식창**의 속성을 부여할 수 있다.

```html
<!DOCTYPE html>
<html>
<head lang="en">
  <meta charset="UTF-8">
  <title></title>
  <script src="parentWin.js"></script>
</head>
<body>
  <button onclick="onPopupWindow()">팝업창 열기</button>
</body>
</html>
```

```javascript
// filename : parentWin.js

function onPopupWindow(){
	window.open("popup.html", "_blank", "top=10, left=10, width=400, height=400");
}
```

## 자식창에서 부모창 접근

Popup으로 열린 **자식창**에서 특정 작업이 처리된 이후 **부모창**에 데이터를 넘겨주거나 이벤트를 처리해야할 때 다음과 같이 [window.opener](http://www.w3schools.com/jsref/prop_win_opener.asp) 객체를 이용하여 접근할 수 있다. 예를 들어 **자식창**에서 **부모창**에 열려있는 페이지를 다른 페이로 이동시키고 싶을 경우 **자식창**에서 다음과 같이 할 수 있다.

```html
<!DOCTYPE html>
<html>
<head lang="en">
  <meta charset="UTF-8">
  <title></title>
  <script src="childWin.js"></script>
</head>
<body>
  <button onclick="doRedirectOpener()">부모창 페이지 이동</button>
</body>
</html>
```

```javascript
// filename : childWin.js

function doRedirectOpener(){
	var parentWindow = window.opener;
	parentWindow.location.href = 'http://blog.saltfactory.net'
};
```


**자식창**에서 **부모창**에 접근하기 위해서는 `window.opener`를 참조하면 **부모창**의 윈도우객체를 참조할 수 있다. 위 예제는 `window.opener`를 이용해 **부모창**의 `window`객체를 접근해 `window.location.href` 값을 수정하여 새로운 HOST로 부모창의 페이지를 이동하게 한 예제이다.

## 자식창의 HOST가 리다이렉트 되는 경우

만약 Popup으로 **자식창**을 Popup으로 열었는데 특정 일을 처리하고 난 이후 **자식창**의 HOST가 변경될 경우를 생각해보자. 예를 들어 **i-PIN** 인증창을 Poup으로 연다고 가정하자.

**자식창**의 플로우는 다음과 같다.
설명의 편의를 위해서 우리 호스트는 http://blog.saltfactory.net 이라고 하고 i-PIN 인증 업체 호스트는 http://i-pin.org 이라고 한다.

1. **부모창**에서 **자식창**을 popup으로 연다. 이때 URL은 나의 HOST의 `child.html`이다
2. checkIPIN.html : 필요한 데이터를 조합해서 **i-PIN** 인증 업체의 URL `iPin.html`으로 리다이렉트를 한다.
3. **iPinMain.html** : 외부 업체 사이트에서 필요한 작업을 처리하고 결과를 나의 HOST의 `result.html`으로 리다이렉트 한다.
4. result.html : 외부에서 전달한 값을 가지고 **부모창**에 접근하여 결과를 액션을 취한다.

![](http://blog.hibrainapps.net/saltfactory/images/e2148fee-1163-405c-b7fe-fd0398a48f58)

이와 같은 경우 최종적으로 **자식창**에서 결과를 **부모창**에 전달하기 위해서 `window.opener`를 사용하면 `undefined` 에러를 발생시킨다.
다시 말해서 HOST가 변경되면서 처음 **자식창**이 열렸을 때의 `window.opener`가 유지가 되지 않고 변경이 되는 문제를 가지게 되는 것이다. 이 문제는 Internet Explore의 보안설정에 의해서 발생한다. 이 문제를 해결하기  위해서 사용자에게 보안 설정을 해지하거나 변경해야한다고 공지할 수는 없기 때문에 우리는 이 문제를 해결하기 위한 방법을 찾게 되었다.


## Popup창을 iframe으로 열기

**자식창**이 Popup으로 열려서 URL이 다른 HOST로 이동하게 되면 `window.opener`를 유지할 수 없는 문제를 해결하기 위해서 [iframe](http://www.w3schools.com/tags/tag_iframe.asp)을 이용하여 **자식창**의 HOST는 변경하지 않고 `iframe`안에서만 페이지가 변경될 수 있도록 실험하였다. **자식창**의 `window`객체는 변경되지 않기 때문에 **자식창**에서는 **부모창**을 접근할 수 있는 `window.opener`를 잃지 않을 것으로 생각했다. 결과 페이지인 `result.html` 페이지 안에서 `iframe`에 접근하면 `iframe`을 가지고 있는 **자식창**을 접근할 수 있고, **자식창**에서 **부모창**으로 접근할 수 있기 때문이다.

![](http://blog.hibrainapps.net/saltfactory/images/e77f6503-209d-4793-8ba7-71ad8a505cd9)



**부모창**에서 **자식창**을 열때 `iframe`을 만들고 `iframe`안에서 **자식창** URL인 `http://blog.saltfactory.net/child.html`을 열도록 하였다.

```javascript
// filename : parentWin.js

function onPopupWindow(){
	var win =  window.open(null, '_blank', "top=10, left=10, width=400, height=400");
	win.document.write('<iframe width="100%", height="100%" src="http://blog.saltfactory.net/child.html" frameborder="0" allowfullscreen></iframe>')
}

```

`child.html`에서는 내부적으로 `http:///i-pin.org/iPin.html`로 페이지를 전환후에 작업을 모두 처리한 이후 결과를 `http://blog.saltfactory.net/result.html`으로 다시 리다이렉트를 시켜주었다. 결과 받은 `result.html`은 다음과 같은 소스코드를 가지고 있다.

```html
<!DOCTYPE html>
<html>
<head lang="en">
  <meta charset="UTF-8">
  <title></title>
  <script src="child-resultWin.js"></script>
</head>
<body>
  <button onclick="onCloseSendResultToOpener()">이 창을 닫고 회원가입을 계속 진행합니다.</button>
</body>
</html>
```

```javascript
// filename : child-resultWin.js

function onCloseSendResultToOpener(){
	var childWindow = window.parent;
	var parentWindow = childWindow.opener;
	parentWindow.location.href = 'http://blog.saltfactory.net/account.html'
};
```

다시 말해서 **i-PIN** 인증창이 **자식창** 안의 `iframe`안에 열려있고, 처리가 완료된 이후 `result.html`도 **자식창**의 `iframe` 안에 열려 있는 것이다. **자식창**에서 리다이렉트하는 모든 사이트들은 **부모창**에서 **자식창**을 열때 만들어 놓은 `iframe`안에서 동작하고 있기 때문에 마지막 결과를 받은 `result.html`에서 `iframe`으로 접근하고, `iframe`에서는  **자식창**에 접근하고 마지막으로 **자식창**에서 **부모창**으로 접근할 수 있는 것이다.

## 결론

**부모창**에서 JavaScript를 이용하여 **자식창**을 Popup으로 열게되면 **자식창**에서 `window.opener`를 참조하여  **부모창** 에 접근할 수 있다. 하지만 **자식창**에 다른 HOST로 리다이렉트가 되는 경우 `window.opener`객체가 사라지는 문제를 발견했다. 이 문제를 해결하기 위해서 **자식창**을 Popup으로 열때 `iframe`을 생성하여 `iframe` 내부에서 페이지가 열리고 다른 HOST로 리다이렉트 되게 하였다. 마지막 결과를 처리하는 최종 **자식창**의 페이지에서 **부모창**에 접근하기 위해서 `iframe`을 매개체로 상위 객체로 접근하게 되면 **자식창**의 페이지가 다른 HOST로 리다이렉트 될 때 `window.opener` 객체가 `undefined`되는 문제를 해결 할 수 있었다.

## 참고

* http://stackoverflow.com/questions/7120534/window-opener-is-null-after-redirect
* http://stackoverflow.com/questions/5656349/close-child-window-redirect-parent-window
* http://abcoder.com/javascript/maintain-reference-to-popup-window-over-page-refresh-or-redirect-in-javascript-solved



