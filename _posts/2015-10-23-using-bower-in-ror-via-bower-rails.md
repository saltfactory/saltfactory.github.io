---
layout: post
title: bower-rails를 사용하여 Ruby on Rails 에서 간단하게 bower 사용하기
category: ruby
tags:
  - ruby
  - gem
  - ror
  - bower
  - rails
comments: true
images:
  title: 'http://asset.blog.hibrainapps.net/saltfactory/images/816159f7-9204-4965-9a0b-548daf0de03d'
---

## 서론

웹 프로젝트를할 때 오픈소스 라이브러리를 가져와서 개발할 경우가 많은데 최근는 [bower](http://bower.io/) 를 사용하여 패키지를 관리하거나 설치하는 경우가 많다. 우리는 앞서 [Ruby on Rails에서 Bower를 사용하는 방법](http://blog.saltfactory.net/ruby/using-bower-in-ror.html)을 살펴보았다. Ruby on Rails에서 Ruby 라이브러리를 가져오기 위해서 Gemfile에 gem 라이브러리를 정의하여 bundle install 명령어로 쉽게 설치할 수 있다. Ruby on Rails는 기본적으로 Bower가 설치되어 있지 않다. 이 포스팅에서는 Ruby on Rails에서 [bower-rails](https://github.com/rharriso/bower-rails/)를 사용하여 간단하게 Bower를 사용하는 방법에 대해서 설명한다.

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

![](http://asset.blog.hibrainapps.net/saltfactory/images/288aada9-4e4c-43dc-8a94-9de7ce193ff8)

하지만 최초 RoR 프로젝트가 생성될 때 bower에 관련된 패키지는 자동으로 설치가 되지 않는다.

## RoR에서 bower-rails 설치

[bower-rails](https://github.com/rharriso/bower-rails/)는 RoR에서 Bower를 사용할 수 있도록 gem 패키지로 만들어진 것이다. RoR 프로젝트에서 **Gemfile**을 열어서 다음을 추가한다.

```ruby
gem 'bower-rails'
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/cb3eb3a0-c45f-4175-a640-fc81a0c19dca)

Gemfile에 bower-rails를 추가한 다음 [bundler](http://bundler.io/)을 가지고 설치한다.

```
bundle install
```

이 명령어를 사용하면 bundler는 새롭게 추가된 gem 패키지를 설치할 것이다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/bb0e90e7-77d9-424e-9080-7f007917b340)

## bower.json 생성 및 bower 패키지 설치하기


Bower를 사용하기 위해서는 Bower 패키지를 정의하기 위한 **bower.json** 파일이 필요하다. bower-rails 에서는 bower.json을 다음과 같이 생성할 수 있다.

```
rails g bower_rails:initialize json
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/d22390ac-1547-4d17-b77d-4c7b7cb67d79)

이 명령어는 RoR 프로젝트에 **bower.json** 파일과 **config/initializers/bower_rails.rb** 두가지 파일을 생성한다. bower 패키지를 다운로드하기 위해서는 bower.json 파일을 먼저 살펴보자. 기본적으로 만들어진 bower.json을 열어보면 다음과 같은 내용으로 저장이 되어 있다.

```javascript
{
  "lib": {
    "name": "bower-rails generated lib assets",
    "dependencies": {
      // "threex"      : "git@github.com:rharriso/threex.git",
      // "gsvpano.js"  : "https://github.com/rharriso/GSVPano.js/blob/master/src/GSVPano.js"
    }
  },
  "vendor": {
    "name": "bower-rails generated vendor assets",
    "dependencies": {
      // "three.js"    : "https://raw.github.com/mrdoob/three.js/master/build/three.js"
    }
  }
}
```
우리는 RoR 프로젝트의 **vendor/assets** 디렉토리 안에 Bower 패키지를 설치할 것이다. 테스트를 위해서 [Font Awesome](https://fortawesome.github.io/Font-Awesome/) 패키지를 bower를 사용하여 vendor 디렉토리 안에 설치해보자. bower.json 파일을 다음과 같이 수정한다.

```javascript
{
  "vendor": {
    "name": "bower-rails generated vendor assets",
    "dependencies": {
			"fontawesome": "latest"
    }
  }
}
```
![](http://asset.blog.hibrainapps.net/saltfactory/images/c2c05adc-b18b-4b78-93bc-47626190a236)

다음은 bower 패키지를 RoR에서 설치하기 위해서는 앞에서 설치한 **bower-rails**의 rake를 사용하면 된다.

```
rake bower:install
```

이 명령어를 사용하면 RoR의 프로젝트에 bower.json 에 정의한 Bower 패키지를 설치할 수 있게 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/a7543f6b-50b8-4c97-8793-96f485e509ae)

rake 명령어가 실행되고 난 이후 Bower의 패키지가 설치되는 곳을 확인해보자. 기본적으로 bower-rails로 Bower 패키지를 설치하면 **vendor/assets/**에 패키지가 설치된다. bower.json 에 fontawesome 패키지를 설치한다고 정의하였기 때문에 다음과 같이 **vendor/assets/fontawesome** 경로에 설치가 될 것이다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/01f2a5de-9446-41f2-b88f-717fba38820c)

## 테스트를 위한 RoR 컨트롤러와 뷰 추가

뷰 테스트를 위해서 간단하게 컨트롤러와 뷰를 추가해보자

```
rails g controller Greetings hello
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/eeb9ac9a-4b9c-4554-8f08-d947c2ef5511)

rails 서버를 실행해서 새롭게 만들어진 뷰를 확인하자. RoR 서버를 실행하고 브라우저로 http://localhost/greetings/hello 뷰를 열어본다.

```
rails s
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/72409a94-e7aa-4795-85dc-97206e8dcfdd)

RoR 서버에 앞에서 bower 패키지를 설치한 자원이 로드 되었는지 확인하기 위해서 브라우저의 Inspector를 열어서 확인해보자.

![](http://asset.blog.hibrainapps.net/saltfactory/images/1f14ca9c-a25c-4fb4-ae00-87508731a769)

우리는 앞에서 bower 패키지를 설치만 했을 뿐 RoR에 로드 시키지 않았기 때문에 아무런 자원이 로드 되지 않은 것을 확인할 수 있다.

## Assets Pipeline 에 설치한 Bower 패키지 로드하기

RoR이 웹 프레임워크의 assets 자원을 관리하기 위해서 4버전부터 [Assets Pipeline](http://guides.rubyonrails.org/asset_pipeline.html)가 도입이 되었다. 이것을 사용하면 **SASS** 나 **CoffeeScript**와 같은 전처리 언어를 사전에 컴파일하거나 **font**나 **image** 등과 함께 논리적으로 assets pipeline으로 연결할 수 있다. 개발의 편리성과 성능 향상을 위해서 도입된 이 개념은 이후에 조금씩 자세하게 설명하겠다.

일반적으로 RoR에서 Bower를 사용하여 설치한  패키지를 RoR의 assets pipeline으로 연결하기 위해서는 RoR에서 설치한 자원을 참조할 수 있도록 설정을 해야한다. 하지만 bower-rails를 사용할 경우 기본적으로 패키지를 바로 로드할 수 있도록 설정이 되어 있기 때문에 assets에 **require**만 지정하면 된다. RoR에서 기본적으로 포함하는 CSS 파일은 **app/assets/stylesheets/application.css** 파일이다. 이 파일을 열어보자.

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
일반적인 **CSS** 파일과 달리 이 파일 안에는 **=require_tree**와 **=require_self**가 포함이 되어 있다. 이것은 현재 **assets/stylesheets/** 디렉토리 안에 재귀적으로 포함된 스타일 파일을 모드 로드하는 것과 라우팅을 통해 들어올 때 컨트롤러와 액션의 이름에 맞는 해당 스타일을 로드하라는 표현이다. 우리는 bower를 사용하여 bower 패키지를 **vendor/assets/bower_components/fontawesome**으로 설치를 했는데, 이것을 RoR이 로드하게 정의하기 위해서 이 파일에 다음과 같이 **=require**를 사용하여 설치된 패키지의 자원을 추가한다. 이 때 bower-rails의 내부적인 설정은 기본적으로 **vender/assets/bower_components** 아래 bower 패키지를 참조하게 되어 있기 때문에 설치한 패키지에 접근하기 위해서는 패키지 디렉토리를 바로 참조하면 된다. 아래는 bower를 사용하여 설치한 패키지 중에 fontawsome 패키지의 css/font-awesome.min.css 파일을 로드하는 경우 이다.

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
 *= require 'fontawesome/css/font-awesome.min'
 */
```

다시 브라우저를 리로드하여 inspector를 통해 웹 리소스를 확인해보자. application.css 설정을 하지 않았던 처음과 달리 이제는 bower로 설치한 패키지 중에서 application.css에 정의한 bower 패키지를 로드한 것을 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/3f1a3227-2eec-491b-8c6f-b142554536d3)

## bower-rails 설정

기본적인 bower-rails 설정만으로도 충분히 bower를 사용할 수 있지만 bower-rails의 설정을 수정하기 위해서는 앞에서 bower 초기화를 위한  **rails g bower_rails:initialize json** 명령어 실행후 생성된 **config/initializers/bower_rails.rb** 파일을 수정하면 된다. 생성된 파일을 열어보자.

```ruby
BowerRails.configure do |bower_rails|
  # Tell bower-rails what path should be considered as root. Defaults to Dir.pwd
  # bower_rails.root_path = Dir.pwd

  # Invokes rake bower:install before precompilation. Defaults to false
  # bower_rails.install_before_precompile = true

  # Invokes rake bower:resolve before precompilation. Defaults to false
  # bower_rails.resolve_before_precompile = true

  # Invokes rake bower:clean before precompilation. Defaults to false
  # bower_rails.clean_before_precompile = true

  # Invokes rake bower:install:deployment instead rake bower:install. Defaults to false
  # bower_rails.use_bower_install_deployment = true
  #
  # Invokes rake bower:install and rake bower:install:deployment with -F (force) flag. Defaults to false
  # bower_rails.force_install = true
end
```

이 파일은 bower-rails의 여러가지 설정을 정의하고 있다. 예를 들어 bower_rails가 어디에 bower 패키지를 설치하는지 정의하기 위해서 RoR의 루트경로를 필요로한다. **bower_rails.root_path** 에 RoR 프로젝트의 ROOT 디렉토리를 지정한다. 이 ROOT 디렉토리를 기준으로 bower 패키지 디렉토리의 경로가 만들어진다. bower 패키지들은 기본적으로 bower_components라는 디렉토리 이름으로 만들어지는데 bower_rails의 ROOT 경로를 기준으로 **#{Rails.ROOT}/vendor/assets/bower_components/**로 만들어지는 것이다.

## 결론

Ruby on Rails는 웹을 빠르게 개발하기 위한 풀스택 웹 개발 프레임워크이다. 최근 Node.js의 인기가 상승하면서 웹 자원의 원격저장소 관리를 bower를 사용하여 개발하는 곳이 많아졌다. RoR에서 Bower를 사용하여 bower 패키지를 설치하기 위해서는 기본적인 RoR의 패키지와 설정만으로는 사용할 수 없기 때문에 여러가지 설정을 해야한다. 다른 gem 없이 RoR에서 Bower를 사용하기 위한 방법은 [Ruby on Rails 에서 bower 사용하기](http://blog.saltfactory.net/ruby/using-bower-in-ror.html) 글에서 소개했다. **bower-rails**는 RoR에서 bower를 사용하기 위한 복잡한 설정을 하지 않고 bower를 사용할 수 있도록 미들웨어 패키지로 만들고 rake 인터페이스를 제공한다. 단지 Ruby on Rails 프로젝트의 Gemfile에 bower-rails gem을 추가하여 설치하면 간단하게 bower 패키지를 설치할 수 있고 assets pipeline에 포함할 수 있도록 제공할 수 있다. RoR은 빠르게 웹을 개발할 수 있는 환경을 제공하고 Bower는 유용한 웹 자원 패키지를 체계적이고 편리하게 사용할 수 있는 저장소를 제공하기 때문에 이 두가지를 함께 사용하면 더욱 효율적이고 효과적인 빠른 웹 개발을 할 수 있을 것이다.


## 참고

1. https://github.com/rharriso/bower-rails/
2. http://blog.saltfactory.net/ruby/using-bower-in-ror.html

