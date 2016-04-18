---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 13.WAC AddressBook, Contact사용하기
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, wac, addressbook, contact]
comments: true
redirect_from: /138/
disqus_identifier : http://blog.saltfactory.net/138
---

## 서론

Appsspresso(앱스프레소)의 WAC를 이용하면 단일 코드로 WAC를 지원하는 디바이스의 Contact(연락처)정보를 가져올 수 있다. 우리는 앞에 포스팅된 deviceapis를 이용하여 WAC의 모든 모듈에 접근 가능하다는 것을 예제를 통해서 실습을 했고, ADE를 이용해서 변수 내부를 확인하는 방법도 실습했었다. 이 포스팅에서는 AddressBook을 찾아서 그 안에 속한 Contacts 연락처 정보를 사용하는 방법에 대해서 실습하기로 한다.

<!--more-->

Appspresso에서 구현한 Contact Module은 http://appspresso.com/api/wac/contact.html 에서 확인할 수 있다.
우선 Appspresso Application Project에서 contact를 사용하기 위해서 deviceapi.pim 이라는 것과 deviceapi.pim.contact라는 plugin이 필요하다.  그래야 WAC의 features 중에서 http://wacapps.net/api/pim, http://wacapps.net/api/pim.contact, http://wacapps.net/api/pim.contact.read, http://wacapps.net/api/pim/contact.write 를 사용할 수 있게 된다.

그래서 우리는 project.xml 에서 deviceapis.pim과 deviceapis.pim.contact를 추가한다.

