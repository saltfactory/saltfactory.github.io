---
layout: post
title: tumblr.js를 이용하여 소셜 블로그 텀블러(tumblr) API 사용하기
category: javascript
tags: [javascript, tumblr, api]
comments: true
redirect_from: /241/
disqus_identifier : http://blog.saltfactory.net/241
---

## 서론

소셜블로그의 대명사 [Tumblr](http://tumblr.com)는 미려한 디자인과 막강한 블로깅 기능 뿐만 아니라 reblog, sharing 기능이 매우 강력해서 국외 개발자나 미디어 생산자 또는 일반 사용자들이 즐겨 사용하는 블로그이다. 현재 [Tistory](http://tistory.com) 기반으로 블로깅을 하고 있는데 이것을 Tumblr로 이전할까 생각을 여러번 한다. 수 많은 블로그 서비스가 현재 존재하지만 티스토리 블로그를 선택한 이유는 다음과 같다.

- **안정성** : 개인 서버를 사용해서 블로깅을 하면 여러가지 이유로 다운타임이 잦아지기 때문에 다운 타임 없이 운용되는 블로그 호스팅 서비스를 찾았다
- **스킨의 자유성** : 정해전 템플릿만 사용하는 블로그는 사용에 제한이 많다. 실제 네이버와 다음과 같은 포털 블로그는 스킨을 자유롭게 편집할 수 없기 때문에 제한된 컨텐츠 생산만 할 수 있다. 예를 들어, 외부 JavaScript나 CSS를 사용할 수 없기 때문에 정적인 블로깅만 생산해 낼 수 있다. 외부 JavaScript나 CSS를 사용할 수 있는 강점을 티스토리와 텀블러는 가지고 있다.
- **API 지원** : 티스토리는 meta blog와 API를 지원하고 있다.
- **용량제한** : 블로그 호스팅 서비스들은 대부분 파일 용량을 제한하고 있었다. 블로그에 이미지 업로드를 많이 하는 편인데 제한된 용량을 가지고 지속적인 블로깅을 하기는 쉽지 않다고 생각해서 티스토리를 선택했다

티스토리를 선택한 이유는 위와 같은데 대부분을 tumblr가 만족시켜주고 있고 티스토리에서는 없는 reblog 기능 있고 텀블러는 멀티블로그 기능이 tumblr가 더 강력하다. 또한 소셜 플러그인들이 내장되어 있고 API 지원이 강력해서 써드파티 서비스를 만들어낼 수 있기 때문에 현재 tumblr로 블로그를 이전할까 여러차례 고민하고 있다. 그럼 어떻게 Tistory의 글을 Tumblr로 이전할 수 있을까 고민하게 되었는데 방법은 tumblr API를 사용해서 bulk import를 하기로 결정했다. 그래서 tumblr API를 사용하는 방법을 테스트해보기로 했다.

현재 우리 연구소에서 메인 언어는 Java 이지만 모바일 서비스를 연구하고 개발하는데는 Node.js를 사용하고 있기 때문에 JavaScript 기반으로 만들고 싶어서 Tumblr가 공식적으로 지원하는 [tumblr.js](https://github.com/tumblr/tumblr.js/) 라이브러리를 사용해서 tumblr API를 사용하는 방법을 소개하려고 한다.

<!--more-->

## tumblr.js에 필요한 모듈

tumblr.js를 사용하기 위해서는 다음과 같은 Node.js 모듈이 필요하다.

- **[passport](http://passportjs.org/)** : Node.js의 소셜 인증 모듈로 OAuth 인증을 간편하게 구현할 수 있다.
- **[passport-tumblr](https://github.com/jaredhanson/passport-tumblr)** : passport의 인증 모듈의 tumblr 인증 미들웨어로 tumblr의 access token과 access secret 값을 받을 수 있다.
- **[express](http://expressjs.com/)** : OAuth 인증은 서버가 필요하기 때문에 인증처리 후 redirect되는  URL을 처리하기 위한 서버로 express를 사용한다.
- **[tumblr.js](https://github.com/tumblr/tumblr.js/)** : tumblr API 를 사용하기 위한 클라이언트 라이브러리로 tumblr에서 공식 지원하는 Node.js의 모듈이다.

## Tumblr 앱 등록

이 포스팅은 Node.js 기반으로 각자 컴퓨터에 Node.js가 설치 되어 있다고 가정하고 진행한다.
첫번째 tumblr API를 사용하기 위해서는 **tumblr 개발자 사이트**에 들어가서 앱을 하나 등록해야한다. https://www.tumblr.com/oauth/register

필요한 항목을 입력한다. 반드시 입력해야하는 값은 다음과 같다.

- **Application Name** : TumblrAPIDemo
- **Administrative contact email** : saltfactory@gmail.com
- **Default callback URL** : http://127.0.0.1:3000/auth/tumblr/callback

![register application](http://asset.hibrainapps.net/saltfactory/images/0070b133-5531-4c2a-8a87-9b49891e069a)

앱 등록이 모두 마치면 다음과 같이 **OAuth consumer key**와 **OAuth consumer secret**을 획득할 수 있다. 데모로 등록한 앱은 포스팅을 마치면 삭제할 것이기 때문에 여러분이 생성한 앱의 consumer key와 consumer secret을 사용하면 된다.

![registered application](http://asset.hibrainapps.net/saltfactory/images/e44ba7b4-4c6d-4a0f-989f-8491ea167d29)

## package.json

이제 생성된 consumer key와 consumer secret을 사용해서 auth token와 auth secret을 획득하기 위해서 Node.js를 이용해서 프로그램을 작성할 것이다. 먼저 필요한 Node.js의 모듈을 설치하자. 필요한 Node.js의 모듈을 한번에 설치할 수 있는 package.json의 내용은 다음과 같다.

```json
{
  "name": "tumblrAPIDemo",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "start": "node ./bin/www"
  },
  "dependencies": {
    "express": "~4.2.0",
    "static-favicon": "~1.0.0",
    "morgan": "~1.0.0",
    "cookie-parser": "~1.0.1",
    "body-parser": "~1.0.0",
    "debug": "~0.7.4",
    "jade": "~1.3.0",
    "passport": "~0.2.0",
    "passport-tumblr": "~0.1.2",
    "express-session": "~1.2.1",
    "tumblr.js": "~0.0.4"
  }
}
```

우리는 Node.js 개발을 위해서 WinStorm을 사용하고 있지만 특별히 IDE를 사용해야할 필요는 없다. 다만, 개발 생산성을 높이기 위해서 우리는 WinStorm을 사용해서 Node.js 프로젝트를 생성해서 연구를 진행하고 있다. 만약에 WinStorm을 사용하지 않을 경우는 디렉토리를 생성해서 package.json을 이용해서 Node.js 모듈을 설치하고 진행하면 된다.

이 포스팅에서는 WinStorm이 없다고 가정하고 함께 진행하도록 하겠다. 우선 프로젝트 디렉토리를 다음과 같이 생성한다.

```
mkdir tumblrAPIDemo
```

디렉토리 안으로 이동후 위 package.json을 입력해서 파일을 저장한다.

```
vi package.json
```

다음은 npm으로 package.json에 명시된 Node.js 모듈을 설치한다.

```
npm install
```

## express 서버 구현

설치가 모두 마쳤다면 express 서버를 생성하기 위해서 `app.js` 파일을 생성하고 다음 내용을 저장한다.

```javascript
// filename : app.js
var debug = require('debug')('tumblrApiDemo');

var express = require('express');
var path = require('path');
var favicon = require('static-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var session = require('express-session');


var passport = require('passport');
var TumblrStrategy = require('passport-tumblr').Strategy;

var app = express();

var TUMBLR_CONSUMER_KEY = "앱 생성 후 획득한 consumer key";
var TUMBLR_SECRET_KEY = "앱 생성 후 획득한 secret key";

passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(obj, done) {
  done(null, obj);
});


passport.use(new TumblrStrategy({
      consumerKey: TUMBLR_CONSUMER_KEY,
      consumerSecret: TUMBLR_SECRET_KEY,
      callbackURL: "http://127.0.0.1:3000/auth/tumblr/callback"
    },
    function(token, tokenSecret, profile, done) {
      console.log("token:" + token); // 인증 이후 auth token을 출력할 것이다.
      console.log("token secret:" + tokenSecret); // 인증 이후 auto token secret을 출력할 것이다.
      process.nextTick(function () {
        return done(null, profile);
      });
    }
));



// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(favicon());
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(session({ secret: 'keyboard cat' }))
app.use(passport.initialize());
app.use(passport.session())

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

app.get('/', function(req, res){
  res.render('index', { user: req.user });
});

app.get('/account', ensureAuthenticated, function(req, res){
  res.render('account', { user: req.user });
});

app.get('/login', function(req, res){
  res.render('login', { user: req.user });
});


app.get('/auth/tumblr',
    passport.authenticate('tumblr'),
    function(req, res){
      // The request will be redirected to Tumblr for authentication, so this
      // function will not be called.
    });


app.get('/auth/tumblr/callback',
    passport.authenticate('tumblr', { failureRedirect: '/login' }),
    function(req, res) {
      res.redirect('/');
    });

app.get('/logout', function(req, res){
  req.logout();
  res.redirect('/');
});

function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  res.redirect('/login')
}


app.set('port', process.env.PORT || 3000);

var server = app.listen(app.get('port'), function() {
  debug('Express server listening on port ' + server.address().port);
});

```

다음은 express 서버의 뷰를 만들어 줘야하는데 WinStorm에서 Node.js로 express 프로젝트를 생성하면 기본적으로 Jade 뷰 템플릿을 사용하기 때문에 [Jade](http://jade-lang.com/)를 사용했다. 프로젝틀 디렉토리 밑에 views 디렉토리를 만든다.

```
mkdir views
```

필요한 뷰 파일은 `layout.jade`, `index.jade`, `login.jade`, `account.jade` 이고 각각 뷰 파일은 다음과 같다.

```javascript
// filename: layout.jade

doctype html
html
  head
    title TumblrAPIDemo
    link(rel='stylesheet', href='/stylesheets/style.css')
  body
    if !user
      p
        a(href='/') Home
        | |
        a(href='/login') Log in
    else
      p
        a(href='/') Home
        | |
        a(href='/account') Account
        | |
        a(href='/logout') Logout


    block content
```

```javascript
// filename : index.jade

extends layout

block content
    if (!user)
        h2 Welcome! Please Login.
    else
        h2 Hello #{user.username}
```

```javascript
// filename : login.jade

extends layout
block content
    a(href='/auth/tumblr') Login with Tumblr
```

```javascript
// filename : account.jade

extends layout
block content
    p Username: #{user.username}
```

마지막으로 `public/stylesheets/style.css` 파일을 추가해서 스타일을 적용하자.

```css
/*filename : style.css*/

body {
  padding: 50px;
  font: 14px "Lucida Grande", Helvetica, Arial, sans-serif;
}

a {
  color: #00B7FF;
}
```


## tumblr API 인증

인증에 필요한 파일은 모두 추가가 완료되었다. 이제 express를 실행해보자.

```
node app.js
```

express 서버가 동작할 것이고 브라우저를 열어서 http://127.0.0.1:3000 으로 접근해보자.

![start express](http://asset.hibrainapps.net/saltfactory/images/eda617b8-9e26-471e-94ce-85120eef3c4d)

express가 정상적으로 동작하는 것을 확인할 수 있다. Login을 눌러서 tumblr로 로그인을 한다. Login with Tumblr를 클릭하면 tumblr의 앱이 엑세스를 허락을 요구하는 화면이 나타난다 Allow를 선택해서 access 를 허용한다.

![login {width:320px;}](http://asset.hibrainapps.net/saltfactory/images/dbdf0076-0144-4f7f-aff0-4ea7298e4ac4)
![tumblr permission {width:320px;}](http://asset.hibrainapps.net/saltfactory/images/72dd1185-9a1e-4738-b2ee-45a5b262adde)

앱의 엑세스를 허용한 이후 tumblr는 우리가 명시한 redirect URL로 다시 보내게 되는데 이때 우리가 생성한 앱(tubmlrAPIDemo)이 tumblr의 프로필을 가지고 와서 메인 블로그의 이름을 화면에 나타나게 한다. 그리고 세션이 유지되어   logout 메뉴가 보이는 것을 확인할 수 있다.
![redirect](http://asset.hibrainapps.net/saltfactory/images/6fa23842-8458-4968-aadc-b5505bdd7545)

## Access Token 획득

우리는 웹에서 인증을 완료했지만 우리가 원하는 것은 Node.js 로 tumblr.js 모듈을 사용해서 클라이언트에서 tumblr에 접근을 하고 싶어한다. 그래서 우리는 app.js에서 console.log(token)과 console.log(tokenSecret)을 출력하여 auth token key과 auth token secret key를 사용하여야 한다. express를 실행시킨 터미널로 가보자.

![get access token](http://asset.hibrainapps.net/saltfactory/images/3a13a174-3493-4509-8c92-425bb779348c)

터미널에서는 우리가 passport-tumblr 모듈에서 인증처리 후 받은 token과 token secret을 출력시켰기 때문에 그 값이 console.log로 출력된 것을 확인할 수 있다.

이젠 우리는 tumblr API를 사용할 수 있는 인증처리를 모두 마쳤다.

## Tumblr API 사용

tumblr.js를 이용하여 Node.js로 tumblr 데이터를 가져오는 코드를 작성해보자. 파일을 `bin/tumblrClient.js`로 생성하여 다음 코드를 저장한다. client를 만들기 위해서는 우리가 앱을 등록해서 획득한 consumer key, consumer secret과 그리고 우리가 인증후 획득한 token과 token secret이 필요하다.


### userInfo API

아래 예제 코드는 tumblr.js에서 제공하는 블로그의 정보를 가져오는 userInfo 중에서 블로그의 이름을 출력하는 코드이다.

```javascript
// filename : tumblrClient.js

var tumblr = require('tumblr.js');
var client = tumblr.createClient({
  consumer_key: 'SJqHooTujuLcRmxgYHZ3i...',
  consumer_secret: 'vWWvcPaILyzq8VdKuN...',
  token: 'tRQBv0uX3yxGu9dbhBiE1u...',
  token_secret: 'YBUVhmQj7Xxolpx...'
});


client.userInfo(function (err, data) {
  data.user.blogs.forEach(function (blog) {
    console.log(blog.name);
  });
});
```

우리가 만든 텀블러클라이언트를 실행해보자.

```
node bin/tumblrClient.js
```

tumblr는 개인이 여러개의 블로그를 가질 수 있는데 지금 http://saltfactorythings.tumblr.com이라는 블로그 하나만 가지고 있기 때문에 위의 코드를 실행하면 가지고 있는 블로그이 이름 saltfactorythings를 출력하게 된다.

![run tumblr client {width:320px;}](http://asset.hibrainapps.net/saltfactory/images/99d929ee-7ec1-446f-9116-904b11ec7aac)

![show tumblr {width:320px;}](http://asset.hibrainapps.net/saltfactory/images/96ab099a-d39c-4236-a522-5ca16f514c53)

### blogInfo API

블로그의 정보를 가져오는 코드를 추가해보자. tumblr.js에서 블로그의 정보를 가져오기 위해서는 blogname을 가지고 blogInfo 메소드를 사용한다. 현재 블로그의 글은 1건이 있다.

```javascript
// filename : tumblrClient.js

... (생략) ...

client.userInfo(function (err, data) {
  data.user.blogs.forEach(function (blog) {
    console.log(blog.name);

    client.blogInfo(blog.name, function(err, res){
       console.log(res);
    });

  });
});
```
![blog {width:320px;}](http://asset.hibrainapps.net/saltfactory/images/c051f162-ded1-47ea-8ddc-1fbdbf724145)

![run blogInfo](http://asset.hibrainapps.net/saltfactory/images/2aad0d92-91e4-4e56-b12f-a4285af04bfa)

결과는 현재의 블로그에 있는 정보를 가져와서 블로그에 글이 1건 있는 것을 보여준다. 그리고 마지막 업데이트 날짜도 보여주고 여러가지 블로그에 관련된 정보를 가져올 수 있다.

### posts API

다음은 블로그의 posts를 가져오는 코드를 추가해보자. tumblr.js에서는 posts라는 함수를 이용해서 블로그의 posts 정보를 가져올 수 있다.

```javascript
// filename : tumblrClient.js

... (생략) ...
client.userInfo(function (err, data) {
  data.user.blogs.forEach(function (blog) {
    console.log(blog.name);

    client.blogInfo(blog.name, function(err, res){
     console.log(res);
    });

    client.posts(blog.name, function(err, res){
console.log(res);
    });


  });
});
```

![get posts {width:320px;}](http://asset.hibrainapps.net/saltfactory/images/7f911a15-d580-4f0f-85b5-22a94b786042)

### 글쓰기 API

다음은 블로그에 글을 포스팅해보자. 대표 블로그의 이름은 'saltfactorythings'이다. 이 곳에 text 블로그를 포스팅할 것이다. tumblr는 포스팅하는 미디어 타입들이 있다. text, photo, vedio, chat, link 등이 있는데 예제로 text를 포스팅 할 것이다. 이때 옵션으로 title과 body를 입력하는데 title은 컨텐츠의 제목이 되고 body는 HTML 코드를 포함하는 컨텐츠 내용이 된다.

```javascript
// filename : tumblrClient.js

... (생략) ...


// client.userInfo(function (err, data) {
//   data.user.blogs.forEach(function (blog) {
//     console.log(blog.name);
//
//     client.blogInfo(blog.name, function(err, res){
//      console.log(res);
//     });
//
//     client.posts(blog.name, function(err, res){
//       console.log(res);
//     });
//
//   });
// });

var blogName = 'saltfactorythings';
var options = {
  title: 'tumblr API Demo',
  body: '<h2 style="color:red;">Node.js를 이용하여 tumblr API 사용하기</h2>'
};

client.text(blogName, options, function(err, res){
  console.log(res);
});
```

![run write {width:320px;}](http://asset.hibrainapps.net/saltfactory/images/c59fd27d-d64c-457e-b062-02b2067ea97c)

![writed {width:320px;}](http://asset.hibrainapps.net/saltfactory/images/0d10ae4d-606e-4f97-a828-a174ffbf7c01)

실행하면 tumblr에 포스팅이 진행되고 완료가 되면 포스트의 ID 값을 리턴 받게 된다. 그리고 웹 사이트에서 확인을 해보면 우리가 작성한 내용이 포스팅 된 것을 확인할 수 있다.

### 삭제 API

삭제도 가능하다. 삭제는 deletePost라는 함수에 우리가 포스팅한 후 획득한 ID 값을 가지고 blogName에 해당하는 글을 삭제할 수 있다.

```javascript
// filename : tumblrClient.js

... (생략) ...


var blogName = 'saltfactorythings';
// var options = {
//   title: 'tumblr API Demo',
//   body: '<h2 style="color:red;">Node.js를 이용하여 tumblr API 사용하기</h2>'
// };
//
// client.text(blogName, options, function(err, res){
//   console.log(res);
// });
var id = 88353862009;

client.deletePost(blogName, id, function(err, res){
  console.log(res);
});
```

![run delete {width:320px}](http://asset.hibrainapps.net/saltfactory/images/68d4e0ba-6459-45a3-b4da-a2adce998868)

![blog {width:320px;}](http://asset.hibrainapps.net/saltfactory/images/a446b725-5837-4f52-957c-b60d2ee78185)

글 삭제가 성공적으로 마치게되면 삭제한 포스트의 ID 값을 다시 반환한다. 그리고 삭제가 완료된 이후 tumblr 블로그에 가보면 해당되는 글이 삭제된 것을 확인할 수 있다. tubmlr.js에서 tumblr API를 사용할 수 만들어둔 메소드는 다음과 같다. 많은 기능이 제공되고 있는데 인증이 완료된 이후 client를 만들어서 위에서 테스트한 것과 같이 사용하면 쉽게 tumblr API를 사용할 수 있다.

## User Method

```javascript
// Get information about the authenticating user & their blogs
client.userInfo(callback);

// Get dashboard for authenticating user
client.dashboard(options, callback);
client.dashboard(callback);

// Get likes for authenticating user
client.likes(options, callback);
client.likes(callback);

// Get followings for authenticating user
client.following(options, callback);
client.following(callback);

// Follow or unfollow a given blog
client.follow(blogURL, callback);
client.unfollow(blogURL, callback);

// Like or unlike a given post
client.like(id, reblogKey, callback);
client.unlike(id, reblogKey, callback);
```

## Blog Methods

```javascript
// Get information about a given blog
client.blogInfo(blogName, callback);

// Get a list of posts for a blog (with optional filtering)
client.posts(blogName, options, callback);
client.posts(blogName, callback);

// Get the avatar URL for a blog
client.avatar(blogName, size, callback);
client.avatar(blogName, callback);

// Get the likes for a blog
client.blogLikes(blogName, options, callback);
client.blogLikes(blogName, callback);

// Get the followers for a blog
client.followers(blogName, options, callback);
client.followers(blogName, callback);

// Get the queue for a blog
client.queue(blogName, options, callback);
client.queue(blogName, callback);

// Get the drafts for a blog
client.drafts(blogName, options, callback);
client.drafts(blogName, callback);

// Get the submissions for a blog
client.submissions(blogName, options, callback);
client.submissions(blogName, callback);
```
## Post Methods

```javascript
// Edit a given post
client.edit(blogName, options, callback);

// Reblog a given post
client.reblog(blogName, options, callback);

// Delete a given psot
client.deletePost(blogName, id, callback);

// Convenience methods for creating post types
client.photo(blogName, options, callback);
client.quote(blogName, options, callback);
client.text(blogName, options, callback);
client.link(blogName, options, callback);
client.chat(blogName, options, callback);
client.audio(blogName, options, callback);
client.video(blogName, options, callback);
```

## Tag Methods

```javascript
// View posts tagged with a certain tag
client.tagged(tag, options, callback);
client.tagged(tag, callback);
```

## 결론

국내 서비스는 API 제공을 그렇게 많이 지원하고 있지 않다. 하지만 국외 서비스에서는 API를 아주 많은 일을 가능하게 할 수 있게 대부분의 기능을 API로 제공하고 있다. tumblr는 아주 유명한 소셜 블로그 서비스이다. tumblr는 여러가지 강력한 블로그 기능 뿐만 아니라 API를 제공하고 있기 때문에 다양한 서비스를 만들어 낼 수 있는 강점을 가지고 있다. 특히 tumblr는 Node.js에서 사용할 수 있는 tumblr.js를 공식적으로 지원하고 있고, 이미 대부분의 API를 사용할 수 있는 메소드를 공개했다. Node.js의 모듈 중에 passort는 현재 존재하는 소셜 서비스의 대부분의 OAuth 인증을 쉽게 처리할 수 있는 모듈이다. OAuth는 웹 인증을하기 때문에 express를 이용해서 웹 서비스를 만들어 passort 모듈을 사용하여 인증을 하면 tumblr의 인증을 쉽게 처리할 수 있다. 이 때 passort-tumblr 미들웨어를 사용하면 효율적으로 서비스를 만들 수 있다.

## 참고

1. https://www.tumblr.com/docs/en/api/v2
2. https://github.com/jaredhanson/passport-tumblr
3. http://passportjs.org/guide/
4. https://github.com/tumblr/tumblr.js

