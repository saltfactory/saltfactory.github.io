---
layout: post
title: Scaffold로 빠르게 웹 서비스 개발하기
category: ruby
tags: [ruby, scaffold, web]
comments: true
redirect_from: /177/
disqus_identifier : http://blog.saltfactory.net/177
---

## 서론

개발자에게 또는 연구원에게 있어서 개발 방법론이 바뀌게 되는 경우는 아마도 새로운 프레임워크를 접하고 나서가 아닐가 생각한다. 한가지 프레임워크나 한가지 언어(Programming Languages)로만 개발하게 된다면  알고리즘이나 저장구조, 소프트웨어 개발 패턴등 여러가지 언어와 프레임워크를 경험한 것과 상대적으로 개념적으로 경험적으로 부족하게 된다. 나에게 있어서 웹 개발에 대한 놀라운 경험은 RoR(Ruby on Rails), Springframework MVC, Javascript Library(Jquery, Prototype.js 등), NodeJS 등  말할 수 있는데 그중에서 가장 놀랍고 단편적인 웹 개발 사고를 완전히 변화시킨것은 바로 Ruby on Rails 였다. RoR의 장점은 너무마 많아서 이 한 포스팅에 다 담을 수가 없다. 그래서 RoR의 가장 매력적인 기능, RoR로 빠르게 웹 개발을 할 수 있는 Scaffolding 에 대해서 이야기를 나누고자 한다.

<!--more-->

## Scaffolding

scaffolding에 대해서 wikipedia에서는 이렇게 서술하고 있다.

> Scaffolding is a technique supported by some model-view-controller frameworks, in which the programmer may write a specification that describes how the application database may be used. The compiler uses this specification to generate code that the application can use to create, read, update and delete database entries, effectively treating the template as a "scaffold" on which to build a more powerful application.
Scaffolding is an evolution of database code generators from earlier development environments, such as Oracle's CASE Generator, and many other 4GL client-server software development products.
Scaffolding was popularized by the Ruby on Rails framework. It has been adapted to other software frameworks, including Django, Monorail (.Net), Symfony, CodeIgniter, Yii, CakePHP, Model-Glue, Grails, Catalyst, Seam Framework, Spring Roo, ASP.NET Dynamic Data and ASP.NET MVC Framework's Metadata Template Helpers.

scaffolding 개념을 추상화해서 말하자면 건물을 짓기 위한 가장 기본이되는 부분을 건축회사에서 건물을 짓기 위한 가장 기본이 되는 재료와 철조물로 뼈대를 만들고 외부표면을 만들어주어서 건축시공자들이 디테일한 건축물을 완성시킬 수 있게 해주는 기능이다. 어플리케이션 개발관점에서 말하자면 개발자가 MVC 모델을 기반으로  어플리케이션을 만들려고 할 때 생산하는 복잡하고 많은 양의 코드를 어플리케이션이 제공하는 템플릿기반으로 Model, View, Controller 에 관련된 코드를 자동으로 생성해주는 기능이다. scaffoding에 대한 기본 개념을 가지고 RoR에서는 어떻게 scaffoding을 사용하는지 예를 보면서 위에서 언급한 말을 이해해보자.

우리는 간단하게 블로그 웹 서비스를 만들어볼 것이다. scaffold를 사용할 때와 scaffold로 사용하지 않을 때 두가지로 살펴볼 것인데, 우선 테스트를 위해서 Rails 프로젝트를 만든다.
이 포스팅에 사용된 ruby 버전은 1.9.2-p290이고, rails 버전은 3.2.8 이다