![](http://asset.hibrainapps.net/saltfactory/images/d24703c1-5500-4ad2-888b-bad6ca2af420)

Appspresso 에서 WAC로 연락처를 접근하기 위해서 가장 먼저 해야하는 일이 AddressBook을 찾아오는 것이다.
Appspresso 에서 ContactManager는 contact 모듈에 관한 인터페이스로 주소록 참조에 관한 것을 담당하고 있다. 이것을 이용해서 우리는 AddressBook을 찾을 것이다. AddressBook을 얻기 위해서는 deviceapis.pim.contact.getAddressBooks 메소드를 다음과 같이 사용해서 획득할 수 있다.

```
{PendingOperation} getAddressBooks(successCallback, errorCallback)
```

이 코드를 좀더 이해하기 쉽게 다음과 같이 표현할 수 있다. getAddressBooks는 successCallback과 errorCallback을 가지고 있는데 getAddressBooks 작업이 성공적으로 완료되면 successCallback 이 호출되고 addressBooks라는 주소록 배열 객체를 successCallback 으로 점겨주게 된다. 그럼 그 addressBooks을 가지고 앞으로 그 주소록 안에 있는 연락처 정보들을 이용할 수 있게 되는 것이다. 실패하게 되면 errorCallback을 error 객체 넘기면서 호출 하게 된다.

```javascript
var deviceapis = window.deviceapis;

var PendingOpertaion = deviceapis.pim.contact.getAddressBooks(
		function(addressBooks){
			console.log(addressBooks); // success callback function
		},
		function(error){
			console.log(error); // error callback function
		}
);
```

우리는 예제의 이해를 돕기 위해서 CRUD (Create, Read, Update, Delete)작업을 할 것이다. index.html에 네가지 버턴을 만들고 각각, create, find, update, delete 라는 이름을 붙인다. 그리고 가각 createContact(), findContacts(), updateContact(), deleteContact() 메소드를 호출하게 하였다.

```html
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="/appspresso/appspresso.js"></script>
<script src="/js/app.js"></script>
</head>
<body>
	<h1 id="title">Hello</h1>
	<h3>net.saltfactory.tutorial</h3>
	<button onClick="createContact();">create</button>
	<button onClick="findContacts();">find</button>
	<button onClick="updateContact();">update</button>
	<button onClick="deleteContact();">delete</button>
</body>
</html>
```

우리는 네가지 CRUD 메소드를 각각 구현하면서 디바이스 주소록에 연락처를 추가, 찾기, 업데이트, 삭제 작업을 테스트할 것이다.
먼저 Appspresso의 WAC 인터페이스들은 errorCallback을 요구하고 있기 때문에 테스트를 위해서 errorCallback 메소드를 작성한다. 좀더 세밀하게 각각의 상황에 맞추어서 errorCallback을 구현하는것이 더욱 좋은 코드가 될 것이지만 테트스를 위해 모든 errorCallback은 하나의 에러 처리 메소드를 사용할 수 있게 app.js에 다음 코드를 추가한다.

```javascript
var deviceapis = window.deviceapis;


/* Error Callback */
function errorCallback(error){
	console.log("The following error occurred:" + error.code);
}
```

## 연락처 추가

연락처에 관한 모든 작업은 주소록이 있어야 가능하다. AddressBook을 획득하는 방법은 위에서 deviceapis.pim.getAddressBook으로 가져올 수 있다고 확인했다. 그래서 create 버턴을 누르면 동작할 createContact() 메소드 안에 AddressBook을 획득하는 코드를 추가하고 AddressBook을 정상적으로 가져오게 되면 addContactToAddressBook(AddressBook) 메소드로 주소록을 넘겨서 작업하게 할 것이다.

```javascript
function createContact(){
	deviceapis.pim.contact.getAddressBooks(function(addressBooks){
		if(addressBooks.length > 0){
			addContactToAddressBook(addressBooks[0]);
		} else {
			console.log("This device have not addressbook");
		}

	}, errorCallback);
}
```

다음은 AddressBook을 정상적으로 획득하면 실제 Contact 정보를 추가하기 위해서 addContactToAddressBook 메소드를 구현해보자. AddressBook에 Contact를 추가하기 위해서 Contract Property를 지정하여 지정된 정보를 가지고 createContact로 contact를 만들고 난 다음에 addContact로 주소록에 추가할 수 있다. 현재 Appspresso 1.1에서 제공하는 property는 다음에서 확인할 수 있다. http://appspresso.com/api/wac/symbols/ContactProperties.html

```javascript
function addContactToAddressBook(addressBook){
	var contact_properties = {
			firstName:'성광',
			lastName:'송',
			nicknames:['saltfactory'],
			emails:[{email:'saltfactory@gmail.com'}],
			phoneNumbers:[{number:'010....'}]};

	var contact = addressBook.createContact(contact_properties);
	addressBook.addContact(addContactSuccessCallback, errorCallback, contact);
}
```

다음은 addressBook.addContact 작업이 정상적으로 완료되면 addContactSuccessCallback(contact) 메소드가 호출되는데 이때 입력한 contact 를 인자로 가지고 호출하게 된다. 주소록에 연락처 정보가 추가되고 난 다음에 이루어질 작업을 (보통 UI 업데이트 작업을 하거나 로깅을 한다) 구현하자.

```javascript
function addContactSuccessCallback(contact){
	console.log("Added contact [" + contact.id + "] - "  + contact.firstName + "," + contact.emails[0].email);
}
```

createContact()에 관련된 모든 메소드를 확인하면 다음과 같다.

```javascript
// create contact
function addContactSuccessCallback(contact){
	console.log("Added contact [" + contact.id + "] - "  + contact.firstName + "," + contact.emails[0].email);
}

function addContactToAddressBook(addressBook){
	var contact_properties = {
			firstName:'성광',
			lastName:'송',
			nicknames:['saltfactory'],
			emails:[{email:'saltfactory@gmail.com'}],
			phoneNumbers:[{number:'0109...'}]};

	var contact = addressBook.createContact(contact_properties);
	addressBook.addContact(addContactSuccessCallback, errorCallback, contact);
}

function createContact(){
	deviceapis.pim.contact.getAddressBooks(function(addressBooks){
		if(addressBooks.length > 0){
			addContactToAddressBook(addressBooks[0]);
		} else {
			console.log("This device have not addressbook");
		}

	}, errorCallback);
}
```

빌드하고 ADE로 확인을 해보자. 우리가 입력한 contact property 정보를 모두 입력하고 난 뒤 addContactSuccessCallback으로 넘겨 받은 contact를 확인하면 다음과 같이 저장된 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/14881e3c-2efe-4dd1-8bba-3e6fd9272b47)

