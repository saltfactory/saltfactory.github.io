---
layout: post
title : Ruby on Rails 에서 Ajax와 Partial을 사용하여 페이지 전환없이 뷰 업데이트하기
category : ruby
tags : [ruby, rails, ajax, jquery, partial, ror]
comments : true
images :
  title : http://assets.hibrainapps.net/images/rest/data/744?size=full
---

## 서론
Ruby on Rails는 개발자에게 빠르게 웹을 개발할 수 있게 설계되어져 있다. Ruby on Rails는 가장 인기있는 JavaScript 프레임워인 jQuery를 기본적으로 가지고 있고, 이것을 사용하여 Ajax 서비스를 쉽게 설계하고 빠르게 개발할 수 있다. 또한 RoR은 뷰를 필요한 조각으로 분리하여 개발할 수 있는 [partial](http://guides.rubyonrails.org/layouts_and_rendering.html) 이라는 개념을 가지고 있기 때문에 복잡한 뷰를 재활용 가능하게 간단하게 분리해서 만들 수 있다. 이 포스팅에서는 RoR의 Ajax 기능과 partial을 사용하여 페이지 전환없이 뷰를 업데이트하는 방법을 소개한다.

## 테스트를 위한 프로젝트 생성

우선 테스트를 위해서 TestApp 이라는 이름으로 프로젝트를 생성하자.

```
rails new TestApp
```

## 테스트를 위한 Post scaffold 생성

Ruby on Rails에서는 [scaffold](https://en.wikipedia.org/wiki/Scaffold_(programming))라는 것을 사용하여 빠르고 간단하게 Model-View-Control 기반의 구조화된 서비스 기본 골격을 만들 수 있다. Rails의 Scaffold 명령어에 대해서는 http://guides.rubyonrails.org/command_line.html 문서에서 소개하고 있다.

우리는 테스트를 위해 글을 작성하기 위한 Posts를 scaffold로 생성해보자.

```
rails g scaffold Post title:string content:text
```

이 명령어를 실행하면 Post에 관련된 Mode, View, Controller 에 필요한 파일들이 자동으로 생성이 된다.

![](http://assets.hibrainapps.net/images/rest/data/725?size=full&m=1445935714)

scaffold로 생성된 파일중에 Model 에 관련된 파일로 데이터베이스에 관련된 파일이 생성이된다. RoR의 장점중인 하나인 애자일 개발에 적합한 구조로 언제든지 데이터베이스 정보를 마이그레이션할 수 있다. 모델의 추가로 데이터베이스에 필요한 테이블을 생성을 하기 위해서 다음 명령어로 데이터베이스를 마이그레이션한다.

```
rake db:migrate
```

이 명령어를 실행하면 **Post**라는 Model이 추가되면서 필요한 **posts** 테이블을 데이터베이스에 create 시키는 것을 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/726?size=full&m=1445935976)

이제 Post를 작성하기 위한 최소한의 필요한 파일들을 모두 만들었다. scaffold로 작업하는 것은 이렇게 간단하다. Rails 서버를 실행해보자.

```
rails s
```

서버를 실행한 후 scaffold로 만든 Post 컨트롤러에 접근해보자.

http://localhost:3000/posts

![](http://assets.hibrainapps.net/images/rest/data/728?size=full&m=1445936144)

특별한 코드를 작성한 것도 아닌데 이미 목록, 글쓰기, 수정, 삭제에 관한 기본적인 골격이 만들어졌다. **New Post** 링크를 클릭해보자. 링크는 다음과 같이 바뀌고 글을 입력하는 화면이 나타날 것이다.

http://localhost:3000/posts/new

![](http://assets.hibrainapps.net/images/rest/data/729?size=full&m=1445936246)

우리는 scaffold를 만들 때 간단하게 **title**과 **content** 만 정의했기 때문에 이렇게 제목과 내용을 넣는 입력 폼이 만들어져있다. 필요한 항목을 입력하고 **Create Post** 버튼을 클릭해보자. 글이 데이터베이스에 정장적으로 저장이 된 이후 다음과 같이 URL이 변경되고 저장된 값을 보여주는 화면이 나타날 것이다.

http://localhost:3000/posts/1

![](http://assets.hibrainapps.net/images/rest/data/730?size=full&m=1445936399)

Scaffold로 골격을 만들면 기본적으로 [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) 를 할 수 있는 데이터베이스 구조와 REST 구조가 만들어진다. 다른 테스트들은 생략한다.

## Routes 와 Controller

Rails에서 가장 중요한 개념 중에 하나가 바로 라우팅이다. 이것은 서버에 요청이 들어오면 어떤 컨트롤러에서 요청을 처리할지 결정하는 규칙을 지정한다. 다시말해 Controller를 새롭게 추가할 때 반드시 라우팅 설정을 해줘야한다.

앞에서 우리는 scaffold로 Post에 관련된 컨트롤러를 자동으로 만들었는데 이 때 Rails의 generator가 라우팅 파일에 컨트롤러를 등록한다. Rails에서 라우팅을 설정하는 파일은 **config/routes.rb** 파일이다. 이 파일을 열어보자.

![](http://assets.hibrainapps.net/images/rest/data/731?size=full&m=1445936826)

파일을 살펴보면 **resources** 라는 예약어에 **:posts**라고 정의한 것이 보인다. 이것은 posts에 관련된 REST resource들을 자동으로 **PostsController**에 매핑해서 해당된 액션을 처리하도록하는 Rails의 관용적인 표현이다. 그럼 해당하는 컨트롤러를 살펴보자. **PostsController**는 **app/controlers/posts_controller.rb**로 만들어진다. 파일을 열어보면 Scaffold가 자동으로 컨트롤러를 추가하면서 REST 서비스에 필요한 메소드를 생성한 것을 확인할 수 있다.

```ruby
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
```

RoR에서 이렇게 쉽고 체계적인 구조로 REST 서비스를 구현할 수 있다. 컨트롤러를 자세히 살펴보면 GET, POST, PATCH, DELETE에 관련된 메소드를 확인할 수 있다.

우린 이런 구조를 바탕으로 Post에 댓글을 달기 위한 Comment 모델과 컨트롤러를 추가할 것인데, 페이지 전환없이 보고 있는 Post에 해당하는 댓글을 추가하거나 삭제하기 위해서 Ajax를 사용할 것이다. Ruby on Rails에서 Ajax를 어떻게 쉽고 체계적으로 사용할 수 있는지 살펴보자.

## 테스트를 위한 Comment 모델 추가

우리는 댓글을 위한 Model을 추가할 것인데 Post는 여러개의 댓글을 가지고 있는 관계를 함께 정의할 것이다. 다음 명령어로 모델을 추가한다.

```
rails g model Comment content:text post:references
```

여기서 한가지 살펴볼 것은 Comment 모델을 생성할 때 Post를 **references**로 정의했다는 것이다. 이 의미는 Comment가 Post 객체와 연관관계가 있다는 것을 정의하는 것이다.

![](http://assets.hibrainapps.net/images/rest/data/732?size=full&m=1445937718)

이 명령어를 실행하면 Comment 모델이 **app/models/comment.rb** 파일로 생성이 된다. 파일을 열어보면 Comment 모델이 Post 모델과의 관계를 [belongs_to](http://guides.rubyonrails.org/association_basics.html)로 정의된 것을 확인할 수 있다.

```ruby
class Comment < ActiveRecord::Base
  belongs_to :post
end
```

하나의 Post는 여러개의 Comment를 가질 수 있다. Post 모델 파일인 **app/models/post.rb** 파일을 열어서 이 관계를 다음과 같이 정의한다.

```ruby
class Post < ActiveRecord::Base
  has_many :comments
end
```

Comment 모델을 추가하면서 생성한 데이터베이스 마이그레이션 파일을 살펴보자.  이 파일을 살펴보면 **comments** 라는 테이블을 생성할 때 post의 관계를 표현하기 위해서 [외래키 제약 조건](https://en.wikipedia.org/wiki/Foreign_key)이 함께 추가되는 것을 확인할 수 있다.

```ruby
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :post, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
```

모델을 새롭게 추가했으니 데이터베이스를 마이그레이션 한다.

```
rake db:migrate
```
이 명령어를 실행하면 Comment를 저장하기 위한 comments 테이블이 생성된다.

![](http://assets.hibrainapps.net/images/rest/data/733?size=full&m=1445938171)

## Comments 목록 출력을 위한  View 수정

우리는 댓글 서비스를 Ajax로 만들고 싶어한다. 어떤 한 Post의 글을 보면 하단에 Comments 들이 나열되고 입력하는 화면이 필요하다. 먼저 Post가 보여질 때 하단에 Comments 목록이 보여지도록 **app/views/posts/show.html.erb** 파일을 수정한다.

```html
<p id="notice"><%= notice %></p>

<p>
  <strong>Title:</strong>
  <%= @post.title %>
</p>

<p>
  <strong>Content:</strong>
  <%= @post.content %>
</p>

<p>
	<h3>Comments</h3>
	<ul id="comments">
		<% @post.comments.each do |comment| %>
		<li><%= comment.content %></li>
		<% end %>
	</ul>		
</p>

<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>

```
수정된 뷰를 브라우저에서 확인하자

![](http://assets.hibrainapps.net/images/rest/data/736?size=full&m=1446008340	)

## Comments 요청을 처리할 Controller 추가

다음은 Ajax 입력 폼을 만들 것이다. 댓글 입력폼을 만들기전에 댓글 입력폼에서 글을 저장하면 Comment 모델을 가지고 데이터베이스에 저장하는 요청을 처리하는 Controller를 만들어야한다. 다음과 같이 Comments 요청을 처리하는 컨트롤러를 만든다.

```
rails g controller Comments
```

![](http://assets.hibrainapps.net/images/rest/data/734?size=full&m=1446005226)

Rails에서 Controller를 추가하면 이 컨트롤러가 처리하는 요청을 정의하기 위해 routing 설정을 해야한다. **config/routes.rb** 파일을 열어서 다음과 같이 라우팅 정보를 추가한다. 우리가 만드는 예제는 Post가 여러개의 Comments를 가지고 있는 관계 구조를 가지고 있으면서도 직접적으로 요청을 할 수 있기 때문에 다음과 같이 정의한다.

```ruby
Rails.application.routes.draw do
  resources :posts do
    resources :comments
  end

  resources :comments
end
```


**CommentsController**는 두가지 요청을 처리하게 될 것인데 데이터를 저장하게 될 **create**와 삭제하게 될 **destory** 이다.  먼저 **create**를 **app/controllers/comments_controller.rb** 파일에 추가한다.

```ruby
class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)

    if @comment.save
      respond_to do |format|
        format.js
      end
    else

    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
```

Comments 컨트롤러를 생성하고 Comment를 저장하기 위한 create 메소드를 추가했다. create 메소드의 내용은 요청에서 들어오는 URL 파라미터 변수에서 **:post_id**를 획득하여 **Post**를 조회하고 그 모델이 가지는 **Comments**의 관계를 연결하여 이것을 저장한다. 그리고 우리는 Ajax를 사용하기 때문에 컨트롤러가 뷰를 응답할 때, JavaScript로 응답하도록 한다. 이 때 **format.js**로 지정한 뷰의 응답은 **create** 메소드의 이름과 동일한 JavaScript 파일로 **app/views/comments/create.js.erb** 라는 이름의 파일과 매핑된다. 이 파일을 다음과 같은 내용으로 생성한다. 이것은 Comment를 저장한 이후 입력폼을 비우고, Comments 목록을 출력하는 DOM에 저장한 Comment 내용을 추가하는 코드이다.

```javascript
(function($){
	$("#comment_content").val("")
	$("#comments").append("<li><%= @comment.content %></li>");
})(jQuery)
```

다시 Post를 보는 화면에서 새로운 Comments를 입력하기 위한 코드를 추가한다. **app/views/posts/show.html.erb** 파일을 열어서 다음과 같이 수정한다.

```html
<p id="notice"><%= notice %></p>

<p>
  <strong>Title:</strong>
  <%= @post.title %>
</p>

<p>
  <strong>Content:</strong>
  <%= @post.content %>
</p>

<p>
	<h3>Comments</h3>
	<ul id="comments">
		<% @post.comments.each do |comment| %>
		<li><%= comment.content %></li>
		<% end %>
	</ul>		
</p>

<p>
		<%= form_for [@post, @post.comments.new], remote: true do |f| %>
			<%= f.text_area :content %>
			<%= f.submit %>
		<% end %>
</p>

<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>
```

![](http://assets.hibrainapps.net/images/rest/data/736?size=full&m=1446008340)

이제 Comment를 Ajax로 저장하기 위한 코드를 모두 작성하였다. 브라우저에서 Comments 입력 폼에 글을 작성하고 저장을 해보자. 다음과 같이 Inspector로 확인해보면 Comment 저장 요청을 Ajax(XHR)로 요청을 하였고 저장 후 응답을 JavaScript로 돌려주는 것을 확인할 수 있다. 또한 비어 있던 Comments 목록에 새로운 댓글이 페이지 변환없이 추가가 된 것을 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/739?size=full&m=1446009498)

## 복잡한 뷰를 Partial을 사용하여 구조화하기

Rails에서 Partial은 뷰 레이아웃을 렌더링할 때 복잡하거나 반복적인 뷰를 분리하여 단순화 시키고 재활용하기 위해서 사용된다. 위에서 create.js.rb의 코드 내용중에 뷰를 업데이트하기 위한 코드를 살펴보면 다음과 같다.

```javascript
$("#comments").append("<li><%= @comment.content %></li>");
```
jQuery에서 `$().append(html)` 코드는 html 코드를 선택한 엘리먼트에 append 시키는 코드이다. 예제에서는 html 코드가 단순하기 때문에 간단하게 추가하였지만 복잡한 뷰를 append 할 때는 JavaScript로 코드를 모두 작성하지 않고 html을 재활용하면 된다.

앞의 코드 중에서 Comments의 목록을 나타내는 코드를 다음과 같이 업데이트한다.

먼저 Comments 목록을 출력하는 부분에 partial로 분리할 뷰를 다음 내용으로 **app/views/comments/_item.html.erb** 파일로  만든다.

```html
<li><%= comment.content %></li>
```

다음은 partial 뷰를 재활용하기 위해서 **app/view/posts/show.html.erb** 안에서 comments를 출력하는 부분에 다음과 같이 변경한다.

```html
<p id="notice"><%= notice %></p>

<p>
  <strong>Title:</strong>
  <%= @post.title %>
</p>

<p>
  <strong>Content:</strong>
  <%= @post.content %>
</p>

<p>
	<h3>Comments</h3>
	<ul id="comments">
		<% @post.comments.each do |comment| %>		
		<!-- <li><%= comment.content %></li> -->
			<%= render partial: "comments/item", locals: { comment: comment } %>
		<% end %>
	</ul>		
</p>

<p>
		<%= form_for [@post, @post.comments.new], remote: true do |f| %>
			<%= f.text_area :content %>
			<%= f.submit %>
		<% end %>
</p>

<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>
```

마지막으로 Comments를 Ajax로 저장 후 응답 결과로 사용되는 **app/views/comments/create.js.erb** 파일에 partial 뷰를 사용하도록 코드를 다음과 같이 수정한다.

```javascript
(function($){
	$("#comment_content").val("")
	// $("#comments").append("<li><%= @comment.content %></li>");
	var html = "<%= escape_javascript(render(partial: 'comments/item', locals: {comment: @comment})) %>";
	$("#comments").append(html);
})(jQuery)
```

partial 뷰를 만들고 관련된 뷰 파일을 보두 수정하고난 이후 Comments 요청을 해보면 다음과 같이 partial을 사용하기 전의 결과와 동일하게 html을 재활용하여 Ajax를 사용하여 저장되고 결과가 나타는 것을 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/740?size=full&m=1446010932)

## Ajax를 사용한 Comment 삭제

마지막으로 Ajax를 사용하여 삭제를 할 경우를 살펴보자. 우선 삭제 요청을 처리하는 메소드를 CommentsController에 다음과 같이 추가한다. 삭제를 요청한 Comment의 id를 가지고 삭제후 저장 후와 동일하게 JavaScript 응답을 돌려준다.

```ruby
class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)

    if @comment.save
      respond_to do |format|
        format.js
      end
    else

    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
```
저장을 담당한 create 메소드의 응답결과가 create.js.erb와 동일하게 destroy의 응답결과는 destroy.js.erb 와 매핑된다. **app/views/comments/destroy.js.erb** 파일을 다음과 같이 생성한다. 해당하는 comment의 id를 가지고 DOM에서 해당 comment를 제거하기 위한 코드이다.

```javascript
(function($){
	$("#comment-<%= @comment.id %>").remove();
})(jQuery)
```

Comments가 출력되는 Partial 뷰에 하나하나 삭제할 수 있도록 다음과 같이 코드를 추가한다. Ajax로 comment를 삭제한 요청이 완료된 이후 **destory.js.erb**에서 해당하는 DOM에서 comment를 제거하기 쉽게 하기 위해서 DOM에 ` id="comment-<%=comment.id%>”`로 유일한 id를 지정하였다. 그리고 Rails의 [link_to](http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to)를 사용하여 삭제를 하는 링크를 추가하였는데 **:remote** 값을 true로 하여 ajax 요청으로 삭제할 수 있도록했다. 이 때 **:confirm**은 삭제를 진행할 때 다이얼로그 메세지로 나타나게 된다.

```html
<li id="comment-<%=comment.id%>">
	<%= comment.content %>
	<%= link_to "삭제", comment_path(comment),
	                    method: :delete,
	                    remote: true,
	                    data: {confirm: "정말로 삭제하시겠습니까?"} %>
</li>
```

뷰를 확인해보자.

![](http://assets.hibrainapps.net/images/rest/data/741?size=full&m=1446012320)

삭제 링크를 눌러 Comment가 Ajax로 삭제되는지 확인해보자. 삭제 링크를 누르면 우리가 정의한 다이얼로그가 나타난다.

![](http://assets.hibrainapps.net/images/rest/data/742?size=full&m=1446012383)

다이얼로그에서 확인 버튼을 클리하면 다음과 같이 Ajax로 삭제를 요청하고 처리한 결과로 destroy.js.erb가 해당하는 Comment의 DOM을 제거하게 되어 뷰를 업데이트한다.

![](http://assets.hibrainapps.net/images/rest/data/743?size=full&m=1446012459)

## 결론

Rails를 사용하면 안정적으로 Ajax 요청 처리와 뷰 업데이트를 만들어낼 수 있다. Rails는 jQuery를 기본적으로 포함하고 있어 jQuery의 Ajax 메카니즘을 사용할 수 있을 뿐만 아니라 Rails의 ViewAction에서 jQuery와 연동하여 사용할 수 있는 **:remote**와 같은 코드를 제공하고 있기 때문에 jQuery Ajax 코드를 사용하지 않고도 Ajax Form이나 Ajax 요청을 쉽게 구현할 수 있다. 뿐만아니라 Rails의 Partial 기능을 함께 사용하면 JavaScript에서 HTML 코드를 만들어내기 위해서 복잡한 코드를 String으로 붙여서 만들지 않고도 Partial 뷰로 재활용 가능한 HTML 파일을 그대로 Ajax의 결과 HTML으로 재활용할 수 있다.  Rails의 기본 철학인 DRY를 생각하면 복잡한 코드를 재활용 가능한 코드로 분리하여 단순화 할 수 있게 된다.

## 참고

1. http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
2. http://guides.rubyonrails.org/layouts_and_rendering.html
3. https://gemfile.wordpress.com/2014/03/06/rails-blog-comments-with-ajax/


## 연구원 소개

- 작성자 : [송성광](http://saltfactory.net/profile) 개발 연구원
- 프로필 : http://saltfactory.net/profile
- 블로그 : http://blog.saltfactory.net
- 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
- 트위터 : [@saltfactory](https://twitter.com/saltfactory)
- 페이스북 : https://facebook.com/salthub
- 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
- 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