![](http://cfile6.uf.tistory.com/image/1476763950417C7419F258)

```
rails new BlogApp
```

우리는 RoR 어플리케이션을 만들때 데이터베이스 타입을 지정하지 않았는데 이럴경우는 기본적으로 SQLite 데이터베이스를 사용한다.

![](http://cfile21.uf.tistory.com/image/167C353750417D21038209)

위 명령어를 실행하면 BlogApp 이라는 Rails 어플리케이션이 만들어진다. 지금부터 scaffold를 사용하지 않고 개발하는 경우와 scaffold를 사용해서 개발하는 방법을 살펴보기로 한다.


## Scaffolding 사용 없이 개발

### Model

RoR을 사용하지 않는 개발자들은 아마도 제일 처음 블로그 웹 서비스를 개발하기위해서 데이어베이스에 접근해서 테이블을 생성할 것이다.
RoR에서 사용하는 디폴트 데이터베이스 경로는 ${RAILE_HOME}/db/development.sqlite3 이다. 이곳에 posts 테이블을 생성해보자.

```
sqlite3 db/development.sqlite3
```
```sql
create table posts (
id integer,
name text,
title text,
content text,
created_at datetime,
updated_at datetime);

.quit
```

테이블이 생성하고 난 뒤에는 posts를 객체로 매핑하고 객체의 관계를 정의하고 사용하기 위해서 Model 객체를 만들것이다. RoR에서는 MVC에 맞는 구조로 디렉토리가 구성되어 있는데 ${RAILS_HOME}/app/models, ${RAILS_HOME}/app/views, ${RAILS_HOME}/app/controllers 로 각각 MVC에 관련된 Ruby 클래스가 저장된다. 데이터베이스에 존재하는 'posst'를 객체와 연결하기 위해서 ${RAILS_HOME}/app/models 디렉토리 밑에 Post.rb를 생성한다.

```ruby
class Post < ActiveRecord::Base
  attr_accessible :content, :name, :title
end
```

![](http://cfile3.uf.tistory.com/image/16619642504185AC2B9155)

모델과 데이터베이스 테이블과 연결이 잘 되었는지 확인해보자. rails console 명령어를 사용하면 rails를 웹 브라우저에서 확인하지 않고 rails의 객체를 확인하고 rails 동작과 유사한 것을 처리할 수 있다.

```
rails console
```
```
post = Post.new
```

![](http://cfile25.uf.tistory.com/image/156B454250418641269C1D)

위의 그림과 같이 Post.new를 생성하면 ActiveRecord를 상속받은 Post 객체가 posts 테이블과 매핑되어 Rails에 메모리에 올라오는 것을 확인할 수 있다.

위의 Model에 관련된 일련의 작업은 매우 hard한 방법이고 Rails에서는 rails 명령어로 Model을 생성할 수 있다.

```
rails generate Post name:string, title:string, content:text
```

![](http://cfile10.uf.tistory.com/image/125F8A465041881329BFA3)

rails genreate model 명령어로 모델을 생성하면 db/migrate/ 디렉토리에 테이블에 관한 마이그레이션 파일이 생성된다.

![](http://cfile22.uf.tistory.com/image/1752CB3A5041886F3A89E3)

그리고 데이터베이스를 마이그레이션하기 위해서 마이그레이션 명령어를 사용한다.

```
rake db:migrate
```

![](http://cfile7.uf.tistory.com/image/111F2244504195D111FB43)

너무나 간단하게 데이터베이스에 테이블도 생기고 객체와 메핑이 되는 모델도 만들어졌다. 위에서 했던 것과 동일하게 rails console로 확인할 수 있다.

### Controller

이젠 컨트롤러를 만들어보자. ${RAILS_HOME}/app/contorllers 디렉토리 안에 posts_controller.rb를 생성한다. 그리고 다음 코드를 추가하자. 코드에 대한 설명은 이후 다른 포스트에서 자세히 하기로 한다. (지금 이 포스팅은 scaffolding에 대해서 이야기하는 포스팅이기 때문이다.) 간단하게 설명하면, 컨트롤러는 URL 요청을 들어올 때 특정 url pattern에 해당되는 메소드와 매핑하여 필요한 Model과 또는 특정 작업을 처리한 이후에 관련된 View를 랜더링시켜서 데이터와 함께 view를 호출하는 곳이다. index 메소드 살펴보면 URL이 /posts 라고 들어올 때 매핑이 되게 되어 있는데 Post.all 로 Post와 매핑되어 있는 posts 테이블의 데이터를 모두 조회해서 @posts 에 저장한 다음 format.html 으로 뷰를 렌더링한다. 또는 format.json으로 @posts 객체를 json으로 serialization을 해서 json뷰로 렌더링한다. 이하 나머지 메소드들도 URL 패턴에 맞게 매핑되어 데이터를 처리하고 해당되는 뷰를 렌덩링하거나 redirect_url로 특정 URL로 리다이렉트를 한다.

```ruby
class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

end
```

### Routes

컨트롤러를 추가했으니 Rails 어플리케이션에서 들어오는 URL 요청을 해당되는 controller와 매핑하는 작업을 해야하는데 이렇게 URL 패턴을 controller로 매핑시켜주는 부분은 ${RAILS_HOME}/config/routes.rb 파일에서 담당한다. 다음과 같이 resources :posts 라고 하면 posts에 관련된 디폴트 URL 패턴과 controller와 매핑시켜준다.

```ruby
BlogApp::Application.routes.draw do
  resources :posts

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
```

라우터를 설정한 이후 콘솔에서 다음과 같이 실행해보자. 그러면 현재 Rails 어플리케이션에서 posts_controller에 해당되는 라이팅 정보가 무엇인지 리스팅할 수 있다.

```
rake routes
```

![](http://cfile2.uf.tistory.com/image/123209365043FA621DB8DD)

이제 컨트롤러에서 처리하고 렌더링한 뷰를 만들어보자 ${RAILS_HOME}/app/views/  디렉토리 밑에 posts 라는 디렉토리를 만들고 posts_controller에서 해당하는 뷰 파일을 controller의 메소드 이름과 매핑하여 생성한다.

filename: index.html.erb

```html
<h1>Listing posts</h1>

<table>
  <tr>
    <th>Name</th>
    <th>Title</th>
    <th>Content</th>
    <th></th>
    <th></th>
    <th></th>
  </tr>

<% @posts.each do |post| %>
  <tr>
    <td><%= post.name %></td>
    <td><%= post.title %></td>
    <td><%= post.content %></td>
    <td><%= link_to 'Show', post %></td>
    <td><%= link_to 'Edit', edit_post_path(post) %></td>
    <td><%= link_to 'Destroy', post, method: :delete, data: { confirm: 'Are you sure?' } %></td>
  </tr>
<% end %>
</table>

<br />

<%= link_to 'New Post', new_post_path %>
```

filename: show.html.erb

```html
<p id="notice"><%= notice %></p>

<p>
  <b>Name:</b>
  <%= @post.name %>
</p>

<p>
  <b>Title:</b>
  <%= @post.title %>
</p>

<p>
  <b>Content:</b>
  <%= @post.content %>
</p>


<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>
```

filename: new.html.erb

```html
<h1>New post</h1>

<%= render 'form' %>

<%= link_to 'Back', posts_path %>
```

filename: edit.html.erb

```
<h1>Editing post</h1>

<%= render 'form' %>

<%= link_to 'Show', @post %> |
<%= link_to 'Back', posts_path %>
```

filename: _form.html.erb

```
<%= form_for(@post) do |f| %>
  <% if @post.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@post.errors.count, "error") %> prohibited this post from being saved:</h2>

      <ul>
      <% @post.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= f.label :name %><br />
    <%= f.text_field :name %>
  </div>
  <div class="field">
    <%= f.label :title %><br />
    <%= f.text_field :title %>
  </div>
  <div class="field">
    <%= f.label :content %><br />
    <%= f.text_area :content %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```

이제 Rails 어플리케이션 서버를 실행시켜보자. ${RAILS_HOME}에서 다음과 같이 서버를 실행시킨다.

```
rails server
```

http://localhost:3000/posts 를 실행해보자.

![](http://cfile22.uf.tistory.com/image/175DAD4850440EF701A925)

http://localhost:3000/posts/new 를 실행해보자.

![](http://cfile3.uf.tistory.com/image/123E284C50440F292879F1)

form에 값을 입력하고 Create Post 버튼을 클릭해보자.

![](http://cfile24.uf.tistory.com/image/174B4B3450440F912D5255)

![](http://cfile9.uf.tistory.com/image/1244014750440FCD277D07)

참고로 Model을 생성할 때 수동으로 파일을 생성하지 않고 rails generate model을 사용하였듯이 컨트롤러를 생성할 때도 rails generate controller로 생성할 수 있다. rails generate controller 명령어로 생성하면 컨트롤러가 생성되면서 해동되는 view 파일이 자동으로 생성이 된다.

```
rails generate controller post index show new create edit update destroy
```

## Scaffolding으로 개발

이렇게 Scaffolding 없이 Rails에서 Model + View + Controller를 수동으로 추가해서 개발하는 방법을 알아보았다. 이렇게 여러번 작업과 복잡한 과정을 scaffolding이라는 것을 이용하면 매우 간단하게 어플리케이션을 만들 수 있다.
다른 디렉토리에서 새로운 Rails 어플리케이션을 만들어보자.

```
rails new BlogApp
```

${RAILS_HOME} 으로 이동해서 이제 scaffolding으로 Model View Controller를 생성해보자.


```
rails generate scaffold Post name:string title:string content:text
```

위 rails generate scaffold 라는 명령으로 Post에 관한 Model, View, Controller를 생성할 수 있는 것을 확인할 수 있다. 앞에서 복잡하고 길었던 작업을 scaffolding으로 한번에 Model, View, Controller를 생성하는 것을 확인할 수 있다.

![](http://cfile30.uf.tistory.com/image/17799944504412360E818B)

scaffold는 Model을 생성하면서 데이터베이스의 migration 파일 까지 생성해준다. 그래서 바로 데이터베이스를 마이그레이션 할 수 있다.

```
rake db:migrate
```

이제 Rails 어플레케이션 서버를 실행해서 http://localhost:3000/posts 를 확인한다.

![](http://cfile7.uf.tistory.com/image/117A7B415044131D0D528F)

![](http://cfile1.uf.tistory.com/image/2032EB395044133609FB02)

scaffolding으로 작업했던 CRUD 뷰, 컨틀롤러, 모델 그리고 데이터베이스가 잘 동작하는 것을 확인할 수 있을 것이다.

## 결론

Framework 라는 것 자체가 많은 개발자, 아키텍처, 데이터베이스 관계자, 테스터 들이 모여서 오랜 시간 알고리즘과 구조체, 방법론과 디버깅 등을 수없이 반복하면서 개발과 운영에 필요한 복잡한 것들은 추상화시키고 구조화시킨 것이다. 이런 의미로 개발자가 자신이 직접 MVC 방법론을 정의해서 그에 맞는 개발 패턴으로 코드를 생성하기가 여간 어렵고 복잡한 과정이 아닐 수 없다. RoR 뿐만 아니라 Springframework MVC, Django, CakePHP 등 MVC 패턴으로 어플리케이션을 개발할 수 있는 오픈소스 프레임워크가 많기 때문에 개발자들이 이러한 프레임워크를 잘 이해하고 활용하면 개발 공수 기간과 유지보수 기간의 비용을 줄일 수 있을 것으로 예상이된다. 뿐만아니라 scaffoding 이라는 것을 지원하는 프레임워크라면 개발자가 단순한 CRUD 서비스 프로세스를 구축하기 위한 많은 코드와 설정들을 하는 시간을 단축 시켜줄 것으로 예상이 된다. 여러분이 사용하는 프레임워크에 scaffolding 개념이 있는지 또는 유사한 기능이 있는지 다시한번 확인해보고 개발을 편리하게 해보는것은 어떨지 권유하고 싶다.

## 참고

1. http://guides.rubyonrails.org/getting_started.html

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
