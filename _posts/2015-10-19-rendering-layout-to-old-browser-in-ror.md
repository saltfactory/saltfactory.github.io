---
layout: post
title: Ruby on Rails에서 모던 브라우저와 (IE8)이하 브라우저에 따른 뷰 레이아웃 구성하기
category: ruby
tags:
  - ruby
  - ruby on rails
  - ror
  - browser
comments: true
images:
  title: 'http://asset.blog.hibrainapps.net/saltfactory/images/cbce30a2-5b51-4f2e-bb35-76e863964242'
---

## 서론

HTML5 템플릿 프레임워크가 쏟아져 나오는 최근에는 대부분의 개발자들은 프로젝트에 적합한 프레임워크를 선정하여 개발에 들어가는 간다. 우리는 최신 유행하는 프레임워크를 도입하려고 했지만 아직도 IE9를 사용하는 사용자가 많은 이유로 우리는 결국 **모던 브라우저**(IE9 이상 Webkit 엔진 등 사용하는 최신 브라우저)와 모던 브라우저가 아닌 사용자를 분리하여 뷰 서비스를 분기하기로 결정했다. 최신 브라우저에게는 더 성능을 높일 수 있고, 구형 브라우저에게는 최적화된 뷰를 보여주기 위해서 내린 결정이였다. 이글은 Ruby on Rails에서 모던 브라우저와 (IE8)이하 브라우저에 따른 뷰 레이아웃 구성하는 방법에 대해서 소개한다.

<!--more-->

## 최신 HTML5 템플릿의 함정

