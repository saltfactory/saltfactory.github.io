---
layout: post
title: Ruby on Rails 에서 bower 사용하기
category: ruby
tags:
  - ruby
  - gem
  - ror
  - bower
  - rails
comments: true
images:
  title: 'http://asset.blog.hibrainapps.net/saltfactory/images/a50c1421-45b5-41d3-a4f8-d40bdd71619c'
---

## 서론

웹 프로젝트를할 때 오픈소스 라이브러리를 가져와서 개발할 경우가 많은데 최근는 bower 를 사용하여 패키지를 관리하거나 설치하는 경우가 많다. 이 포스팅에서는 Ruby on Rails 프로젝트에서 bower를 함께 사용하는 방법에 대해서 소개한다.

<!--more-->

## Node.js와 Bower 설치

Bower는 기본적으로 Node.js의 NPM으로 설치를 한다. 다시 말해서 시스템에 Node.js가 설치가 되어 있어야한다. 만약 시스템에 Node.js가 설치되어 있지 않으면 https://nodejs.org/en/ 에서 해당하는 시스템에 맞는 설치 파일을 가지고 설치하거나 Mac 일경우 HomeBrew를 사용하여 다음과 같이 간단하게 설치할 수 있다.

```
brew install node
```

Node.js 설치가 끝나면 Bower를 사용하기 위해서 bower를 설치한다.

```
npm install -g bower
```

## 테스트를 위한 Ruby on Rails 프로젝트 생성

RoR 프로젝트를 하나 생성해보자. 프로젝트를 생성하면 필요한 gem 패키지들을 자동으로 함께 설치가 된다.
```
rails new TestApp
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/5246b8c5-4a62-4fe2-8326-68994d2c4604)

## bower.json 설정

이제 RoR에서 bower 패키지를 설치해보자. bower를 사용하여 패키지를 설치 하기 위해서는 다음과 같이 bower 인스톨 명령어를 사용하여 필요한 패키지를 설치할 수 있다. 예를 들어 [FontAwesome](https://fortawesome.github.io/Font-Awesome/) 패키지를 설치한다고 가정하면 다음과 같이 **bower install** 명령을 가지고 설치할 수 있다.

```
bower install fontawesome
```

이 명령은 필요한 패키지를 하나씩 설치할 때 사용한다. 프로젝트를 개발할 때 한번에 여러가지 패키지를 설치하거나 프로젝트에 필요한 패키지를 명시해서 관리할 때는 [bower.json](http://bower.io/docs/creating-packages/) 파일을 사용한다. bower.json 파일은 다음과 같이 bower 명령어로 생성할 수 있다.

```
bower init
```

**bower init** 명령을 실행하면 다음과 같이 인터렉티브하게 질문이 나오고 해당 값을 입력하면 자동으로 bower.json 파일이 생성이 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/678907fe-6031-4071-a20f-55472bd20706)

기본값으로 만들어진 bower.json은 다음과 같다.

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
  ]
}
```

