---
layout: post
title: Sencah Touch2를 이용한 하이브리드 앱 개발 - 6.Form Components
category: sencha
tags: [sencha, sencha touch, hybridapp, hybrid, view, component, form]
comments: true
redirect_from: /148/
disqus_identifier : http://blog.saltfactory.net/148
---

## 서론

하이브리드 앱의 큰 강점은 바로 HTML 의 속성을 사용할 수 있다는 것이다. 이말은 다시 말해서 네이티브 코드로 만들기 어려운 HTML에서 제공하는 UI 또는 CSS 스타일을 사용할 수 있다는 것이다. 실제 네티티브 라이브러리보다 웹 오픈 소스 UI가 더 많다는 장점을 바로 사용할 수 있다. Sencha는 이러한 HTML의 form을 사용할 수 있는데 이것을 이용해서 뷰를 구성하는데 편리함을 제공하고 있다. 이번 포스팅에는 Sencha Touch의 Form components를 살펴보자.

<!--more-->

## Panel

Panel은 앞에서 포스팅 된 예제에서 이미 여러번 사용해서 익숙한 컴포넌트이다. Panel은 어플리케이션에서 특정 부분을 Container로 표현하거나 overlay를 만들 때 사용한다. 앞에서는 overlay 예제를 해본적이 없으니 다음과 같이 overlay를 구성해보자. app.js를 다음과 같이 변경하고 저장한다. (다음 코드는 Sencha Touch 2의 공식 문서에 나오는 예제이다.)

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		var button = Ext.create('Ext.Button', {
		      text: 'Button',
		      id: 'rightButton'
		 });

		 Ext.create('Ext.Container', {
		     fullscreen: true,
		     items: [
		         {
		              docked: 'top',
		              xtype: 'titlebar',
		              items: [
		                  button
		              ]
		          }
		     ]
		 });

		 Ext.create('Ext.Panel', {
		     html: 'Floating Panel',
		     left: 0,
		     padding: 10
		 }).showBy(button);

	}
});
```

간단하게 button으로 부터 overlay 된 floating Panel을 만들 수 있다.

![](http://blog.hibrainapps.net/saltfactory/images/e69a6ec5-2361-4bb1-a393-bfaf353011e6)

## FieldSet, Text Field, Password Field

FieldSet은 form의 엘리먼트를 분리하는데 상용되는 컴포넌트이다. FieldSet은 보통 입력받는 필드를 그룹화할 때 상용되는데 Ext.form.FieldSet 안에는 여러개의 Ext.field 컴포넌트가 조합되어 구성된다. app.js를 다음과 같이 수정해보자. 다음 코드는 textfield 두개와 fieldset을 이용해서 멋진 화면이 구성이 된다는 것을 확인할 수 있다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.form.Panel', {
		    fullscreen: true,
		    items: [
		        {
		            xtype: 'fieldset',
		            title: 'About You',
		            instructions: 'Tell us all about yourself',
		            items: [
		                {
		                    xtype: 'textfield',
		                    name : 'firstName',
		                    label: 'First Name'
		                },
		                {
		                    xtype: 'textfield',
		                    name : 'lastName',
		                    label: 'Last Name'
		                }
		            ]
		        }
		    ]
		});
	}
});
```

![](http://blog.hibrainapps.net/saltfactory/images/d94fb16c-0658-44df-a768-5095b503bce7)

그리고 name 으로 form 태그의 input 태그의 name 속성으로 정의 되는 것을 확인할 수 있다. 우리는 나중에 자바스크립트나 POST로 데이터를 전송할때 이 name을 유용하게 사용할 수 있을 것이다.

![](http://blog.hibrainapps.net/saltfactory/images/b5e231da-0734-427e-9b28-9b90fdb26337)

우리는 공식문서에 제공하는 예제코드를 우리의 테스트에 맞게 수정해보자. 다음과 같이 아이디와 비밀번호를 넣기 위한 입력 폼을 가지는 뷰를 구성한다고 가정할때 코드는 다음과 같이 변경할 수 있다.

![](http://blog.hibrainapps.net/saltfactory/images/cef6b7a2-25a7-4853-811f-babcbe8c3af7)

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.form.Panel', {
		    fullscreen: true,
		    items: [
		        {
		            xtype: 'fieldset',
		            title: '필수사항',
		            items: [
		                {
		                    xtype: 'textfield',
		                    name : 'userId',
		                    label: '아이디'
		                },
		                {
		                    xtype: 'passwordfield',
		                    name : 'password',
		                    label: '비밀번호'
		                },
				{
				    xtype: 'passwordfield',
				    name : 'password_confirm',
				    label: '비밀번호확인'
				}
		            ]
		        }

		    ]
		});
	}
});
```

## Checkbox Field

체크 항복을 만드는 것도 Ext.field.Checkbox 를 이용하면 간단하 만들어 낼 수 있다. checkboxfield의 속성으로 checked를 true로 설정하면 체크가 된 상태로 나타나진다는 것을 확인할 수 있다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.form.Panel', {
		    fullscreen: true,
		    items: [
		        {
		            xtype: 'fieldset',
		            title: '필수사항',
		            items: [
		                {
		                    xtype: 'textfield',
		                    name : 'userId',
		                    label: '아이디'
		                },
		                {
		                    xtype: 'passwordfield',
		                    name : 'password',
		                    label: '비밀번호'
		                },
						{
							xtype: 'passwordfield',
							name : 'password_confirm',
							label: '비밀번호확인'
						}
		            ]
		        },
				{
					xtype: 'fieldset',
					title : '약관',
					instructions: '약관에 동의하셔야 서비스를 정상적으로 사용할 수 있습니다.',
					items: [
						{
							xtype: 'checkboxfield',
							name: 'agreement',
							value: '1',
							checked: true,
							label: '개인정보이용동의'
						},
						{
							xtype: 'checkboxfield',
							name: 'agreement',
							value: '1',
							checked: false,
							label: '약관동의'

						}
					]
				}


		    ]
		});
	}
});
```