프로젝트가 시작되면서 우리는 최근 인기 몰이를 하고 있는 **HTML5** 기반의 프레임워크를 사용하면서도 최신 트랜드에 맞춰 가장 인기있는 디자인 패턴을 적용하고 싶었다. Google Material Design 에 매료되어 이번 프로젝트는 Material Design에 관련된 프레임워크를 사용해보려고 했다. 그래서 처음 선택한 프레임워크가 [Materialize](http://materializecss.com/) 였다. HTML5, CSS3 그리고 jQuery 기반으로 만들어진 이 프레임워크는 간단한 CSS 클래스만으로 복잡한 grid와 Material Design을 구성할 수 있었다. 하지만 문제는 국내 사용자들은 Internal Explore를 많이 사용하고 있다는 것이다. 그래서 IE10 이상에서만 사용할 수 있는 이 프레임워크를 도입할 수 없었다. 차선책으로 [Google Material Design Lite](http://www.getmdl.io/)를 사용해야겠다고 생각했다. https://github.com/google/material-design-lite 에서는 IE9 이상에서도 어느정도 사용할 수 있다고 나와 있지만 사실은 [polyfill](https://en.wikipedia.org/wiki/Polyfill)을 사용해야 한다. 더 중요한 것은 100%로 호환을 지원하지도 않을 뿐만 아니라 JavaScript로 되어 있는 polyfill 때문에 DOM을 다시 렌더링한다거나 Display를 조작하기 때문에 브라우저에서 뷰가 깜빡이는 문제나 과도한 리소스 다운로드 등 생각하지 않아도 되는 문제를 만나게 된다는 것이다.

> HTML5는 멋지고 높은 성능의 뷰를 만들어줄 수 있게 해준다. 더구나 HTML5 기반의 프레임워크는 이런 뷰의 편리하고 빠르게 개발 할 수 있게 도와준다. 단! 모던 브라우저를 사용하는 사람들에게만 말이다.

실제로 생각없이 HTML5로 메인 뷰를 완벽하게 개발하고 난 뒤 polyfill을 사용하여 IE 사용자를 대처하려고 했는데 메뉴얼에서 나타난 polyfill을 사용하더라도 레이아웃이 완벽하게 호환되지 않는 것을 경험했다. 그래서 최신 템플릿을 모던 브라우저에게만 서비하고 구형 브라우저는 HTML4.1로 서비스를 하기로 결정하게 되었다.

참고로 모바일 웹 프로젝트는 HTML5를 지원하기 때문에 IE에 대한 고민 없이 바로 HTML5 기반의 프레임워크를 사용할 수 있다. 하지만 최근 HTML5 프레임워크들은 대부분 반응형 웹을 지원하기 위해서 모바일 뷰에서는 필요하지 않는 많은 코드들이 존재한다. 모바일 웹에 사용하기 위해서는 이런 부분을 제거하고 사용하던지 또 다른 방안들이 필요할 것이다. 이 부분에 관련된 이야기는 다음에 소개할 예정이다.

## 모든 브라우저와 IE 타겟 기준

우리는 IE를 위한 지원에 대한 기준점을 IE9로 결정을 했다. 통상적으로 모던 브라우저가 IE9 이상, Chrome, Safari, Firefox, Opera 등으로 정의하고 있기 때문에 최대한 지원하는 브라우저를 IE9로 결정한 것이다. IE9에서는 어느정도 필요한 CSS3를 사용할 수 있는 이유도 포함된다.

## RoR layout 동작 원리

우리는 이번 프로젝트를 RoR을 사용하기로 결정했다. RoR에서 Layout의 동작 원리를 살펴보자. 원문 글은 http://guides.rubyonrails.org/layouts_and_rendering.html 글을 참조하면 더 자세히 알 수 있다.

RoR을 사용하여 빠르게 웹을 개발할 수 있는 이유는 바로 **설정보다는 관례(Convention over Configuration)**와 **DIY(Don’t Repeat Yourself)** 때문이다.

간단히 설명하자면 다음과 같다.

기본적으로 RoR에서 뷰에 관련된 파일은 `app/views/`에 만들어진다.  위에서 설명한 관례에 대해서 살펴보면 만약 `BooksController`라는 컨트롤러를 만든다고 가정하자.

```ruby
class BooksController < ApplicationController
	def index
	end
end
```

컨트롤러를 만들었고 URL 요청에 매핑하기 위해서 `routes.rb`에 다음과 같이 리소스를 설정한다.

```ruby
resources :books
```

이렇게 정의한 컨트롤러의 뷰는 RoR에서 자동으로 `app/views/books/index.html.erb`를 찾아서 뷰를 렌더링 하게 될 것이다. 자세히 살펴보면 컨트롤러의 이름과 액션의 이름을 가지고 뷰에 관련된 파일을 찾는 것을 살펴볼 수 있다.

RoR의 모든 컨트롤러는 `ApplicationController`를 상속받아 만들어진다. 여기서 RoR이 구조화한 관례를 살펴보면 ApplicationController에서 전체 레이아웃을 정의하고 상속받은 클래스에서 해당하는 뷰를 렌더링하여 조합되어 전체 뷰가 만들어진다. RoR의 뷰를 찾는 구조를 살펴보면 ApplicationController 에 필요한 뷰를 가장 먼저 찾을 것이다. 이것은 기본적으로 `app/views/layout/application.html.erb` 파일이다. 이 파일을 수동으로 변경할 수도 있다. 이것은 나중에 설명한다. 이 파일을 열어서 살펴보자. 그러면 다음과 같이 `<%= yield %>`라는 것을 볼 수 있을 것이다.

```html
<html>
  <head>
  </head>
  <body>
  <%= yield %>
  </body>
</html>
```
이 예약어는 사전적 의미와 동일하게 뷰를 렌더링할 때 해당하는 리소스의 뷰를 렌더링하여 조합을 하게 되어진다. 즉 위에 BooksController에 관련된 요청을하게 되면 `app/views/books/index.html.erb`의 뷰를 렌더링하여 `app/views/layout/application.html.erb` 안의 **yield**에 결합되어 최종적으로 뷰가 만들어지게 되는 것이다.

## ApplicationController 전체 레이아웃 변경

모든 컨트롤러는 ApplicationController를 상속받고 있기 때문에 전체 Layout을 이 컨트롤러에서 지정하게 되면 상속받은 컨트롤러는 이 레이아웃을 참조하여 만들어지게 된다. 기본적으로는 `app/views/layout.html.erb`라는 뷰 파일을 참조하게 되는데 사용자가 특별한 레이아웃을 지정하기 위해서는 다음과 같이 ApplicationController에 정의하여 사용할 수 있다. `app/controllers/application_controller.rb` 파일을 열어서 레이아웃을 지정한다.

```ruby
class ApplicationController < AcitonController::Base
	layout “main”
end
```

이제 모든 컨트롤러의 레이아웃은 `app/views/layout/main.html.erb` 파일을 참조하게 될 것이다.

만약 특정 컨트롤러에서만 특별한 레이아웃을 사용하기 위해서는 상속받은 컨트롤러에서 레이아웃을 정의하면 된다. BooksController를 열어서 다음과 같이 수정하자.

```ruby
class BooksController < ApplicationController
	layout “main”
end
```

이제 BooksController 요청을 처리할 때만 `app/views/layout/main.html.erb`  레이아웃을 사용할 것이고, 나머지는 기본적인 레이아웃인 `app/views/layout/application.html.erb`를 참조하게 될 것이다.

## Browser 를 사용하여 요청 브라우저 분석하기

위에서 우리는 레이아웃의 동작 원리를 간단하게 살펴보았다. 이제 요청이 들어올 때 모든 브라우저에서 요청이 들어온 것이지 아닌지 판단해서 해당하는 요청에 따라 다른 레이아웃을 구성하면 된다. 그러면 요청이 모든 브라우저에서 요청한 것인지 어떻게 판단해야할까? RoR의 요청은 Controller에서 **request** 변수로 요청을 분석할 수 있다. reuqest에서 agent를 확인할 수 있는데 이것을 분석하면 되는 것이다.

```ruby
request.env[“HTTP_USER_AGENT”]
```

또는

```ruby
request.user_agent
```

 하지만 Ruby 프로그램의 강점은 Gem이 있다는 것이다. 이미 만들어진 유용한 라이브러리들을 Gem을 사용하여 사용할 수 있다. [Browser](https://github.com/fnando/browser)라는 라이브러를 사용하면 간단하게 모든 브라우저를 분석할 수 있다. RoR의 `Gemfile`을 열어서 다음과 같이 입력한다.

```ruby
gem 'browser'
```

다음은 bundle installer를 사용하여 설치한다.

```
bundle install
```

만약 bundle installer를 사용하지 않을 경우 직접 gem을 사용하여 설치하면 된다.

```
gem install browser
```

이제 RoR 어디서든지 `browser`를 사용하여 요청을 분석할 수 있다. 만약 뷰 자체에서 모든 브라우저 요청인지 확인하기 위해서는 다음과 같이 사용할 수 있다.

```html
<% if browser.ie?(6) %>
  <p class="disclaimer">You're running an older IE version. Please update it!</p>
<% end %>
```

하지만 위와 같은 사용은 뷰가 렌더링될 때 확인하는 작업이기 때문에 다른 브라우저별로 다른 레이아웃을 구성할 수 없다. 모든 뷰의 레이아웃을 지정하는 ApplicationController에서 브라우저를 분석해서 해당하는 다른 뷰를 참조하도록 해보자.

```ruby
class ApplicationController < ActionController::Base
	layout :render_layout

	private
	def render_layout
		browser.morden? ? “application” : “old”
	end
end
```

이렇게 지정하게 되면 모던 브라우저일 경우에만 `app/views/application.html.erb`를 참조하게 되고 IE8 이하 버전 브라우저는 `app/views/old.html.erb`를 참조하게 될 것이다.

## prepend_view_path를 사용하여 브라우저별 뷰 다루기

위에서 모던 브라우저일 경우 전체 레이아웃을 다르게 참조할 수 있는 것을 살펴보았다. 하지만 ApplicationController를 상속받은 각각의 컨트롤에서 관례적으로 참조하는 뷰는 `<%= yield %>`를 사용하여 참조하기 때문에 실제 뷰의 코드는 함께 사용이 된다. 즉 BookController를 요청해서 참조하는 뷰의 코드는 레이아웃을 제외하고 동일하다는 것이다. 이것은 장점이 될 수도 있지만 해당하는 브라우저별 다른 뷰 코드를 각각 요청하게 할 때는 다른 방법이 필요하다. 우리와 같은 경우는 모던브라우저일 경우는 Material Design Lite를 사용하고 있어서 뷰에 MDL을 사용하기 위한 CSS Class 를 사용하지만 모던 브라우저가 아닐경우에는 우리가 정의한 CSS Class를 사용하도록 하고 싶었다. 그래서 우리는 컨트롤러에서 참조하는 뷰 파일도 따로 제작하고 싶었다.

우리는 이런 디렉토리 구조를 원했다. 일반적으로 모던 브라우저에서 요청을 할 때는 `app/views/layout/application.html.erb`와 `app/views/books/index.html.erb`를 참조하게 하고 모던 브라우저가 아닐 경우는 `app/old-views/layout/application.html.erb`와 `app/old-views/books/index.html.erb`를 사용하도록 하고 싶었다. 그래서 우리는 [prepend_view_path](http://edgeapi.rubyonrails.org/classes/AbstractController/ViewPaths/ClassMethods.html)를 사용하기로 결정했다.

**prepend_view_path**는 쉽게 설명해서 뷰를 참조하는 패스에 특정 경로를 덧붙이는 것이다. 아래 코드를 살펴보자. 우리는 전체적으로 참조하는 ApplicationController에 뷰 패스를 설정하기 전에 요청 브라우저를 분석하여 모던 브라우저가 아닐 경우 뷰 패스를 `app/old_views`에서 시작하도록 변경하였다.

```ruby
class ApplicationController < ActionController::Base
	before_filter :set_view_paths

	private
	def set_view_paths
		prepend_view_path Rails.root.join('app', ‘old_views’) #if browser.ie?
	end
end
```

이렇게 설정하게 되면 모던 브라우저에서 요청이 들어오면 `app/views/layout/application.html.erb`와 `app/views/books/index.html.erb` 파일을 찾을 것이고, 모던 브라우저가 아년 경우는 `app/old_views/layout/application.html.erb`와 `app/old_views/books/index.html.erb`를 찾게 될 것이다.


## 결론

현재 존재하는 HTML5 프레임워크들은 대부분 IE10 이상 브라우저에서 정상적으로 동작한다. 하지만 국내 사용자는 아직 IE9 이상 사용자가 많다. 뿐만 아니라 모던 브라우저가 아닐 경우도 있기 때문에 어디 까지 HTML5 요소를 사용해야할지 경정하는 것이 중요하다. 우리 같은 경우는 아예 모던 브라우저 사용자와 아닌 경우를 분리하였다. 더 정확하게는 IE 사용자와 아닌경우를 분리하였다. 현재 존재하는 HTML5 프레임워크는 IE9에서도 완벽하게 동작하지 않기 때문이다.

우리는 RoR 환경에서 브라우저 요청에 따라서 다른 레이아웃을 구성하는 방법을 찾게 되었다. RoR은 **설정보다는 관례(Convention over Configuration)**와 **DIY(Don’t Repeat Yourself)** 특징을 가지고 있어 레이아웃을 조작하는 것이 매우 구조적이기 때문에 이 특징을 활용하면 편리하게 뷰를 제어할 수 있다. 우리는 모든 컨트롤러가 상속하는 ApplicationController에서 레이아웃을 분리할 뿐만 아니라 뷰 파일을 참조하는 view path 자체를 다르게 하기 위해서 **prepend_view_path**를 사용하였다.

또한 우리는 브라우저의 요청에 따라 어떤 브라우저를 사용하지를 판단하기 위해서 [browser](https://github.com/fnando/browser) gem을 사용하였다.

우리는 처음 반응형웹을 지원하는 최신 HTML5 웹 어플리케이션을 제작하려고 했으나 IE9 이하 브라우저에 최적화된 서비스를 위해서 코드를 분리하기로 결정했다. 하지만 이 방법이 옳다고 말하는 것이 아니다. 모든 것은 서비스 특징에 맞는 최선의 판단을 하게 될 것이다. 각자의 서비스에 맞는 환경을 구축하면 된다. IE9일 경우 polyfill을 사용하여 HTML5 문제를 커버할 수도 있고 다른 방법으로 모던 브라우저 아닌 방법을 해결할 수도 있을 것이다. 이 포스팅은 RoR 환경에서 브라우저별 레이아웃 구성을 어떻게 할 수 있는지에 대한 하나의 방법에 대해서 소개한 것이다.

## 참고

1. http://guides.rubyonrails.org/layouts_and_rendering.html
2. http://flowkater.github.io/blog/2013/08/12/rails-architecture/
3. http://stackoverflow.com/questions/10864108/how-to-prepend-rails-view-paths-in-rails-3-2-actionviewpathset
4. http://railscasts.com/episodes/269-template-inheritance


