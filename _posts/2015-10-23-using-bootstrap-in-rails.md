---
layout: post
title : Ruby on Rails 에서 bower를 사용하여 Bootstrap, Bootstrap-Sass 적용하기
category : ruby
tags : [ruby, gem, ror, bower, rails, bootstrap]
comments : true
images :
  title : http://assets.hibrainapps.net/images/rest/data/717?size=full
---

## 서론

웹 개발을 할 때 Style 코드에 관련된 체계적이고 구조화된 개발 방법이 필요하다. [SASS](http://sass-lang.com/) 는 이런 방법으로 stylesheet를 개발할 수 있도록 도와준다. 특히 Ruby on Rails에 기본적으로 SASS를 지원하기 때문에 이것을 사용하면 보다 효율적이고 효과적인 CSS를 개발할 수 있다. 우리는 SASS를 이용하여 스타일을 개발하고 있는데 [bootstrap](http://getbootstrap.com/)을 사용하여 UI 컴포넌트를 제작하려고 했다. 하지만 Bootstrap은 체계적인 스타일 개발을 위해  [Less](http://lesscss.org/)를 사용하여 개발되어 졌다. Bootstrap은 SASS로 개발하는 환경을 위해서 [bootstrap-sass](https://github.com/twbs/bootstrap-sass)를 제공하고 있다. 이 포스팅에서는 Ruby on Rails에서 Bootstrap을 SASS로 개발할는 환경 설정에 대한 소개를 한다.

<!--more-->


## 테스트를 위한 RoR 프로젝트 생성

테스트를 위해 우리는 **TestApp**이라는 이름으로 RoR 프로젝트를 생성한다.

```
rails new TestApp
```

프로젝트 설치 후 테스트를 위한 컨트롤과 뷰를 추가한다.

```
rails g controller Greetings hello
```


## Node.js와 Bower 설치

RoR에서 Bootstrap을 Bower를 사용하여 설치하기 위해서는 [Ruby on Rails 에서 bower 사용하기](http://blog.saltfactory.net/ruby/using-bower-in-ror.html) 글을 참조하여 Bootstrap을 설치하여 사용할 수 있다. bower를 사용하여 Bootstrap을 설치할 경웅 가장 먼저해야하는 과정이 Node.js와 Bower를 설치하는 것이다.

```
brew install node
```
```
npm install -g bower
```

다음으로 bower.json에 필요한 패키지를 정의하여 파일을 생성하고 bower 패키지가 설치될 디렉토리를 설정한다. [Ruby on Rails 에서 bower 사용하기](http://blog.saltfactory.net/ruby/using-bower-in-ror.html) 글에 자세히 설명이 되어 있다. 우리는 bower를 사용하여 bootstrap을 설치하여 사용할 것이기 때문에 패키지에 **bootstrap**을 추가하여 설치한다.

```javascript
{
  "name": "TestApp",
  "authors": [
    "saltfactory <saltfactory@gmail.com>"
  ],
  "description": "",
  "main": "",
  "moduleType": [],
  "keywords": [
    "bower",
    "rails"
  ],
  "license": "MIT",
  "homepage": "",
  "ignore": [
    "**/.*",
    "node_modules",
    "bower_components",
    "app/components/",
    "test",
    "tests"
  ],
	"dependencies":{
		"bootstrap":"latest"
	}
}
```
bower.json에 설치할 패키지를 추가했으면 bower를 사용하여 패키지를 설치한다. 앞에 글에서 우리는 bower 패키지를 **vender/assets/bower_components**에 설치되도록 **.bowerrc** 파일에 정의했기 때문에 설치후 bootstrap은 **vendor/assets/bower_components/bootstrap** 경로에 설치가 될 것이다.

```
bower install
```

## assets.rb 설정

RoR에서 Assets Pipeline에 새로운 Assets를 추가하기 위해서는 **config/initializers/assets.rb**에 경로를 추가해야한다는 것을 살펴보았다. 이 파일을 열어서 다음과 같이 assets 경로에 bower 패키지가 설치되는 경로를 추가한다.

```ruby
# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.paths << Rails.root.join('vendor','assets','bower_components')
```

## application.js와 application.css 설정

RoR 프로젝트에서 Bootstrap의 css를 포함하기 위해서는 **app/assets/stylesheets/application.css** 파일을 열어서 bootstrap 스타일을 포함하도록 정의해야한다. 이 파일을 열어서 다음과 같이 bootstrap 스타일을 추가한다.

```css
/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, vendor/assets/stylesheets,
 * or any plugin's vendor/assets/stylesheets directory can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any styles
 * defined in the other CSS/SCSS files in this directory. It is generally better to create a new
 * file per style scope.
 *
 *= require_tree .
 *= require_self
 *= require bootstrap/dist/css/bootstrap.min
 */
```

그리고 RoR 프로젝트에서 Bootstrap의 JavaScript를 포함하기 위해서 **app/assets/javascripts/application.js** 파일을 열어서 다음과 같이 bootstrap의 JavaScript를 포함하도록 추가한다.

```javascript
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap/dist/js/bootstrap.min
```

## 테스트를 위한 bootstrap 컴포넌트를 뷰에 추가

RoR에서 Bootstrap이 이상없이 로드되었는지 확인하기 위해서 뷰에 간단하게 Bootstrap 컴포넌트를 추가해보자. 테스트를 위해 추가한 **Greetings** 컨트롤러의 뷰인 **app/views/greetings/hello.html.erb** 파일을 열어서 다음과 같이 수정한다.

```html
<h1>Greetings#hello</h1>
<p>Find me in app/views/greetings/hello.html.erb</p>

<button type="button" class="btn btn-default" aria-label="Left Align">
  <span class="glyphicon glyphicon-align-left" aria-hidden="true"></span>
</button>

<button type="button" class="btn btn-default btn-lg">
  <span class="glyphicon glyphicon-star" aria-hidden="true"></span> Star
</button>
```
이제 RoR 프로젝트 서버를 실행하고 브라우저에서 해당 뷰를 요청해보자.

```
rails s
```

http://localhost:3000/greetings/hello

결과를 살펴보면 RoR에서 Bower를 사용하여 Bootstrap의 assets들이 정상적으로 포함되어 잘 동작하는 것을 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/711?size=full&m=1445585175)

## Bootstrap-Sass 설정

위에서 소개한 RoR에서 Bootstrap을 사용하는 방법은 완벽하게 만들어진 Bootstrap의 배포용 CSS와 JavaScript를 프로젝트에 포함하는 방법이다. Bootstrap을 사용하여 웹 프로젝트를 진행하기 위해서는 스타일을 체계적으로 개발하는 방법이 필요하게 되는데 Bootstrap은 [Less](http://lesscss.org/)를 사용하여 개발되어 졌기 때문에 Less을 사용해야하는데 RoR은 Less가 아닌 [SASS](http://sass-lang.com/)를 사용한다. Bootstrap은 많은 SASS 개발자들을 위해서 [bootstrap-sass](https://github.com/twbs/bootstrap-sass)를 공식적으로 지원하고 있다. Bootstrap-Sass를 설정하는 방법을 살펴보자.

Bower를 사용하여 bootstrap-sass를 설치하기 위해서 bower.json에 bootstrap-sass 패키지를 추가한다. 기존에 설치된 bootsrap 패키지와 혼란이 생길 수 있기 때문에 기존의 bootstrap 패키지를 삭제하도록 하자.

```
bower uninstall bootstrap
```

![](http://assets.hibrainapps.net/images/rest/data/712?size=full&m=1445585958)

위 명령어로 패키지를 삭제하면 bower 패키지 디렉토리에서 해당 패키지가 삭제된다. 기존의 boostrap 패키지를 삭제한 이후 bower.json의 패키지를 다음과 같이 수정한다.

```javascript
{
  "name": "TestApp",
  "authors": [
    "saltfactory <saltfactory@gmail.com>"
  ],
  "description": "",
  "main": "",
  "moduleType": [],
  "keywords": [
    "bower",
    "rails"
  ],
  "license": "MIT",
  "homepage": "",
  "ignore": [
    "**/.*",
    "node_modules",
    "bower_components",
    "app/components/",
    "test",
    "tests"
  ],
	"dependencies":{
		"bootstrap-sass":"latest"
	}		
}
```

bower.json 설정을 마치면 bower를 사용하여 추가한 패키지를 설치한다.

```
bower install
```

설치 명령어가 끝나면 **vendor/assets/bower_components/bootstrap-sass** 경로에 패키지가 설치된 것을 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/713?size=full&m=1445586050)

## application.js에 boostrap-sass JavaScript 포함하기

bootstrap-sass에 사용하는 boostrap의 JavaScript는 앞에서 정의한 boostrap의 배포용 JavaScript과 동일하다. 하지만 boostrap-sass 패키지를 설치하면서 이전의 boostrap 패키지를 삭제했기 때문에 RoR에서 bootstrap-sass의 JavaScript를 포함할 수 있도록 **app/assets/javascript/application.js** 파일을 다음과 같이 수정한다.

```javascript
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-sass/assets/javascripts/bootstrap.min
```

## @import를 사용하여 bootstrap SASS 포함하기

SASS는 [@import](http://sass-lang.com/guide)를 사용하여 미리 정의된 SCSS 파일을 가져올 수 있다. 우리는 bootstrap-sass를 가지고 작업을 하기 때문에 앞에서 bootstrap의 css와 javascript를 포함한 것과 다른 방법을 사용해야한다.

우선 앞에서 사용한 bootstrap의 css 파일을 가져오기 위해서 정의한 **app/assets/stylesheets/application.css** 파일을 열어서 앞에서 정의한 bootstrap의 require를 삭제한다.

```css
/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, vendor/assets/stylesheets,
 * or any plugin's vendor/assets/stylesheets directory can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any styles
 * defined in the other CSS/SCSS files in this directory. It is generally better to create a new
 * file per style scope.
 *
 *= require_tree .
 *= require_self
 */
```

우리는 앞에서 테스트를 위해서 컨트롤과 뷰를 추가했다. 이때 생성되어진 scss 파일이 있는데 우리가 Greetings 라는 이름으로 컨트롤러를  만들었기 때문에 **app/assets/stylesheets/greetings.scss** 파일이 만들어져있다. 이 파일을 열어서 다음과 같이 수정한다.

```scss
// Place all the styles related to the Greetings controller here.
// They will automatically be included in application.css.
// You can use Sass (SCSS) here: http://sass-lang.com/

@import "bootstrap-sass/assets/stylesheets/bootstrap"
```

이제 RoR 서버를 시작하면 Greetings 컨트롤를 통해 요청이 들어오는 뷰에서 bootstrap-sass의 boostrap이 greetings.scss에 포함되어 함께 전처리되어 css 파일을 RoR의 assets pipeline에 추가되어 렌더링이 되어질 것이다.

서버를 시작해서 브라우저로 요청해보자.

```
rails s
```

http://localhost:3000/greetings/hello

결과는 어떠한가? 다음 그림과 같이 font에 관련된 assets를 찾지 못했다는 결과와 함께 greeings asset에 boostrap assets 포함되어 만들어진 css가 나타날 것이다.

![](http://assets.hibrainapps.net/images/rest/data/714?size=full&m=1445586982)

이유는 SASS에서 참조하는 font의 경로가 RoR의 assets pipeline으로 만들어지는 경로와 맞지 않기 때문이다.  이러한 문제는 RoR 프로젝트에서 기존의 CSS로 만들어진 파일을 Assets Pipeline으로 포함시켜서 작업하거나 SCSS로 변경하여 작업할 때 자주 만나게 되는 문제이다. 이 문제를 해결하기 위해서는 RoR의 Assets Pipeline 개념을 잘 이해해야한다. RoR의 Assets Pipeline은 컴파일된 assets을 assets에 관련된 패스로 접근하기 때문에 발생하는 문제인데 이것을 css나 scss 파일을 열어서 컴파일된 assets의 경로로 변경하면 된다. 하지만 이것을 복잡한 문제를 야기시키가나 꽤 불편한 작업이다. Bootstrap-Sass는 이렇게 Assets Pipeline에 대해서 발생하는 문제점을 해결하기 위해서 **_boostrap-sprokerts.scss**를 사용하여 쉽게 해결할 수 있도록 하였다. 이 파일은 RoR의 Assets Pipeline을 사용할 경우의 font 패스가 변경되어 지는 것을 함수로 만들어서 처리하도록 한 것이다.

우리는 다시 **app/assets/stylesheets/greeings.scss** 파일을 열어서 다음과 같이 수정하자.

```scss
// Place all the styles related to the Greetings controller here.
// They will automatically be included in application.css.
// You can use Sass (SCSS) here: http://sass-lang.com/

$icon-font-path: "bootstrap-sass/assets/fonts/bootstrap/";
@import "bootstrap-sass/assets/stylesheets/bootstrap-sprockets";
@import "bootstrap-sass/assets/stylesheets/bootstrap";
```

그리고 다시 뷰를 확인해보자. 하지만 다음과 같이 웹폰트를 찾을 수 없다는 에러가 발생한다.

```
Showing /Users/saltfactory/Projects/Workspaces/Rails/TestApp/app/views/layouts/application.html.erb where line #5 raised:

Asset filtered out and will not be served: add `Rails.application.config.assets.precompile += %w( bootstrap-sass/assets/fonts/bootstrap/glyphicons-halflings-regular.eot )` to `config/initializers/assets.rb` and restart your server
```

![](http://assets.hibrainapps.net/images/rest/data/715?size=full&m=1445587858)

이 문제는 Assets Pipeline에서 assets을 참조할 때 컴파일되어진 assets을 참조하는데 font 자원들이 포함되도록 설정이 되어 있지 않기 때문이다. Assets Pipeline에 관련된 설정은 **config/initializers/assets.rb**에서 설정한다고 앞에서 설명하였다. 이 파일을 다시 열어보자.

## assets에 font 추가하기

위 문제는 bootstrap의 font 들이 Assets Pipeline에 컴파일되어 포함되어 있지 않기 때문이다. **config/initializers/assets.rb** 열어서 다음과 같이 수정한다.

```ruby
# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.paths << Rails.root.join('vendor','assets','bower_components')
Rails.application.config.assets.precompile << %r(bootstrap-sass/assets/fonts/bootstrap/[\w-]+\.(?:eot|svg|ttf|woff2?)$)
```

이제 서버를 재시작하고 뷰를 확인해보자. 반드시 서버를 재시작해야하는 이유는 서버가 재시작할 때 assets들이 컴파일되기 때문이다.

http://localhost:3000/greetings/hello

![](http://assets.hibrainapps.net/images/rest/data/716?size=full&m=1445588236)

이제 Bootstrap의 SCSS를 참조하여 나만의 SCSS를 개발할 수 있게 되었다. Bootstrap-Sass의 여러가지 스타일 변수를 사용하거나 상속하거 참조해서 보다 효율적인 스타일 개발을 할 수 있을 것이다.

## 결론

우리는 앞서 **Ruby on Rails**에서 **Bower**를 사용하여 웹 컴포넌트를 쉽게 설치하여 사용하는 방법들을 살펴보았다. 우리는 실제 개발을 할 때 **Bootstrap**을 즐겨 사용하는데 RoR 프로젝트에서 Bower를 사용하여 Bootstrap을 사용하는 방법을 살펴보았다. 이 때 Bootstrap의 배포용 CSS와 JavaScript를 그대로 사용하는 방법도 있지만 Bootstrap의 스타일 변수를 참조하여 새롭게 스타일을 개발할 경우 Bootstrap의 **Less**를 사용해야하는데, RoR은 기본적으로 Less를 사용하지 않고 **SASS**를 사용하기 때문에 **Bootstrap-Sass**를 설치해서 사용해야한다. 이 때 주의해야할 점은 font 패스이다. Font 자체도 RoR 프로젝트에서는 Assets Pipeline에 컴파일되어 포함시켜 참조해야하기 때문에 기존의 웹 URL의 font 패스로 참조하게 되어 있는 스타일 코드는 문제를 발생한다. Bootstrap-Sass에서는 이 문제를 해결하기 위해서 **_bootstrap-sprokets.scss** 파일을 추가했다. 만약 Assets Pipeline을 사용할 경우 해당한는 Font 패스를 수정하여 RoR의 Assets에서 참조할 수 있게 한다. 이렇게 RoR에서 assets 컴파일에 관련한 설정은 **config/initializers/assets.rb**에서 설정하는데 이 곳에 font의 리소스 경로를 추가하면 서버가 재시작할 때 자원들을 미리 컴파일하여 Assets Pipeline에서 참조할 수 있도록 해준다. Ruby on Rails의 이런 방법은 꽤 복잡한 방법처럼 보이지만 실제 Assets Pipeline이라는 개념에 익숙해지게 되면 복잡한 리소스의 구조를 Assets Pipeline이라는 개념으로 쉽게 참조할 수 있게 된다.

## 참고

1. http://blog.saltfactory.net/ruby/using-bower-in-ror.html
2. http://getbootstrap.com/getting-started/
3. https://github.com/twbs/bootstrap-sass


## 연구원 소개

* 작성자 : [송성광](http://saltfactory.net/profile) 개발 연구원
* 프로필 : http://saltfactory.net/profile
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
