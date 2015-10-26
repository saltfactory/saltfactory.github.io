---
layout: post
title : less-rails를 사용하여 Ruby on Rails에서 Less와 Bootstrap Less 컴포넌트 사용하기
category : ruby
tags : [ruby, gem, ror, bower, rails, less]
comments : true
images :
  title : http://assets.hibrainapps.net/images/rest/data/724?size=full
---


## 서론

체계적인 CSS 개발을 하기 위해서 [SASS](http://sass-lang.com/)와 [Less](http://lesscss.org/)를 많이 사용한다. SASS는 Ruby 기반 환경으로 되어 있고, Less는 Node.js 기반 환경으로 되어 있다. RoR은 기본적으로 SASS를 프레임워크 환경에 포함하고 있기 때문에 프로젝트를 생성하면 특별한 설정없이 바로 SASS를 사용할 수 있기 때문에 RoR 프로젝트를 사용하는 곳에서는 Less보다는 SASS가 많이 사용된다. 만약 Node.js나 Less로 되어 있는 프로젝트에서 Less 파일을 RoR로 가져와서 작업하거나, RoR 프로젝트에서 Less 기반으로 CSS를 개발하기 위한 방법이 필요할 수 있다. 예를 들어, **Bootstrap**은 Less 기반으로 만들어져있는데, 온라인 문서에서는 Less의 사용방법만 공개하고 있기 때문이다. Bootstrap-Sass도 제공하지만 문서는 Less 변수를 Sass 변수로 변경하여 사용하거나 문서에는 Bootstrap Sass 리소스 사용 방법이 나와있지 않기 때문에 Less 를 사용하는 것이 처음 Bootstrap을 사용할 때 편리할 수 있다. 이 포스팅에서는 Ruby on Rails 프로젝트에서 Less를 사용하는 방법과 Bootstrap을 Less를 가지고 사용하는 방법을 소개한다.

<!--more-->

## Less

우선 Less는 NPM으로 설치를 해야한다. 다시 말해서 시스템에 Node.js가 설치되어 있어야 한다. 공식 사이트에서 시스템에 맞는 Node.js를 설치하면 된다. Mac의 경우 [HomeBrew](http://brew.sh/) 사용하여 다음과 같이 간단히 설치할 수 있다.

```
brew install node
```

다음은 Less를 설치한다.

```
npm install -g less
```

## less-rails 설치

Ruby on Rails는 기본적으로 SASS를 프레임워크에 도입하고 있다. 그래서 컨트롤러를 생성하면 자동으로 뷰의 스타일을 제작하기 위한 SASS 파일이 만들어진다. 또한, SASS 파일을 가지고 작업하면 자동으로 컴파일되어 RoR 의 뷰에 스타일이 바로 적용되는 환경을 보장받는다.

[less-rails](https://github.com/metaskills/less-rails)는 RoR 프로젝트에서 SASS를 사용하듯 Less를 사용할 수 있는 환경을 제공한다.

RoR 프로젝트의 **Gemfile**을 열어서 다음 gem 패키지를 추가한다.

```ruby
gem 'less'
gem 'less-rails'
gem 'therubyracer'
```

추가한 gem을 설치하기 위해서 bundler를 사용하여 설치한다.

```
bundle install
```

## RoR에서 less를 사용하도록 Assets 설정하기

Ruby on Rails 프로젝트의 Assets에 관계된 설정을 하는 파일은 **config/initializers/assets.rb** 파일이다. 이 파일을 열어서 다음과 같이 Less를 사용할 수 있도록 수정한다.

- **app_generators.stylesheet_engine** : RoR의 스타일시트 엔진을 **:less**로 변경한다.
- **less.compress** : 이 값을 true로 하면 Less가 CSS로 컴파일될 때 자동으로 압축을하게 된다.

```ruby
# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.app_generators.stylesheet_engine :less
Rails.application.config.less.compress = true
```

## 테스트를 위한 컨트롤러 추가

이제 RoR의 스타일시트 엔진이 Less로 변경되었다. 테스트를 위해서 컨트롤러를 추가해보자.

```
rails g controller Greetings hello
```

생성된 파일을 살펴보자. 컨트롤러가 추가되면서 자동으로 생성되는 파일 중에 **.less** 파일이 생성되는 것을 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/718?size=full&m=1445823525)

RoR은 서버를 재시작하지 않고도 변경된 파일의 내용을 적용할 수 있는 장점이 있어 개발 속도를 빠르게할 수 있다. less 파일을 수정하면 바로 스타일시트가 변경되어 뷰에 적용되는지 살펴보자. 테스트를 위해 추가한 컨트롤러가 생성될 때 만들어진 **app/assets/stylesheets/greetings.css.less** 파일을 열어서 다음과 같이 간단히 less를 작성해서 저장한다.

```css
// Place all the styles related to the Greetings controller here.
// They will automatically be included in application.css.
// You can use Less here: http://lesscss.org/

@base: #f938ab;

.box-shadow(@style, @c) when (iscolor(@c)) {
  -webkit-box-shadow: @style @c;
  box-shadow:         @style @c;
}
.box-shadow(@style, @alpha: 50%) when (isnumber(@alpha)) {
  .box-shadow(@style, rgba(0, 0, 0, @alpha));
}
.box {
  color: saturate(@base, 5%);
  border-color: lighten(@base, 30%);
  div { .box-shadow(0 0 5px, 30%) }
}
```

다음은 뷰에 적용하기 위해서 **app/views/greetings/hello.html.erb** 파일을 열어서 다음과 같이 수정한다.

```html
<h1>Greetings#hello</h1>
<div class="box"><div>Find me in app/views/greetings/hello.html.erb</div></div>
```

RoR 서버를 실행하여 하여 뷰를 확인해보자. 서버가 실행되고 있으면 그냥 뷰를 확인하면 된다. less나 뷰 파일이 변경되면 RoR에 자동으로 반영되기 때문이다.

http://localhost:3000/greetings/hello

뷰를 확인하면 Less 파일이 컴파일되어 CSS 파일이 만들어져 RoR Assets를 통해 뷰의 스타일시트 적용이 된 것을 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/719?size=full&m=1445823947)

## Bootstrap 의 Less 사용하기

Bootstrap은 Less로 만들어져있다. Bootstrap가 만들어 놓은 변수, 함수 또는 mixin을 사용하여 나에게 맞는 스타일을 새롭게 만들 수 있는데, RoR는 기본적으로 SASS를 사용하기 때문에 Bootstrap-Sass 프로젝트를 프로젝트에 추가해서 개발해야만 한다. 하지만 우리는 앞에서 RoR에서 Less를 사용할 수 있도록 환경을 구축했다. 이제 Bootstrap의 Less를 가지고 바로 적용할 수 있다.

Bower를 가지고 RoR 프로젝트에 Bootstrap을 추가한다. Bower는 Node.js가 기본적으로 설치되어져 있어야하고 NPM으로 Bower를 설치해야한다.

```
npm install -g bower
```

다음은 프로젝트 루트에서 bower init 명령을 사용해 bower.json 파일을 만든다.

```
bower init
```

생성된 bower.json 파일에 bootstrap 패키지를 추가한다.

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

이제 bower 컴포넌트들이 설치될 곳을 지정하기 위해 bower.json 파일이 있는 위치에서 **.bowerrc** 파일을 다음 내용으로 저장하여 생성한다.

```javascript
{
"directory": "vendor/assets/bower_components/"
}
```

프로젝트에서 Bower를 사용해서 bootstrap을 설치할 준비가 끝났다. bower 사용하여 bootstrap을 설치한다.

```
bower install
```

bower를 사용하기 위한 방법은 [Ruby on Rails 에서 bower 사용하기](http://blog.saltfactory.net/ruby/using-bower-in-ror.html) 글에 자세하게 설명했으니 참조하면 도움이 될 것이다.

이제 프로젝트에 Bootstrap 패키지가 설치되었는데 생성된 패키지 **vender/assets/bower_components/bootstrap** 디렉토리를 살펴보면 **less**라는 디렉토리가 보일 것이다. 이 안에 Bootstrap 스타일을 위한 Less 파일들이 존재하는 것을 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/720?size=full&m=1445824576)

RoR 프로젝트에서 **config/initializers/assets.rb** 파일을 열어 Assets 패스에 이 경로를 추가한다.

```ruby
# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.app_generators.stylesheet_engine :less
Rails.application.config.less.paths << "#{Rails.root}/vendor/assets/bower_components/bootstrap/less"
Rails.application.config.less.compress = true
```

이제 내 프로젝트에 Bootstrap의 Less를 적용해보자.
우리가 앞에서 생성한 **app/assets/stylesheets/greetings.css.less** 파일을 열어서 Bootstrap의 less를 임포트한다.

```css
// Place all the styles related to the Greetings controller here.
// They will automatically be included in application.css.
// You can use Less here: http://lesscss.org/

@import "bootstrap/less/bootstrap.less";

@base: #f938ab;

.box-shadow(@style, @c) when (iscolor(@c)) {
  -webkit-box-shadow: @style @c;
  box-shadow:         @style @c;
}
.box-shadow(@style, @alpha: 50%) when (isnumber(@alpha)) {
  .box-shadow(@style, rgba(0, 0, 0, @alpha));
}
.box {
  color: saturate(@base, 5%);
  border-color: lighten(@base, 30%);
  div { .box-shadow(0 0 5px, 30%) }
}
```

Bootstrap less 스타일이 적용되는지 확인하기 위해서 뷰 파일을 다음과 같이 수정한다.

```html
<h1>Greetings#hello</h1>
<div class="box"><div>Find me in app/views/greetings/hello.html.erb</div></div>


<button type="button" class="btn btn-default" aria-label="Left Align">
  <span class="glyphicon glyphicon-align-left" aria-hidden="true"></span>
</button>

<button type="button" class="btn btn-default btn-lg">
  <span class="glyphicon glyphicon-star" aria-hidden="true"></span> Star
</button>
```

브라우저를 열어서 확인해보자. Bootstrap의 코드를 가지고 나의 less 파일과 함께 컴파일되어 적용된 것을 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/721?size=full&m=1445824969)


