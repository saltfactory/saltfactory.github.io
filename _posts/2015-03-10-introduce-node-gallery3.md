---
layout: post
title: node-gallery3을 이용하여 Gallery3 REST API 사용하기
category: node
tags: [javascript, node, node.js, gallery3, api, rest]
comments: true
redirect_from : /266/
disqus_identifier : http://blog.saltfactory.net/266
---

## 서론

Gallery3은 이미지 호스팅 서비스를 개발할 때 가장 많이 사용하고 있는 오픈소스 Photo Album Organizer이다. Gallery3은 REST API를 지원하기 때문에 서버에 Gallery3을 운영하고 있다면 REST API를 사용하여 다양한 어플리케이션을 개발 할 수 있다. Gallery3의 API를 사용하기 위해 node.js 모듈 node-gallery3을 만들었다. node-gallery3을 이용하여 Gallery3 REST API를 사용하는 방법에 대해서 소개한다.

<!--more-->

## Gallery 소개

[Gallery](http://galleryproject.org/)는 웹에서 사진을 관리하기 위한 오픈소스 Photo Album Organizer 이다. [Instagram](https://instagram.com/)이나 [KakaoStory](https://story.kakao.com)등 SNS가 유행하면서 지금은 예전처럼 Photo Gallery 사이트를 많이 볼수 없지만 아직 전문적인이고 체계적인 이미지 서비스를 위해 Photo Gallery를 도입하여 사용하는 곳이 많다.

[500px](https://500px.com/)과 같은 사진 커뮤니티를 만들기 위해서 어렵게 프로그램을 만들지 않고 Gallery을 사용하여 이와 같은 서비스를 쉽게 만들 수 있다. Gallery은 오래전부터 인기있는 [PHP](http://php.net) 오픈소스 프로젝트 중에 하나이다. Gallery 프로젝트는 Gallery1, Gallery2 그리고 Gallery3 버전으로 개발이 진행되고 있고 가장 최근의 프로젝트가 Gallery3 이다.

## Gallery3 REST

Gallery3는 앨범과 사진정보에 관한 [RESTful](http://en.wikipedia.org/wiki/Representational_state_transfer) 서비스 모듈을 추가 하였다. [Gallery3:API:REST](http://codex.galleryproject.org/Gallery3:API:RESTl) 페이지에서 Gallery3의 REST 서비스에 관한 자세한 설명을 참조할 수 있다.

Gallery3의 REST 서비스를 요청하기 위해서 http 요청을 할 때 header에 **X-Gallery-Request-Key**와 **X-Gallery-Request-Method**를 반드시 추가해서 사용해야한다.

### X-Gallery-Request-Key

Gallery의 REST 서비스를 요청하는 header에 request key를 반드시 필요하는데 이 값은 Login 요청으로 획득할 수 있다. [Gallery3:API:REST](http://codex.galleryproject.org/Gallery3:API:RESTl) 페이지에서 **X-Gallery-Request-Key**를 획득하기 위한 요청 예제를 찾을 수 있다.

```
POST /gallery3/index.php/rest HTTP/1.1
Host: example.com
X-Gallery-Request-Method: post
Content-Type: application/x-www-form-urlencoded
Content-Length: 25
user=admin&password=12345
```

위의 요청의 결과는 아래와 같이 **X-Gallery-Request-Key**의 값을 문자열로 응답을 받을 수 있다.

```
 HTTP/1.1 200 OK
 Content-Length: 34
 Content-Type: application/json
 "1114d4023d89b15ce10a20ba4333eff7"
```

이렇게 발급 받은 **X-Gallery-Request-Key**를 이용하여 Gallery REST API를 요청할 수 있다. 예를 들어 **item 1**에 관한 **GET** 요청을 한다면 다음과 같이 발급받은 X-Gallery-Request-Key를 이용하여 요청할 수 있다.

```
GET /gallery3/index.php/rest/item/1 HTTP/1.1
Host: example.com
X-Gallery-Request-Method: get
X-Gallery-Request-Key: 1114d4023d89b15ce10a20ba4333eff7
```

### X-Gallery-Request-Method

Gallery REST 서비스도 다른 [RESTful](http://en.wikipedia.org/wiki/Representational_state_transfer)와 동일하게 **Method**를 이용하여 동일한 URL에 다른 의미의 요청을 가능하게 할 수 있다. Method의 값은 **GET**, **POST**, **UPDATE** 그리고 **DELETE**로 지정 할 수 있다.

### Response format

Gallery3의 REST의 요청의 결과는 **JSON**과 **HTML**으로 받을 수 있는데 `output`이라는 파라미터를 추가후 `output=json`또는 `output=html`으로 지정할 수 있다. 기본적으로는 `json`으로 지정된다. 다음은 응답받은 JSON 문자열이다.

```
 GET /gallery3/index.php/rest/item/1
 ...
 HTTP/1.1 200 OK
 Content-Length: 1200
 Content-Type: application/json
 {"url":"http:\/\/example.com\/gallery3\/index.php\/rest\/item\/1","entity":{"id":"1","captured":
 null,"created":"1270793819","description":"","height":null,"level":"1","mime_type":null,
 "name":null,"owner_id":"2","rand_key":null,"resize_height":null,"resize_width":null,"slug":null,
 "sort_column":"weight","sort_order":"ASC","thumb_height":"103","thumb_width":"164","title":
 "Gallery","type":"album","updated":"1270958456","view_count":"0","width":null,"view_1":"1",
 "view_2":"1","album_cover":"http:\/\/example.com\/gallery3\/index.php\/rest\/item\/3",
 "thumb_url":"http:\/\/example.com\/gallery3\/var\/thumbs\/\/.album.jpg?m=1270958456"},
 "relationships":{"tags":{"url":"http:\/\/example.com\/gallery3\/index.php\/rest\/item_tags\/1",
 "members":["http:\/\/example.com\/gallery3\/index.php\/rest\/tag_item\/9,1",
 "http:\/\/example.com\/gallery3\/index.php\/rest\/tag_item\/10,1"]}},"members":[
 "http:\/\/example.com\/gallery3\/index.php\/rest\/item\/7",
 "http:\/\/example.com\/gallery3\/index.php\/rest\/item\/11",
 "http:\/\/example.com\/gallery3\/index.php\/rest\/item\/26"]}
```
위 결과를 JSON 객체로 변형하면 다음과 같다.

```
{
   "url": "http://example.com/gallery3/index.php/rest/item/1",
   "entity": {
     "id": "1",
     "captured": null,
     "created": "1270793819",
     "description": "",
     "height": null,
     "level": "1",
     "mime_type": null,
     "name": null,
     "owner_id": "2",
     "rand_key": null,
     "resize_height": null,
     ...skipped some values to keep things short...
     "album_cover": "http://example.com/gallery3/index.php/rest/item/3",
     "thumb_url": "http://example.com/gallery3/var/thumbs//.album.jpg?m=1270958456"
   },
   "relationships": {
     "tags": {
       "url": "http://example.com/gallery3/index.php/rest/item_tags/1",
       "members": [
         "http://example.com/gallery3/index.php/rest/tag_item/9,1",
         "http://example.com/gallery3/index.php/rest/tag_item/10,1"
       ]
      }
    },
   "members": [
     "http://example.com/gallery3/index.php/rest/item/7",
     "http://example.com/gallery3/index.php/rest/item/11",
     "http://example.com/gallery3/index.php/rest/item/26"
   ]
 }
```
GAllery의 REST의 결과값은 크게 **url**, **entity**, **relationships**, **memebers** 로 나눌 수 있다.

* **url** : REST로 접근한 URL
* **entity** : item의 정보 (앨범, 사진, 영상 등 Gallery의 모든 객체를 item*으로 표현하고 있고 item은 entity로 세부 정보를 지정하거나 표현된다)
* **releationships** : 요청한 item과 연관된 item의 집합
* **members** : item에 접근 가능한 멤버의 집합


## node-gallery3

[Node.js](https://nodejs.org) 프로젝트를 진행하면서 이미지 관련해서 Gallery3 서비스를 구축하여 이미지를 관리하기 위해 Node로 만들어진 Gallery3 Client가 필요했다. Gallery3 공식 페이지에서는 [rWatcher](http://codex.galleryproject.org/Gallery_3:Other_Clients:Gallery_3_REST_Client_(rWatcher))라는 클라이언트와 [써드파티 클라이언트](http://codex.galleryproject.org/Category:Gallery_3:Other_Clients)에 관한 자료를 제공하고 있고,  [python](http://codex.galleryproject.org/Gallery3:API:REST:Python)과 [android-java](http://codex.galleryproject.org/Gallery3:API:REST:Java-Android)로 된 예제는 공개하고 있지만 Node.js 모듈로 만들어진 client 자료는 없어서 직접 만들게 되었다.

[node-gallery3](https://github.com/saltfactory/node-gallery3)는 Gallery3의 REST API를 사용하기 위한 [Request.js](https://github.com/request/request)를 이용하여 Gallery REST API 요청을  랩핑한 모듈이다. 직관적이고 코드의 간결성을 위해 [Promise](https://github.com/kriskowal/q)를 사용하여 응답을 처리하도록 하였다.

**node-gallery3**은 NPM을 이용하여 쉽게 설치할 수 있다. global `-g` 옵션을 이용하여 설치하면 CLI로 사용도 가능하다.

```
npm install node-gallery3
```

**node-gallery3**는 객체를 생성할 때 Gallery3 서버의 정보를 입력하거나 정보를 `$HOME/.gallery3.json` 파일을 만들어서 사용 할 수 있다. **node-gallery3** 사용하기 위한 설정 값은 다음과 같다.

* **host** : Gallery3 서버가 설치된 호스트 정보
* **basae** : Gallery3 서버에 Gallery3가 설치된 URL 경로 (생략하면 `/gallery3`이 기본 값으로 지정)
* **rootItemId** : 기본적으로 REST 요청을 타겟 Item으로 보통 사진 파일을 업로드할 앨범의 id를 지정 (생락하면 `1`이 기본 값으로 지정)
* **requestKey** : Gallery3의 REST API를 요청하기 위해서 반드시 필요한 **X-Gallery-Request-Key**의 값

생성자에 정보를 입력하여 사용하는 방법은 다음과 같다.

```
var options = {
	host: 'http://example.com',
	base: '/gallery3',
	rootItemId: 1,
	requestKey: '1234abcd'
};
var gallery3 = new Gallery3(options);
```

설정 파일로 만들어서 사용하려면 `$HOME/.gallery3.json` 파일에 다음과 같이 저장한다.

```
{
	'host': 'http://example.com',
	'base': '/gallery3',
	'rootItemId': 1,
	'requestKey': '1234abcd'
}
```

## Gallery3.login(user, password)

Gallery3의 REST API를 사용하기 위해서는 **X-Gallery-Request-Key**가 필요한데 이 값을 획득하기 위해서 **node-gallery3**의 `Gallery3.login(user, password)` 메소드를 사용하여 획득 할 수 있다.

```
  describe('login', function(){
    it('login user/password', function(done){
      var user = 'user';
      var password = 'password'

      gallery3.login(user, password)
        .success(function(result){
          console.log(result);
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });
  });
```

![](http://assets.hibrainapps.net/images/var/albums/posts/Screen_Shot_2015-03-11_at_10_25_24_AM.png?m=1426039276)

## Gallery3.findItem(identifier)

Gallery3에서는 **앨범**, **사진**, **동영상** 등 모든 정보를 **item**이라는 개념으로 정보를 표현한다. 이미 만들어진 앨범의 정보를 요청하기 위해서 `Gallery3.findItem(identifier)` 메소드를 사용하여 정보를 가져올 수 있다. 이때 **identifier**는 고유 **URL**이거나 **ItemId**를 넣어주면 된다.

```
describe.only('findItem', function(){
    var itemId = 2;
    var url = gallery3.options.host + gallery3.options.base + '/rest/item/' + itemId;

    it('find item by url', function(done){
      console.log(gallery3);
      gallery3.findItem(url)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

    it('find item by item id', function(done){
      gallery3.findItem(itemId)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });
  });
```
![](http://assets.hibrainapps.net/images/var/albums/posts/Screen_Shot_2015-03-11_at_10_28_34_AM.png?m=1426039277)

## Gallery3.createItem(entity, identifier)

Gallery3에서 **앨범**은 `type`이 `album`인 **item**이다. 새로운 앨범을 생성하기 위해서는 `Gallery3.createItem(entity, identifier)` 메소드를 사용한다. entity의 내용은 다음과 같다.

* **type** : 앨범을 만들기 위해서'album' 으로 지정한다.
* **name** : 앨범의 이름
* **title** : 앨범 타이틀

앨범은 특정 앨범 하위에 서브 앨범으로 만들 수 있는데 이 때 상위 item의 **identifier**(상위 item의 URL이나 itemId)를 입력한다. 정상적으로 앨범이 생성되면 결과 값으로 생성한 앨범의 **URL**을 가진 **JSON**을 반환한다.

```
 describe.only('create Item', function(){
    var itemId = 2;
    var url = gallery3.options.host + gallery3.options.base + '/rest/item/' + itemId;
    var entity = {
      type: 'album',
      name: 'Sample Album',
      title: 'This is my Sample Album'
    };

    it('create Item without parentItem, default', function(done){
      gallery3.createItem(entity)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

    it('create Item in parent item by url', function(done){
      gallery3.createItem(entity, url)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

    it('create Item in parent item by itemId', function(done){
      gallery3.createItem(entity, itemId)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });
  });
```
![](http://assets.hibrainapps.net/images/var/albums/posts/Screen_Shot_2015-03-11_at_10_39_26_AM.png?m=1426039277)

## Gallery3.uploadFile(filePath, entity, identifier)

Gallery3의 주 목적은 사진을 업로드하는 것이다. 사진을 Gallery3에 업로드하기 위해서는 `Gallery3.uploadFile(filePath, entity, identifier)` 메소드를 사용하면 된다.

* **filePath** : 컴퓨터 내의 파일 경로
* **entity** : 사진의 정보(이름, 파일이름, 설명 등)를 entity 형식으로 명시할 수 있다. (생략하면 파일 이름 기반으로 자동으로 만들어짐)
* **identifier** : 사진이 업로드될 앨범 (생략하면 itemId가 1인 최상위에 사진이 업로드 된다)

이미지가 정상적으로 업로드가 되면 업로된 객체의 **Item**에 대한 고유 URL을 JSON 형태로 반환한다.

> 업로드 후 반환되는 URL은 이미지의 URL이 아니라 이미지의 정보를 가지는 Item의 URL이라는 것을 주의해야한다.

이미지에의 URL을 획득하기 위해서는 `Gallery3.findItem(identifier)`를 사용하면 이미지의 URL 정보를 포함한 JSON을 가져올 수 있다.


```
describe.only('upload file', function(){
    var itemId = 2;
    var url = gallery3.options.host + gallery3.options.base + '/rest/item/' + itemId;
    var filePath = '/Users/saltfactory/Downloads/bh6hug.jpg';
    var entity = {
      title: 'title',
      description: 'description'
    };

    it('upload file without parent identifier', function(done){
      //gallery3 = new Gallery3({rootItemId:58});

      gallery3.uploadFile(filePath)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

    it('upload file without entity in parent album by url', function(done){

      gallery3.uploadFile(filePath, url)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

    it('upload file without entity in parent album by id', function(done){
      gallery3.uploadFile(filePath, itemId)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

    it('upload file with entity', function(done){
      gallery3.uploadFile(filePath, entity)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

    it('upload file with entity and url', function(done){
      gallery3.uploadFile(filePath, entity, url )
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

    it('upload file with entity and itemId', function(done){
      gallery3.uploadFile(filePath, entity, itemId )
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

  });
```

![](http://assets.hibrainapps.net/images/var/albums/posts/Screen_Shot_2015-03-11_at_10_45_53_AM.png?m=1426039276)


## Gallery3.getImageUrlPublic(identifier)

Gallery3를 이용하면서 이미지 자체의 URL이 필요한 경우가 있다. 이때는 `Gallery3.findItem(identifier)`를 사용하여 가져올 수도 있지만 좀 더 직관적인 메소드인 `Gallery3.getImageUrlPublic(identifier)`를 사용하여 이미지의 URL 가져올 수 있다. 위의 예제에서 생성한 Item 110 사진의 URL을 가져오는 예제를 만들어 보자.

```
describe.only('getImageUrlPublic', function(){
    var itemId = 110;
    var url = gallery3.options.host + gallery3.options.base +'/rest/item/'+itemId;

    it('get public image url by url', function(done){
      gallery3.getImageUrlPublic(url)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

    it('get public image url by itemId', function(done){
      gallery3.getImageUrlPublic(itemId)
        .success(function(result){
          console.log(result)
        })
        .error(function(err){
          console.log(err);
        })
        .finally(done);
    });

  });
```

![](http://assets.hibrainapps.net/images/var/albums/posts/Screen_Shot_2015-03-11_at_10_52_02_AM.png?m=1426039276)

## 결론

[node-gallery3](https://github.com/saltfactory/node-gallery3)를 사용하여 Gallery3 서버에 앨범을 만들고 사진을 업로드하였다. 실제 서버에는 웹으로 업로드한 파일을 다음과 같이 관리할 수 있다.

![](http://assets.hibrainapps.net/images/var/albums/posts/Screen%20Shot%202015-03-11%20at%2010_54_25%20AM.png?m=1426039277)
![](http://assets.hibrainapps.net/images/var/albums/posts/Screen%20Shot%202015-03-11%20at%2010_54_12%20AM.png?m=1426039277)

Gallery3은 앨범을 만들거나 사진을 관리하기 위한 오픈 소스 프로젝트이만 사용하는 방법에 따라서 다양한 서비스를 만들 수 있다. 이렇게 구축된 Gallery3 서비스를 클라이언트 프로그램이나 외부 프로그램에서 Gallery3의 RESTful API를 사용하여 편리하게 데이터를 가져올 수 있다. 이 때 **node-gallery3**를 이용하면 편리하고 쉽게 Gallery3의 데이터를 관리할 수 있을 것이다. **node-gallery3**은 CLI를 제공하고 있다. Unix나 Mac을 사용하는 사용자는 터미널에서 쉽게 파일을 Gallery3로 업로드할 수 있다. **node-gallery3**을 이용하여 확장된 Gallery3 클라이언트 프로그램도 만들 수 있을 것이다.

## 참조

* http://codex.galleryproject.org/Gallery3:API:REST
* https://github.com/request/request
* https://github.com/kriskowal/q

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