테스트를 위해서 bower.json에 앞에서 개별적으로 설치한 [FontAwesome](https://fortawesome.github.io/Font-Awesome/) 을 설치할 수 있도록 정의해보자. bower.json 에 패키지를 추가한다.

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
		"fontawesome": "latest"
	}		
}
```

## .bowerrc 파일 생성

**bower install** 명령을 사용하면 기본적으로 현재 디렉토리 안에 **bower_components**라는 디렉토리 안에 패키지들을 설치를 한다. RoR 프로젝트 디렉토리 아래 **bower.json** 파일을 참조하여 bower 패키지를 설치하게 할 경우 RoR의 디렉토리 루트경로에 바로 bower_components가 만들어지게 된다. 우리는 bower 패키지들이 **vender/assets/bower_components/** 아래 설치되기를 원하기 때문에 bower.json 파일 경로에 동일하게 bower 설정을 위한  [.bowerrc](http://bower.io/docs/config/) 파일을 추가한다. 이 때 이 파일에 다음 내용을 저장하도록 한다.

```javascript
{
  "directory": "vendor/assets/bower_components/"
}
```

## bower 패키지 설치

이제 bower를 사용하여 bower  패키지를 설치해보자. **bower install** 명령어는 현재 디렉토리의 **bower.json** 파일을 참조하여 필요한 패키지를 일괄적으로 설치한다. RoR 의 루트경로에 bower.json을 생성하였기 때문에 같은 경로에서 bower 설치 명령어를 실행한다.

```
bower install
```

앞에서 우리는 bower.json에 **fontawesome** 패키지를 설치할 것이라고 정의하였고 .bowerrc에 bower 패키지가 설치될 디렉토리를 지정하였기 때문에 이 명령어를 실행하면 해당 경로에 패키지가 설치될 것이다. 실행결과 마지막 메세지에 패키지가 설치된 경로 **vender/assets/bower_components/fontawesome**을 볼 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/29e337cf-7e9c-4488-9eb0-329b799f261e)

## RoR의 Assets 경로 추가하기

위 작업들은  RoR 프로젝트와 상관없이 Bower를 사용하여 bower 패키지를 설치한 것일 뿐이고 이제 설치한 bower 패키지를 RoR 프로젝트에 사용할 수 있게 RoR에 설정을 해야한다. 우리는 새로운 assets를 추가했다. 이것을 RoR에 설정하여 새로운 Assets들을 로드할 수 있게 해야한다. RoR에서 Assets의 설정은 **config/initializers/assets.rb**에서 할 수 있다. 이 파일을 열어서 앞에서 정의한 Bower 패키지가 설치될 디렉토리를 RoR의 assets 경로에 추가한다.

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

## Assets에 Bower 패키지 로드하기

**config/initializers/assets.rb**에 bower 패키지 설치 디렉토리를 Assets의 경로를 추가하였기 때문에 이제 RoR에서 assets pipeline으로 바로 로드할 수 있다. RoR에서 기본적으로 로드하는 **app/assets/stylesheets/application.css** 파일을 열어서 앞에서 추가한 fontawsome의 css 파일을 포함하도록 설정한다.

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
 *= require fontawesome/css/font-awesome.min
 */
```

## 서버 실행 및 assets 확인

테스트를 위해서 컨트롤러와 뷰를 추가하자.

```
rails g controller Greetings hello
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/04b34866-f641-407b-af6e-abf79eb24163)

다음은 RoR 서버를 실행시키고 브라우저를 열어서 앞에서 bower를 사용하여 포함한 패키지가 웹 사이트의 assets로 로드되어 졌는지 확인해보자.

```
rails s
```

http://localhost:3000/greetings/hello

![](http://asset.blog.hibrainapps.net/saltfactory/images/7e4e403c-2079-4de6-a34c-4a2a3a1d9b86)

RoR 프로젝트에 Bower 패키지가 정상적으로 assets에 포함되어 동작하는 것을 확인할 수 있을 것이다.

## 결론

Bower를 사용하면 웹 개발에 필요한 패키지를 쉽게 구하거나 관리할 수 있다. Bower는 기본적으로 Node.js 환경으로 많이 사용되어지는데 Ruby on Rails에 Bower를 사용하여 웹 assets를 관리하기 위한 방법을 소개했다. RoR은 4버전부터 Assets Pipeline이라는 개념으로 assets를 관리하는데 bower를 사용하여 설치한 assets를 RoR의 **config/initializers/assets.rb** 파일에 assets 경로에 추가하여 사용할 수 있다. Ruby on Rails에 bower를 추가적으로 사용하면 더욱 효율적으로 효과적인 빠른 웹 개발을 할 수 있을 것으로 예상된다.

## 참고

1. http://dotwell.io/taking-advantage-of-bower-in-your-rails-4-app/