![](http://blog.hibrainapps.net/saltfactory/images/80711c52-9a57-49da-b33b-156e08ba8f64)

Ext.Field 의 컴포넌트는 너무 쉽게 입력 폼을 구성할 수 있다는 것을 확인할 수 있을 것이다. 더욱 흥미로운 것은 마치 UILabel과 같이 크기에 따라 자동으로 테스트가 줄임말로 변환시켜준다는 것이다. 이것은 마치 UILabel과도 동일한 느낌을 들게 해준다. 일부러 창을 작게 만들어 보면 Label의 크기가 전체 비율이 줄어드는 비율과 적절하게 함께 줄어드는데 텍스트 크기가 label의 크기를 넘어서면 텍스트가 자동으로 ... 을 나타내며 label 안에 알맞은 형태로 변형된다는 것이다.

![](http://blog.hibrainapps.net/saltfactory/images/c64465d3-b05e-4180-8572-43d3184c310b)

## Hidden Field

사실 이 기능은 왜 있어야할지 조금 의문이 들기도 하지만 HTML의 form 속성을 다 사용할 수 있다는 것으로 생각하면 되겠다. 보통 앱에서 데이터를 다룰때는 hidden 값으로 가지는 것은 거의 드물기 때문이다. 이런 경우는 보통 웹 프로그램에서 익숙할 수도 있지만, 하이브리드 앱의 장점은 네이티브 코드나 데이터베이스를 사용할 수 있다는 장점이 있기 때문이다. 그래도 HTML에서 제공하는 form의 Hidden 필드도 만들 수 있다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.form.Panel', {
		    fullscreen: true,
		    items: [
		        {
                         .... 생략 ...

						{
							xtype: 'hiddenfield',
							name : 'ipaddress',
							value: '123.123.123.123'
						}

		        },
			... 생략 ...

		    ]
		});
	}
});
```

## Slide Field

jQuery UI를 사용하면 슬라이드와 같은 UI를 쉽게 만들 수 있지만 아무리 좋은 UI를 가지고 있더라도 다른 자바스크립트 라이브러리를 가져와서 사용하게 되면 사실 그러한 모든 것들이 네트워크에서 소스코드를 다운받고 렌더링하는 비용이 필요하게 된다. Sencha에서는 그래서 대부분의 UI를 내장시켜두었다. Slide 역시 네이티브 앱을 만들거나 웹 앱을 만들때 유용하게 사용할 수 있는 UI이기 때문에 Ext.field.Slide 컴포넌트로 만들어 두었다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.form.Panel', {
		    fullscreen: true,
		    items: [
		        {
... 상동 ...
		        },
				{
					xtype: 'fieldset',
					title: '자기능력평가',
					items:[
						{
							xtype: 'sliderfield',
							label: '모델링능력',
							value: 50,
							minValue: 0,
							maxValue: 100
						},
						{
							xtype: 'sliderfield',
							label: '프로그래밍능력',
							value: 50,
							minValue: 0,
							maxValue: 100
						},
					]
				},
				{
... 상동 ...
				}
		    ]
		});
	}
});
```

![](http://blog.hibrainapps.net/saltfactory/images/09076d07-c397-4e8e-87f1-5e0f04ee6299)

## Data Picker Field

Sencha field 중에서 가장 마음에 드는 것은 아무래도 Picker를 바로 field 값으로 바인딩할 수 있다는 것이 아닐까 생각이 든다. 실제 이와 동일한 코드를 네이티브 코드로 작성하면 꽤 많은 코드를 사용하기 때문이다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.form.Panel', {
		    fullscreen: true,
		    items: [
		        {
		            xtype: 'fieldset',
		            title: '필수사항',
		            items: [
... 상동 ...
						{
							xtype: 'datepickerfield',
							label: '생년월일'
						}
		            ]
		        },
... 상동 ...
		    ]
		});
	}
});

