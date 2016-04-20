---
layout: post
title: IntelliJ에서 Java와 Gradle 버전 설정하기 (Spring Boot)
category: java
tags:
  - java
  - spring
  - springboot
  - gradle
  - intellij
comments: true
images:
  title: 'http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/3e9b5e77-9286-44ed-8c6d-f2f4927685cc'
---

## 서론

[IntelliJ](https://www.jetbrains.com/idea/)는 Java 어플리케이션 개발 도구로는 가장 좋은 IDE가 아닌가 생각된다. 학생 때는 Eclipse가 없으면 Java 어플리케이션을 어떻게 개발할 수 있을까 생각하면서 Eclipse가 제일 좋은 IDE라고 생각했는데, IntelliJ를 경험하고 나서는 Eclipse를 아예 지워버렸다. 빠르고 안정적이라서 개발 속도를 높여주는 IntelliJ를 정말 좋아하고 있다. 이런 이유로 IntelliJ를 만든 JetBRAINS의 개발 툴을 대부분 사용하고 있다. 꽤 높은 돈을 지불하고도 아깝지 않은 개발 툴이다.

IntelliJ는 시스템에 설치되어 있는 Java 버전을 자동으로 인식하기도 하고, 자체적으로 내장한 SDK를 사용하기도 한다. 또한 [Gradle](http://gradle.org/) 프로젝트를 만들면 필요한 라이브러리들을 자동으로 다운받거나 찾아서 개발 환경 변수에 자동으로 등록을 해준다. Spring Boot 예제를 만들기 위해서 시스템에 최신 Gradle을 설치하고 IntelliJ로 프로젝트를 생성하고 난 뒤 **gradle build**를 하는데 다음과 같은 에러가 발생하면서 빌드가 되지 않는 문제를 만나게 되었다.

> FAILURE: Build failed with an exception.

> \* What went wrong:

> Execution failed for task ':compileJava'.

> invalid source release: 1.8

이 글에서는 IntelliJ에서 최신 Java와 Gradle 설정이 맞지 않았을 경우 발생하는 문제를 소개하고 이 두가지 버전을 설정하는 방법을 소개한다.

<!--more-->

## 최신 Java 업데이트

이 글을 작성할 때 Java  최신 버전은 **1.8.0_25** 이다. Mac에서 JAVA_HOME은 기본적으로 **/Library/Java/JavaVirtualMachines/{버전}/Contents/Home** 으로 설치가 되어진다. Mac에서는 여러버전의 Java를 설치할 수 있는데 이런 방법으로 설치가 되기 때문에 **$JAVA_HOME** 환경변수에 자신이 사용하려는 버전의 홈을 등록하여 사용하면된다. 시스템을 켤 때 마다 JAVA_HOME 시스템 환경변를 등록하는 것을 꽤 불편하다. 다음 코드를 **~/.bash_profile** 안에 저장해두면 원하는 Java 버전을 환경변수에 자동으로 등록한다.

```bash
function setjdk() {
  if [ $# -ne 0 ]; then
   removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
   if [ -n "${JAVA_HOME+x}" ]; then
    removeFromPath $JAVA_HOME
   fi
   export JAVA_HOME=`/usr/libexec/java_home -v $@`
   export PATH=$JAVA_HOME/bin:$PATH
  fi
 }
 function removeFromPath() {
  export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
 }
setjdk 1.8
```

만약 $JAVA_HOME 시스템 환경 변수를 변경하고 싶을 경우 터미널에서 다음과 같인 버전을 입력하면 된다. 그러면 해당하는 버전중에 가장 마지막 업데이트 버전을 사용할 수 있다.

```
setjdk 1.7
```

## 최신 Gradle 업데이트

이 글을 작성할 때 최신 Gradle의 버전은 **2.9**이다. Mac을 사용한다면 대부분 [Homebrew](http://brew.sh/)를 사용할 것이다. 이것은 유닉스(리눅스) 패키지를 Mac 설치할 수 있을 뿐만 아니라 버전 관리가 아주 편리하기 때문에 Mac 사용자들이가 가장 좋아하는 어플리케이션이다. Homebrew로 가장 최신 패키지를 업그레이드를 하기전에 먼저 리파지토리 정보를 업데이트해야한다.

```
brew update
```

이젠 Gradle을 설치하거나 업데이트를 한다. 만약 시스템에 Gradle이 설치되어 있지 않으면 다음과 같이 설치한다.

```
brew install gradle
```

만약 설치되어 있다면 가장 최신 버전을 설치하기 위해서 업그레이드를 한다.

```
brew upgrade gradle
```

Homebrew로 패키지를 설치하면 기본적으로 **/usr/local/Cellar/{패키지명}/{버전}**으로 설치가 되고 개발을 위한 라이브러를 포함한 실제 홈 디렉토리를 참조하기 위해서는 **/usr/local/Cellar/{패키지명}/{버전}/libexec**를 참조해야한다. 만약 Gradle 2.8 홈 디렉토리를 참조하고 싶을 경우에는 **/usr/local/Cellar/gradle/2.9/libexec**를 환경변수에 등록하여 사용하면 된다.

## IntelliJ 에서 Gradle 빌드 Java 버전 문제

IntelliJ에서 Gradle 프로젝트를 생성하거나 Spring Boot 프로젝트를 생성할 때 Gradle의 버전과 Java 버전을 선택하는 화면들이 나오는데 정확하게 버전을 추가 했다고 생각하더라도 가끔 IDE에서 버전이 맞지 않아 컴파일이 되지 않거나 빌드가 되지 않는 문제를 만날 수 도 있다. 이것은 사실은 사용자가 정확한 버전을 프로젝트 개발하는 변수에 설정을 잘못해서 일어나는 문제이다. 우리는 Gradle을 최신 버전으로 업그레이드하고 Gradle 프로젝트를 빌드하였는데 다음과 같이 **compileJava FAILED** 에러를 보게 되었다. 이것은 프로젝트에서 Gradle을 빌드할 때 사용하는 Java의 버전이 맞지 않아서 발생하는 문제이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6e386f3e-3115-4cc8-a6df-212367c387ec)

IntelliJ은 앞서 말한것 같이 시스템에 자바가 설치되어 있지 않더라도 자체적으로 포함하고 있는 JDK를 사용하여 개발을 할 수 있도록 만들어져있다. 그래서 현재 개발하고 있는 IDE가 사용하고 있는 JDK 버전이 무엇인지 꼭 알고 있어야한다. 예를 들어 IDE가 내장하고 있는 1.7 자바 버전이 설정되어 있는지도 모르고, 시스템 환경변수에 1.8 버전을 등록했다고 개발할 때 1.8에 의존적인 코드를 작성하면 IDE에서는 컴파일이 되지 않는 문제가 발생한다.

## IntelliJ에서 Java 버전 설정

그럼 Java 프로젝트를 진행할 때 Java 버전을 설정하는 곳을 살펴보자.

먼저 프로젝트 디렉토리에서 오른쪽 마우스를 클릭하여 **Open Module Settings**을 열어보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/3421e26e-740f-41c9-bbad-12b47ff9f3dc)

그러면 **Modules**에서 사용하고 있는 **Dependencies** 가 보이게 될 것이고 현재 이 프로젝트에서 사용하고 있는 **Module SDK**를 다음과 같이 확인할 수 있다. 현재 **1.8** 버전으로 개발하고 있는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/770c2049-f5b8-458a-b604-3cb39eb0c679)