좀더 구제척으로 Bootstrap의 Less를 어떻게 사용할 수 있는지 간단한 예를 살펴보자. 만약 Bootstrap에서 작성한 **.border-left-radius** 로 만든 함수(왼쪽에 radius를 적용하는 스타일이 정의된 함수)를 가지고  나의 스타일에 적용하고 싶을 경우 다음과 같이 하면된다.

```css
// Place all the styles related to the Greetings controller here.
// They will automatically be included in application.css.
// You can use Less here: http://lesscss.org/

@import "bootstrap/less/bootstrap.less";
div{ .border-left-radius(5px); margin: 20px; }


@base: #f938ab;

.box-shadow(@style, @c) when (iscolor(@c)) {
  -webkit-box-shadow: @style @c;
  box-shadow:         @style @c;
}
.box-shadow(@style, @alpha: 50%) when (isnumber(@alpha)) {
  .box-shadow(@style, rgba(0, 0, 0, @alpha));
}
.box {
  color: saturate(@base, 5%);
  border-color: lighten(@base, 30%);
  div { .box-shadow(0 0 5px, 30%) }
}
```

뷰를 확인해보자. 나의 뷰의 DIV 왼쪽으로 radisu가 적용된 것을 확인할 수 있다. 이렇게 Bootstrap이 만들어 놓은 스타일 함수들을 가져와서 사용할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/723?size=full&m=1445825382)