```

![](http://blog.hibrainapps.net/saltfactory/images/d41a6e2c-73ea-4da7-8a4a-73ef51e8cb39)

## Email Field

이메일을 입력하는 필드를 만든다고 가정할때 사용자들은 이상한 이메일 형태를 입력할지도 모른다. 그래서 우리는 이메일 형태를 미리 알려줄 수 있게 힌트를 주기도 한다. 다음 코드를 살펴보자. placeHolder는 입력될 수 있는 데이터의 힌트를 나타내어 준다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.form.Panel', {
		    fullscreen: true,
		    items: [
... 상동 ...
			{
				xtype: 'emailfield',
			 label: 'email',
				placeHolder: 'saltfactory@gmail.com'						     		    }
		            ]
		        },
... 상동 ...
		});
	}
});
```

## Select Field

만약 두가지의 데이터 중에서 선택해야하는 항목을 표현하고 싶을 수도 있다. 이럴 경우 picker를 사용하기도 하지만 Sencha를 이용하면서 우리는  selectbox 와 유사한 인터페이스를 제공 받을 수 있다. 다음 코드를 살펴보자. Sencha에서 데이터의 저장 방법은 store라는 것을 사용하기 때문에 다음과 같이 data를 집합을 만들어서 store로 저장하여 selectfield의 stroe로 저장하게 되면 store에 저장되어져 있는 data 값들 중에서 한가지를 선택할 수 있다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.form.Panel', {
		    fullscreen: true,
		    items: [
... 상동 ...
				{
				xtype: 'selectfield',
				name : 'sex',
				label: '성별',
				valueField: 'sex',
				displayField : 'title',
				store:{
					data: [
						{sex:'1', title:'남'},
						{sex:'2', title:'여'}
					]
				}
				}
... 상동 ...

		    ]
		});
	}
});
```

![](http://blog.hibrainapps.net/saltfactory/images/98eacded-b7bb-4396-b9a9-3fe3b3c1eee0)

전체 코드는 다음과 같다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.form.Panel', {
		    fullscreen: true,
		    items: [
		        {
		            xtype: 'fieldset',
		            title: '필수사항',
		            items: [
		                {
		                    xtype: 'textfield',
		                    name : 'userId',
		                    label: '아이디',
							value: 'saltfactory'
		                },
		                {
		                    xtype: 'passwordfield',
		                    name : 'password',
		                    label: '비밀번호',
							value: 'test'
		                },
						{
							xtype: 'passwordfield',
							name : 'password_confirm',
							label: '비밀번호확인',
							value: 'test'
						},
						{
							xtype: 'hiddenfield',
							name : 'ipaddress',
							value: '123.123.123.123'
						},
						{
							xtype: 'datepickerfield',
							label: '생년월일'
						},
						{
							xtype: 'emailfield',
							label: 'email',
							placeHolder: 'saltfactory@gmail.com'
						},
						{
							xtype: 'selectfield',
							name : 'sex',
							label: '성별',
							valueField: 'sex',
							displayField : 'title',
							store:{
								data: [
									{sex:'1', title:'남'},
									{sex:'2', title:'여'}
								]
							}
						}
		            ]
		        },
				{
					xtype: 'fieldset',
					title: '자기능력평가',
					items:[
						{
							xtype: 'sliderfield',
							label: '모델링능력',
							value: 50,
							minValue: 0,
							maxValue: 100
						},
						{
							xtype: 'sliderfield',
							label: '프로그래밍능력',
							value: 50,
							minValue: 0,
							maxValue: 100
						},
					]
				},

				{
					xtype: 'fieldset',
					title : '약관',
					instructions: '약관에 동의하셔야 서비스를 정상적으로 사용할 수 있습니다.',
					items: [
						{
							xtype: 'checkboxfield',
							name: 'agreement',
							value: '1',
							checked: true,
							label: '개인정보이용동의'
						},
						{
							xtype: 'checkboxfield',
							name: 'agreement',
							value: '1',
							checked: false,
							label: '약관동의'

						}
					]
				}


		    ]
		});
	}
});

```

## Picker