실제 디바이스 주소록에 추가가 되었는지 확인해보자. 먼저 Android 폰에서 테스트한 것이다.

![](http://asset.hibrainapps.net/saltfactory/images/e91d50e0-018e-4283-8d39-9918669efda4)

![](http://asset.hibrainapps.net/saltfactory/images/fbe6c95c-bbb2-42f5-9e53-f361c85e0f54)

iOS 폰에서도 테스트 해보자. 테스트는 iPod으로 했지만 iPhone이나 iPad에서도 동일하게 주소록에 연락처 정보가 추가되는 것을 확인할 수 있을 것이다.

![](http://asset.hibrainapps.net/saltfactory/images/d6b1b48f-fbbc-43e5-9367-3c7043caf945)

![](http://asset.hibrainapps.net/saltfactory/images/b91fce34-673a-44f4-9214-0b3aea2f6731)

## 연락처 검색


연락처를 검색하는 과정도 연락처를 추가하는 방법과 동일하게 AddressBook을 먼저 획득한 후 AddressBook.findContacts라는 메소드를 호출하고 successCallback과 errorCallback을 추가한다. 한가지 다른 점이 있다면 filter를 적용하는 것인데, 현제 Appspresso의 WAC 2.0에서는 filter의 구현이 제한되어 있다. 예제는 % 기호를 이용해서 우리가 SQL 에서 사용하는 Like 연산을 할 수 있게 지원해주는데 아직 다른 비교 연산은 되지 않는다. 이는 이후에 좀더 다양한 방법의 predicate를 추가할 수 있도록 업데이트 해주면 좋을 것 같다. addressBook의 findContacts라는 메소드를 이용해서 주소록에 해당되는 filter가 적용된 Contacts를 찾게 된다. 그리고 그 결과 (contact Array)를 successCallback으로 넘겨서 호출하게 되는데 여기서 UI 갱신이나 다른 작업을 진행하면 된다.

```javascript
// find contact
function findContactsSuccessCallback(contacts){
	if (contacts.length == 0){
		console.log("AddressBook is empty");
	}

	for (var i=0; i < contacts.length; i++){
		var contact = contacts[i];
		console.log("contact [" + contact.id + "] - "  + contact.firstName + "," + contact.emails[0].email);
	}
}

function findContacts(){
	var filter = {phonenumber:"%"};
	deviceapis.pim.contact.getAddressBooks(function(addressBooks){
		addressBooks[0].findContacts(findContactsSuccessCallback, errorCallback, filter);
	}, errorCallback);
}
```

## 연락처 업데이트

연락처 업데이트도 추가와 삭제와 마찬가지 과정으로 진행된다. 다만 연락처를 업데이트하기 위해서 대상 Contact를 찾아야하는데 이는 findContacts로 해당되는 연락처를 filter를 이용해서 찾으면 된다. 예제에서는 마지막에 추가된 연락처를 새로운 이름으로 업데이트하도록 하였다. 다시 ADE를 갱신하여 update 버턴을 누르면 주소록에 이름이 새로운 이름으로 변경된 것을 확인할 수 있을 것이다. 한가지 주의할 점은 sucessCallback 메소드에서 넘겨 받은 Contact 정보가 새로 갱신된 contact가 아니라는 것이다. 기존에 저장되어 있는 참조 객체를 가져온 것이기 때문에 만약에 갱신된 결과를 가져오기 위해서는 다시 findContact를 해서 가져와야한다. contact._id는 업데이트하기 위해 타겟이 된 객체의 id를 출력하기 위한 것이다.

```javascript
// update contact
function updateContactSuccessCallback(contact){
	console.log("Updated contact [" + contact._id + "]");
}


function updateContact(){
	deviceapis.pim.contact.getAddressBooks(function(addressBooks){
		var addressBook = addressBooks[0];
		var filter = {phonenumber:"%"};
		addressBook.findContacts(function(contacts){
			var contact = contacts[contacts.length -1];
			contact.firstName = '성광2';
			addressBook.updateContact(updateContactSuccessCallback, errorCallback, contact);
		}, errorCallback, filter);
	}, errorCallback);
}
```

updateContactSuccessCallback에서 받게되는 Contact의 객체는 변경되기 이전의 객체 스냅샷이다. 아래그림은 breakpoint를 추가하여 변수 내부를 살펴본 것이다. Appspresso 다음 버전에서는 업데이트 이후의 객체가 넘겨 받을 수 있도록 되어지면 좋을 것 같다.

![](http://asset.hibrainapps.net/saltfactory/images/0e4f5063-1a60-4f80-b700-4831e47c65cf)

## 연락처 삭제

마지막으로 연락처 삭제를 하는 deleteContact()를 구현해보자. 역시 AddressBook을 획득해서 처리하는 것과 동일하다. 다만 타겟 연락처를 지정할 때는 update와 다르게 contact.id를 가지고 삭제를 진행한다는 것이다. 이 또한 그냥 contact 객체를 넘겨주면 될것 같은데 아마도 기존의 delete 과정의 절차를 그대로 표현하기 위해서 id만 가지고 삭제되는 것으로 구현이 된듯하다. ORM에서 삭제할 때는 해당되는 객체를 넘겨주면 자동으로 id를 분석해서 해당되는 row를 삭제하는데 이런 기능도 지원되면 좋을것 같다. 또 delegateContact의 successCallback 메소드에서는 앞의 과정과 다르게 Contact 정보가 넘어가지 않는다. 아마도 객체게 삭제 되었기 때무에 참조되는것이 없어서 넘기지 않는것 같은데, 어떤 객체가 삭제되었는지 변수에 저장해뒀다가 넘겨주는 것도 좋을 것같다.

```javascript
// delete contact
function deleteContactSuccessCallback(){
	console.log("Deleted contact;");

}

function deleteContact(){
	deviceapis.pim.contact.getAddressBooks(function(addressBooks){
		var addressBook = addressBooks[0];
		var filter = {phonenumber:"%"};

		addressBook.findContacts(function(contacts){
			var contact = contacts[contacts.length -1];
			addressBook.deleteContact(deleteContactSuccessCallback, errorCallback, contact.id);
		}, errorCallback, filter);

	}, errorCallback);
}
```

## 결론

Appspresso(앱스프레소)에서 제공하는 주소록과 연락처의 접근 방법은 ContactManager 모듈을 사용하면 된다. Contact에 접근하기 위해서는 반드시 AddressBook을 먼저 획득해야한다. 이는 deviceaips.pim.contact.getAddressBook 으로 획득할 수 있고 성공되어서 호출하는 successCallback 안에서 CRUD를 진행하는 AddressBook.addContact, AddressBook.findContacts, AddressBook.updateContact, AddressBook.deleteContact를 구현하면 된다. Appspresso 1.1 현재 버전에서 제공하는 WAC의 Contact Property는 네이티브에서 제공하는 모든 property를 표현하지는 못하지만 기본적인 연락처 정보는 모두 포함할 수 있다. 이러한 이유로 주소록에 확장 필드를 사용하지 않고 단순하게 Contact 정보만을 사용할 경우는 WAC의 API로 접근해서 가져오는 방법을 사용하면 하나의 코드로 아이폰과 안드로이드 폰 모두에서 주소록과 연락처를 관리할 수 있는 코드를 구현할 수 있을 것이다.

## 참고

1. http://appspresso.com/api/wac/contact.html
2. http://appspresso.com/api/wac/symbols/ContactManager.html
3. http://appspresso.com/api/wac/symbols/AddressBook.html
4. http://appspresso.com/api/wac/symbols/ContactProperties.html

