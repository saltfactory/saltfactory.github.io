---
layout: post
title : Ruby를 이용해서 웹 사이트 스크래핑하여 HTML 분석하기
category : ruby
tags : [ruby, web, srapping]
comments : true
redirect_from : /82/
disqus_identifier : http://blog.saltfactory.net/82
---

## 서론

개발자나 연구자는 일반 사용자와 달리 웹사이트를 분석해야하는 일이 종종 있다.  검색 엔진이 웹사이트의 데이터를 가져와서 인덱싱하고 키워드 검색이 들어오면 그 웹 사이트를 리시팅해주기 위해서 crawling을 하는데 이와 비슷한 개념으로 웹 사이트를 마치 브라우저에서 보는것 처럼 그 사이트의 모든 코드를 긁어가는 것을 scrapping이라고 말하기도 한다.

이번 토이 프로젝트는 (이 단어는 현업에서 개발하는분께서 지금과 같은 작은 프로젝트를 토이 프로젝트라고 칭하기에 사용한다. 서브 프로젝트라고 말했는데 생각해보면 토이 프로젝트가 더 맞는 말인것 같기도 하기 때문이다.) 학생들에게 좀더 편리한 학교 생활을 해주기 위해서 간단한 모바일 앱을 만들려고하는데 DB에 엑세스할 수 없기 때문에 웹 사이트에서 데이터를 분석해서 디비화 시켜서 서비스를 해야하는 문제가 발생했다. 그래서 웹 사이트를 scrapping을 해서 HTML 코드를 분석해서 필요한 데이터만 Local DB에 저장하기로 했다.

필요한 핵심 기법은 두가지였다.

1. 웹 사이트의 브라우저를 열었을 때와 동일하게 웹 사이트 코드를 가져 올 수 있어야 한다.
2. 웹 사이트 코드를 가져와서 HTML의 특정 부분의 컨텐츠를 가져올 수 있어야 한다.

1번의 기법은 cURL로 충분히 가능하다. 맥 사용자나 유닉스 계열 사용자라면 cURL이라는 커멘드를 사용할 수 있다는 것이 얼마나 다행인줄 알고 있을 것이다. 하지만 나는 좀더 고수준의 언어를 사용하기 원했다. Java나 C보다는 간단하게 프로그램을 작성하길 원했고, shell과 상호 연동이 잘되어서 나중에 scrapping 프로그램을 cron을 이용해서 스케쥴링까지 하고 싶기 때문이다. 그래서 처음은 python으로 만들었는데 나중에 웹 프레임워크로 Ruby on Rails를 사용할 생각이여서 Ruby로 프로그램으로 다시 만들었다.  (python으로 scrapping하는 방법은 나중에 python 카테고리에서 다시 정리해서 포스팅을 할 예정이다.)

Ruby를 선택한 이유는 나중에 RESTful 서비스를 위해서 웹 프레임워크를 Ruby on Rails를 사용하기 위해서 이지만 또 다른 이유는 Ruby는 코드를 매우 간단하게 만들어주고 막강한 closure 기능이 있기 때문이다. 실제 자연어처리를 할때 python과 ruby는 Java에 비해서 훨씬 프로그램을 간단하게 만들어 주었던 것을 경험했다.

Ruby를 이용해서 cURL처럼 웹 사이트의 코드를 가져오기 위해서는 open-uri를 이용하면 된다. open-uri를 사용하는 간단한 예제이다. 다음과 같이 open(웹사이트주소)로 간단하게 웹 사이트의 코드를 모두 scrapping 할 수 있다.

```ruby
require "open-uri"

open("http://www.ruby-lang.org/") {|f|
   f.each_line {|line| p line}
}
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/800d2cef-0bb3-40fe-bb31-be9f15ae7f2d)

open-uri는 웹사이트의 코드를 가져오는 것 이외에 추가적으로 웹사이트의 헤더 정보도 가져올 수가 있다. 다음 예제는 open-uri를 이용해서 웹사이트를 요청하고 응답받은 헤더의 정보를 확인하는 코드이다.

```ruby
require "open-uri"

open("http://www.ruby-lang.org/en") {|f|
    # f.each_line {|line| p line}
    p f.base_uri         # <URI::HTTP:0x40e6ef2 URL:http://www.ruby-lang.org/en/>
    p f.content_type     # "text/html"
    p f.charset          # "iso-8859-1"
    p f.content_encoding # []
    p f.last_modified    # Thu Dec 05 02:45:02 UTC 2002
  }
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/0c45882e-5d7c-4849-867c-9d2ab28010a3)

이렇게 open-uri를 이요하면 웹 사이트의 코드를 가져오는 것을 할 수 있다. 필요한 기법 1번째를 해결했으니 이제 2번째를 해결할 차례이다. 웹사이트를 분석한다는 말은 parsing이라는 말과 동일하다. 그리고 좀더 구체적으로 우리가 원하는 컨텐츠는 HTML 속에 있는 특정 HTML element 안에 있는 글자들이다. 자연어 처리로 이 방법을 처리하기 위해서는 html 코드를 모두 없애고 (strip) 뛰어쓰기 단위로 단어를 잘라서 처리를 하겠지만, 난 프로그램이 가볍고 코드가 간단하기를 원했다. 그래서 XPath를 사용할수 있는 HTML 파서를 찾아야했고 Nokogiri가 XPath를 지원하여서 HTML 파서로 Nokogiri를 사용했다. HTML 파서의 종류는 다양하기 때문에 자신에게 필요한 파서를 선택하면 될 것 같다. 참고로, python으로 만들었을때는 BeautifulSoup을 이용했다.

Nokogiri를 사용하기 위해서 gem을 이용하여 Nokogiri를 모듈을 설치한다. Nokogiri에 관한 자세한 설명은 API 웹사이트로 대신한다. http://nokogiri.org/

```
sudo gem install nokogiri
```

Nokogiri를 이용한 HTML 파싱 테스트를 http://www.ruby-lang.org/en/community/ 사이트를 살펴보자.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/37f7b39c-1ac9-4836-8e19-bc5960283950)

이 커뮤니티 사이트에서 제목만을 가져오고 싶다고 할때 HTML구조를 살펴보면 `<div id="content"><dl><dt><a>` 태그 밑에 제목들이 있다는 것을 알 수 있다. 이를 XPath로 접근하고자 할때 `//div[@id="content"]/dl/dt/a` 로 접근을 할 수 있는데 Nokogiri에서는 다음과 같이 표현할 수 있다.

```ruby
require "open-uri"
require "nokogiri

url = "http://www.ruby-lang.org/en/community/"
doc = Nokogiri::HTML(doc = open(url))
doc.xpath('//div[@id="content"]/dl/dt/a').each do |a|
  puts a.content
end
```

이 코드를 실행시키면 다음과 같이 제목만 출력되는 것을 확인 할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/085469a1-00c1-4b52-bb86-f4d7dd48ca9c)