## 결론

JavaScript를 좀 더 체계적이고 구조적으로 만들기 위해 CoffeeScript와 같은 전처리가 존재하듯 CSS 파일을 프로그래밍할 수 있는 SASS와 Less가 존재한다. SASS는 Ruby 기반으로 Ruby on Rails에 기본적으로 포함되어 있기 때문에 RoR 프로젝트에서 SASS를 가지고 바로 스타일시트를 개발할 수 있다. Less는 Node.js 기반으로 웹 컴포넌트를 개발하는 프론트엔드 개발자들이 많이 사용하고 있다. Bootstrap 또한 Less로 개발이 되어져 있기 때문에 RoR 프로젝트에 Bootstrap의 컴포넌트들을 바로 사용할 수는 없다. 그래서 Bootstrap-Sass를 사용해서 사용하는 방법을 [Ruby on Rails 에서 bower를 사용하여 Bootstrap, Bootstrap-Sass 적용하기](http://blog.saltfactory.net/ruby/using-bootstrap-in-rails.html) 글을 통해 소개를 했다. 하지만 Bootstrap의 공식문서에는 Bootstrap의 컴포넌트를 사용하는 방법으로 Less를 사용하는 방법만 소개하고 있다. Bootstrap-Sass를 사용한다면 변수를 달라지거나 약간 다른 스타일로 사용해야하기 때문에 RoR에서 Less를 그대로 사용할 수 있는 방법이 필요할수도 있다. RoR에서 SASS 대신 Less를 사용하는 방법은 [less-rails](https://github.com/metaskills/less-rails) 를 사용하여 RoR의 스타일시트 엔진을 Less로 변경하는 것이다. less-rails를 사용하여 RoR 스타일시트 엔진을 수정하면 Bootstrap의 Less 컴포넌트를 사용하여 나만의 스타일시트를 Less로 구현할 수 있다.

## 참고

1. https://github.com/metaskills/less-rails
2. http://getbootstrap.com/getting-started/
3. http://lesscss.org/

## 연구원 소개

- 작성자 : [송성광](http://saltfactory.net/profile) 개발 연구원
- 프로필 : http://saltfactory.net/profile
- 블로그 : http://blog.saltfactory.net
- 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
- 트위터 : [@saltfactory](https://twitter.com/saltfactory)
- 페이스북 : https://facebook.com/salthub
- 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
- 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