다음은 열린 다이얼로그 왼쪽에서 **Project Settings** 중에 **Project**를 클릭해보자. 다음과 같이 **Project SDK**와 **Project language level**을 선택하여 개발하고 싶은 Java 버전과 문법의 레벨을 설정할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d3421107-ae7b-4ead-8299-af4434647465)

다음은 열린 다이얼로그 왼쪽에서 **Platform Settings** 중에 **SDKs**를 클릭해보자. 플랫폼에 적용될 수 있는 SDK 버전들을 볼 수 있다. IntelliJ는 통함 IDE이기 때문에 안드로이드와 Ruby 개발을위한 SDK들도 보여지고 있는데 보통은 Java 버전들만 보일 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/aa6ca999-59dc-418c-b9c5-afe45f815fc2)

다음은 IntelliJ **Preferences**를 열어서 **Build, Execution, Development** 의 **Compiler** 중에 **Java Compiler**를 선택하면 다음과 같이 컴파일러를 선택하는 화면이 나타난다. 우리는 앞에서 Java SDK와 Language Level을 선택하는 화면을 봤을 것이다. **Project bytecode version(leave blank for JDK default)**를 살펴보면 앞에서 설정한 Language Level과 동일한 버전을 사용하는 것을 살펴볼 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/16ddae84-5fb0-4e9e-a4e2-f6ca9767d7e5)