우리는 꽤 멋진 사용자 입력 폼을 Sencha Touch 2의 Ext.form.Feildset과 Ext.field 컴포넌트로 구성했다. 마지막으로 picker에 대해서 좀더 살펴보자. Ext.Picker 는 네이티브의 picker controller와 거의 유사한 인터페이스를 가지고 있다. 그럼 이 picker 안에 데이터를 어떻게 변경하여 사용할 수 있는지 다음 코드를 살펴보자. selectfield를 만들 때 우리는 여러개의 값을 data에 지정하고 그것을 store 저장하여 사용하였다. Picker의 특징을 살펴보면 picker 또한 여러개의 데이터를 가지고 있기 때문에 data를 저장하는 store를 사용하면 될것 같은데  picker는 여러가지 slot으로 구성되기 때문에 slot에 데이터를 표현하는 형태이다. 다음 코드를 살펴보자. slot은 picker의 분류를 나누는 부분이다. 아래 예제는 언어와 경력 두가지 분류로 나었기 때문에 두 가지의 slot을 가지고 있고 각각 해당하는 데이터를 가지고 있다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		var picker = Ext.create('Ext.Picker', {
		    slots: [
		        {
		            name : 'language',
		            data : [
		                {text: 'Objective-C', value: 1},
		                {text: 'Java', value: 2},
		                {text: 'Ruby', value: 3},

		            ]
		        },
		        {
		            name : 'career',
		            data : [
		                {text: '1년 미만', value: 1},
		                {text: '1년 이상', value: 2},
		                {text: '2년 이상', value: 3},
		                {text: '3년 이상', value: 4}
		            ]
		        }

		    ]
		});
		Ext.Viewport.add(picker);
		picker.show();
	}
});
```

![](http://blog.hibrainapps.net/saltfactory/images/5cbeaeae-db35-4340-84c6-7c7de6ba35c3)

## 결론

이번 포스팅에서는 Sencha의 Form Components를 이용해서 사용자로부터 데이터를 입력받을 수 있는 뷰를 구성하는 내용에 대해서 살펴보았다. Sencha는 웹 앱뿐만 아니라 하이브리드 앱을 작성할 때 네이티브 코드에서 만들기 복잡한 UI를 기본적으로 아름답게 구성할 수 있는 인터페이스를 제공해준다. 이렇게 입력한 데이터는 Ajax나 하이브리드 앱에서 서버로 전송하게하여 사용자의 입력 프로세스를 완성할 수 있을 것이다. 다음은 뷰를 구성하는 컴포넌트([Sencah Touch2를 이용한 하이브리드 앱 개발 - 3.컴포넌트 구성](http://blog.saltfactory.net/142) 에 소개된)의 마지막인 General Components에 대해서 알아보기로 한다.

Sencha Touch는 웹 앱을 위한 UI 프레임워크이다. 지금 예제는 마치 아이폰의 예제인것 처럼 보일정도로 모바일 인터페이스에 따라서 만들어진다는 것을 느낄 수 있지만 iPad난 Tablet 등 여러가지 다양한 Touch 화면에서 동작하는 웹 앱을 자유롭게 만들 수 있게 설계되어져 있다. 그러한 디바이스 지원들은 Sencha Touch 의 꾸준한 업데이트로 하나의 코드로 좀더 다양한 터치화면과 일반 브라우저에서 문제 없이 돌아갈 수 있는 보장을 받고 있다. Sencha 는 데스크탑용 UI 프레임워크가 따로 존재하고 Sencha Touch는 터치 기반의 인터페이스를 가지는 모바일 기계나 터치화면 PC에 최적화 되어 있다. 그리고 내장 UI의 형태는 iOS의 네이티브에 가깝게 만들어져 있다. 하지만 이러한 스타일은 현재 이 포스팅에서 논의하는 뷰의 구성과 다른 문제(스타일의 문제)이기 때문에 논의하지는 않지만, Sencha Touch를 잘 활용하면 웹 프로그램의 방법으로 앱을 편리하게 만들 수 있다는 것을 알 수 있을 것이다. 더 나아가서는 모바일 하이브리드 앱에 접목해서 더욱더 개발 비용을 감소하고 좋은 효과를 얻을 수 있을거라 예상된다. Sencha Touch를 이용한 하이브리드 앱 개발에 대해서는 http://blog.saltfactory.net/category/Appspresso 의 튜토리얼을 통해서 경험할 수 있을 것이다.

## 참고

1. 에이콘, "센차터치 모바일 프로그래밍"
2. http://docs.sencha.com/touch/2-0/#!/api/Ext.form.FieldSet
3. http://docs.sencha.com/touch/2-0/#!/api/Ext.field.Text
4. http://docs.sencha.com/touch/2-0/#!/api/Ext.field.Password
5. http://docs.sencha.com/touch/2-0/#!/api/Ext.field.Hidden
6. http://docs.sencha.com/touch/2-0/#!/api/Ext.field.Email
7. http://docs.sencha.com/touch/2-0/#!/api/Ext.field.DatePicker
8. http://docs.sencha.com/touch/2-0/#!/api/Ext.field.Select
9. http://docs.sencha.com/touch/2-0/#!/api/Ext.picker.Picker