만약 우리가 Java 1.8 버전으로 프로젝트 개발을 한다면 위에서 살펴본 SDK 버전을 모두 동일하게 적용해줘야한다.

## IntelliJ에서 Gradle 버전 설정

앞에서 Java 버전을 설정하는 것을 살펴보았고 이제 Gradle 버전을 설정하는 것을 살펴보자. Gradle은 Groovy 기반으로 JVM에서 동작을 한다. 그래서 Java 버전과 밀접한 관계를 가진다. IntelliJ의 **Preferences**를 열어서 gradle이라 검색을 해보자. **Build, Execution, Deployment** 안의 **Build Tools** 중에 **Gradle**을 선택하면 다음과 같은 화면을 볼 수 있다.

![Build, Execution, Deployment](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d2cf4845-5576-4858-9a1d-af50e2b060dd)

**Project-level settings**를 살펴보면 프로젝트에서 사용하는 Gradle을 설정하는 것이 보인다. **Gradle home**은 프로젝트에서 사용할 Gradle의 경로를 지정할 수 있다. Homebrew로 사용하여 Gradle을 설치하였기 때문에 **/usr/local/Cellar/gradle/2.9/libexec**로 지정을 했다. 다음은 중요한 **Gradle JVM**이다. 이것이 이 프로젝트에서 Gradle이 사용할 Java 버전인 것이다. 우리가 프로젝트에서 설정한 Gradle 빌드 파일 **build.gradle** 은 다음과 같다.  

```groovy
buildscript {
    ext {
        springBootVersion = '1.3.0.RELEASE'
    }
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")
    }
}

apply plugin: 'java'
apply plugin: 'eclipse'
apply plugin: 'idea'
apply plugin: 'spring-boot'

jar {
    baseName = 'spring-boot-demo'
    version = '0.0.1-SNAPSHOT'
}
sourceCompatibility = 1.8
targetCompatibility = 1.8

repositories {
    mavenCentral()
}


dependencies {
    compile('org.springframework.boot:spring-boot-starter-thymeleaf')
    compile('org.springframework.boot:spring-boot-starter-web')
    testCompile('org.springframework.boot:spring-boot-starter-test')
}


eclipse {
    classpath {
         containers.remove('org.eclipse.jdt.launching.JRE_CONTAINER')
         containers 'org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-1.8'
    }
}

task wrapper(type: Wrapper) {
    gradleVersion = '2.9'
}

```

여기서 **sourceCompatibility**와 **targetCompatibility**를 설정한 것을 보면 Java 버전을 8버전을 사용하는 것을 살펴볼 수 있다. 하지만 위 스크린샷을 보면 Gradle JVM에서는 Java 7 버전이 설정이 되어 있다. 프로젝트에서 지정한 build.gradle의 버전과 IntelliJ의 **Gradle JVM**이 맞지 않아서 발생하는 문제이다. 이 버전은 8 버전으로 변경을 한다.

![change Gradle JVM](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7a23f4a7-a27a-40fc-878a-606a120db7bc)

다시 Gradle을 빌드해보자. 이제 프로젝트의 Gradle과 IntelliJ의 Java와 Gradle 설정이 맞아서 문제 없이 빌드가 성공되는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/65441f96-e062-4d0b-9294-ce10ce483f1a)

## 결론

Spring에서 Gradle을 지원하면서 Gradle의 사용이 많아졌다. Java 프로젝트를 개발할 때 IntelliJ라는 아주 좋은 IDE에서 Gradle 프로젝트를 효율적으로 사용할 수 있게 해준다. Gradle은 Java 버전과 관계가 있으며 프로젝트에 설정한 Java 버전과 IntelliJ의 Java 버전이 일치해야한다. 이 설정부분을 맞지 않아 Java 버전에 관한 에러가 발생하면 당황하지 말고 IntelliJ의 Java 설정 부분을 차근차근 살펴보면 해결할 수 있을 것이라 기대된다.


## 참조

1. http://stackoverflow.com/questions/24766591/javac-invalid-target-release-1-8
2. https://spring.io/guides/gs/gradle/#_build_your_project_with_gradle_wrapper

