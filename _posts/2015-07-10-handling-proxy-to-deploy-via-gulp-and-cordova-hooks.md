---
layout: post
title: Ionic 기반 하이브리드 앱에서 gulp.js와 Cordova hooks를 사용하여 proxy 다루기
category: ionic
tags:
  - ionic
  - hybrid
  - hybridapp
  - cors
  - ajax
  - angularjs
  - anguar
  - proxy
  - gulp.js
  - cordova
  - hooks
comments: true
images:
  title: 'http://asset.hibrainapps.net/saltfactory/images/01406f0f-fbc9-444f-813f-be6977949d93'
---

## 서론

앞에 글 [Ionic 기반 하이브리드 앱에서 proxy를 사용하여 CORS 문제 해결하기](http://blog.saltfactory.net/ionic/solve-cross-domain-problem-via-ionic-proxy.html)에서 Ionic을 데스크탑에서 개발할 때 **ionic serve**를 가지고 **proxy** 기능으로 **CORS** 문제 없이 테스트하는 방법을 살펴보았다. 이 방법은 로컬 데스크탑에서 브라우저를 통한 개발을 위한 방법이다. 만약 **proxy**를 사용하여 개발한 코드를 실제 디바이스에 개발하게되면 문제가 발생하지 않을지를 생각해보자. 정답은 Ionic의 **proxy** 기능은 **ionic serve**의 기능이다. 우리가 제품으로 개발하여 설치하는 모바일 디바이스에서는 ionic serve를 사용할 수 없기 때문에 **proxy**는 의미가 없어지게 된다. 즉, 실제 디바이스에서는 원래의 **proxyUrl**을 사용해야 하는 것이다. 이 글에서는 데스크탑에서 개발할 때와 디바이스에 실행할 때 **proxy**을 어떻게 다루는 방법과 [gulp.js](http://gulpjs.com/)를 사용하여 자동화하는 방법을 소개한다.

<!--more-->

## Ionic의 proxy

Ionic의 proxy를 다시한번 살펴보자. Ionic의 **proxy**는 매우 훌륭한 기능이다. 기본적으로 하이브리드 앱을 개발할 때 로컬 데스크탑에서 브라우저를 통한 개발을 하는 시간이 더 많기 때문에 디바이스에 설치하는 시간을 줄이기 위해서 데스크탑에서 브라우저를 통해서 테스트를 많이하게 된다. 이럴 경우 브라우저가 접근하기 위한 **로컬호스트**와 **실제서비스** 서버의 **CORS**의 문제가 발생하는데 Ionic의 **proxy**는 **CORS** 문제를 해결하기 위해서 프록시 기능을 제공하여 **로컬호스트**로 요청하면 프록시를 통해 **실제서버**의 URL로 접근하게 해준다. 좀 더 자세한 설정고 사용방법은 앞의 글 [Ionic 기반 하이브리드 앱에서 proxy를 사용하여 CORS 문제 해결하기](http://blog.saltfactory.net/ionic/solve-cross-domain-problem-via-ionic-proxy.html)을 참고하자.

하지만 여기에는 큰 함정이 하나 있다. Ionic의 **proxy** 를 사용하여 로컬 호스트 브라우저를 통해서 개발을 진행하였다고 이 설정 그대로 디바이스에 디폴로이하여 실행하게 되면 문제가 발생한다. 앞에서 설명한 코드를 디바이스에  실행하여 보자. 테스트를 진행하기 위해서 **iPhone simualtor**를 사용하였다.

```
ionic prepare && ionic emulate ios
```

![emulate 에러 결과](http://asset.hibrainapps.net/saltfactory/images/edc07aab-6068-4e1b-b208-bf26b54b0539)

결과는 **proxy**를 사용한 것을 실제 서버로 가져오지 못하는 문제가 발생했다. 이유는 ionic의 **proxy** 기능은 **ionic serve**에서 제공하는 기능으로 디바이스에서는 사용할 수 없는 기능이기 때문이다. 이 문제를 해결하기 위해서 실제로 디바이스에 디플로이 시키기전에 **proxy**를 위해 사용한 **ApiEndpoint**의 **path**를 **proxyUrl**로 변경해야한다.(앞의 글 참조)

```javascript
// 데스크탑에서 테스트를 하기 위한 proxy path 설정
angular.module('starter', ['ionic'])
.constant('ApiEndpoint', {
  url: '/api'
})
.run(function($ionicPlatform, $http, $rootScope, ApiEndpoint) {
  ...
```

```javascript
// 실제 디바이스에서 사용하기 위한 proxyUrl 설정
angular.module('starter', ['ionic'])
.constant('ApiEndpoint', {
  url: 'http://demo.docker.localhost/api'
})
.run(function($ionicPlatform, $http, $rootScope, ApiEndpoint) {
  ...
```
디바이스에서 사용할 수 있도록 변경하고 다시 디바이스를 실행해보자.

```
ionic prepare && ionic emulate ios
```

![emulate 성공 결과](http://asset.hibrainapps.net/saltfactory/images/ded79429-df3f-499e-a619-4ad660979187)

하지만 매번 개발하면서 디플로이할 때 개발자가 코드를 변경하는 것은 매우 위험한 일이다. 오류가 발생하기 쉽고, 중요한 문제가 발생할 수도 있기 때문이다.

## Ionic의 deploy 원리

Ionic은 단일 코드를 특별한 코드 수정없이 **iOS**나 **android** 디바이스에 실행할 수 있도록 해준다. 원리는 간단하다. ionic의 작업 디렉토리 **./www** 디렉토리 안에 있는 코드를 디플로이하기 전에 각각의 플랫폼에 코드를 복사하여 반영한 뒤 각 디바이스에 맞게 **cordova**를 사용하여 컴파일하여 디바이스에 디폴로이 시키는 것이다.

그럼 **./www*에 작업한 디렉토리는 각 플랫폼 디렉토리에 저장되는 곳을 살펴보자.

- **iOS 플랫폼** : **./platforms/ios/www** 로 복사가 된다.
- **Android 플랫폼** : **./platforms/android/assets/www** 로 복사가 된다.

여기서 우리는 트릭을 사용할 수 있다. 개발하는 코드는 변경하지 않고 디플로이 시킬 경우에만 각 플랫폼의 디렉토리에 복사될 때 **proxy** 설정을 담당하던 **ApiEndpoint**의 **url**을 변경하면 된다. 매번 개발자가 이것을 복사하고 수정한다면 개발자는 상당히 피곤해질 것이다.

## Ionic의 gulp.js 자동화

Ionic은 [gulp.js](http://gulpjs.com/)를 환경으로 개발을 할 수 있게 구조화되어 있다. 이것은 [grunt.js](http://gruntjs.com/)와 같이 Node.js 기반의 자동화 시스템이다. **gulp.js**는 **grunt.js**보다 설정하기가 쉽고, **stream** 기반의 작업을 할 수 있는 장점이 있다.

Ionic 프로젝트의 디렉토리를 살펴보면 **gulpfile.js**라는 것이 존재한다. 이 파일에 자동화하기 원하는 **task**를 추가하면 **gulp**라는 명령어를 사용하여 단순하거나 복잡한 처리 작업을 한번에 자동화할 수 있다. 예를 들어 **sass**로 개발한 스타일을 **css** 파일로 만들거나 css나 javascript 코드를 압축하여 **.min.css**나 **.min.js** 파일로  **uglify** 시킬 수 있다. Ionic에서 기본적으로 제공하는 **gulpfile.js**을 살펴보자.

```javascript
var gulp = require('gulp');
var gutil = require('gulp-util');
var bower = require('bower');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sh = require('shelljs');

var paths = {
  sass: ['./scss/**/*.scss']
};

gulp.task('default', ['sass']);

gulp.task('sass', function(done) {
  gulp.src('./scss/ionic.app.scss')
    .pipe(sass({
      errLogToConsole: true
    }))
    .pipe(gulp.dest('./www/css/'))
    .pipe(minifyCss({
      keepSpecialComments: 0
    }))
    .pipe(rename({ extname: '.min.css' }))
    .pipe(gulp.dest('./www/css/'))
    .on('end', done);
});

gulp.task('watch', function() {
  gulp.watch(paths.sass, ['sass']);
});

gulp.task('install', ['git-check'], function() {
  return bower.commands.install()
    .on('log', function(data) {
      gutil.log('bower', gutil.colors.cyan(data.id), data.message);
    });
});

gulp.task('git-check', function(done) {
  if (!sh.which('git')) {
    console.log(
      '  ' + gutil.colors.red('Git is not installed.'),
      '\n  Git, the version control system, is required to download Ionic.',
      '\n  Download git here:', gutil.colors.cyan('http://git-scm.com/downloads') + '.',
      '\n  Once git is installed, run \'' + gutil.colors.cyan('gulp install') + '\' again.'
    );
    process.exit(1);
  }
  done();
});

```

Ionic 에서 제공하는 **gulpfile.js**에서는 **sass** 파일을 컴파일하는 task가 포함되어 있다. Ionic 프로젝트 안에 있는**./scss** 디렉토리 안에 **.scss** 파일을 만들어 놓고 `gulp`라는 명령얼 사용하여 한번에 css 파일을 만들어 낼 수 있다. 사용하는 방법은 다음과 같이 Ionic 프로젝트 디렉토리에서 **gulp** 명령어만 실행하면 된다.

```
gulp
```

## gulp.js를 사용하여 proxy 핸들링 자동화

우리는 **proxy**를 디바이스에서 사용할 때는 원래의 URL로 변경해야하는 것과 **gulp.js**를 task를 추가하여 자동화하는 방법을 앞에서 살펴보았다. 이제 우리는 **gulpfile.js**에 **proxy**를 다루는 것을 자동화 task로 추가할 것이다.

**gulp.js**를 사용할 때 필요한 모듈을 설치하기 위해서 **./package.json**에 [gulp-replace](https://www.npmjs.com/package/gulp-replace)을 다음과 같이 추가한다.

```
{
  "name": "demo-ionic",
  "version": "1.0.0",
  "description": "demo-ionic: An Ionic project",
  "dependencies": {
    "gulp": "^3.5.6",
    "gulp-sass": "^1.3.3",
    "gulp-concat": "^2.2.0",
    "gulp-minify-css": "^0.3.0",
    "gulp-rename": "^1.2.0",
    "gulp-replace":"latest"
  },
  "devDependencies": {
    "bower": "^1.3.3",
    "gulp-util": "^2.2.14",
    "shelljs": "^0.3.0"
  },
  "cordovaPlugins": [
    "cordova-plugin-device",
    "cordova-plugin-console",
    "cordova-plugin-whitelist",
    "cordova-plugin-splashscreen",
    "com.ionic.keyboard"
  ],
  "cordovaPlatforms": [
    "ios"
  ]
}
```

Ionic 프로젝트 디렉토리에서 **npm**을 사용하여 필요한 모듈을 설치한다.

```
npm install
```

이제 **gulpfile**에 task를 추가한다. task의 이름은 *remove-proxy**이다.
Ionic에서 **proxy**에 관한 설정을 **ionic.project** 파일에서 정의를 하기 때문에 이 파일을 읽어와서 각 플랫폼 디렉토리에 **www/js** 디렉토리 안에 있는
**app.js** 파일에서 **ApiEndpoint**의 **url**에 사용한 **proxies.url**을 원래 주소인 **proxies.pathUrl**로 교체하는 코드를 만들어 넣을 것이다.

gulpfile.js를 열어서 다음과 같이 코드를 수정한다.

```javascript
var gulp = require('gulp');
var gutil = require('gulp-util');
var bower = require('bower');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sh = require('shelljs');
var fs = require('fs');
var replace = require('gulp-replace');

var paths = {
  sass: ['./scss/**/*.scss'],
  replaceFile: './www/js/app.js',
  replacesDest:['./platforms/ios/www/js', './platforms/android/assets/www/js'],
  project:'./ionic.project'
};

var projectInfo = JSON.parse(fs.readFileSync(paths.project));

gulp.task('default', ['sass', 'prepare', 'remove-proxy']);

... 생략

gulp.task('prepare', function(){
  return sh.exec('ionic prepare', {async:false});
});

gulp.task('remove-proxy', function() {
  gulp.src(paths.replaceFile)
    .pipe(replace(projectInfo.proxies[0].path, projectInfo.proxies[0].proxyUrl))
    .pipe(gulp.dest(paths.replacesDest[0]))
    .pipe(gulp.dest(paths.replacesDest[1]));
})

```

이제 **gulpfile.js**의 모든 설정은 마쳤다. 우리는 개발을 진행하다가 디바이스에 테스트를 진행하고 싶으면 **gulp**를 실행하기만하면 된다.

```
gulp
```

![gulp 실행](http://asset.hibrainapps.net/saltfactory/images/b4829930-e9e1-4d7a-9f02-cb5cbe6c005f)

이제 Xcode를 열어서 프로젝트 실행시켜보자. **./platforms/ios/demo-ionic.xcodeproj**를 열어서 Xcode에서 앱을 실행한다. **proxy** 설정으로 데스크탑 브라우저에서만 잘 나왔던 결과와 달리 이제 **proxy**가 적용된 데스크탑 브라우저와 디바이스로 빌드할 때 **gulp**를 사용해서 **proxy**를 제거하여 디바이스에서도 잘 나오게 되었다. 우리는 단순하게 앱을 디바이스에 실행하기전에 **gupl** 명령어만 한번 입력해주면 된다.

![Xcode 실행](http://asset.hibrainapps.net/saltfactory/images/8e4714c3-79e0-43be-83f8-e5d73bc29d03)

## Cordova Hooks

우리는 **gulp**를 실행하고 Xcode나 Android Studio를 열어서 실행을 하였다. 하지만 네이티브 코드 작업없이 순수 Ionic 작업만 할 경우 Xcode나 Android Studio를 열지 않고 앞에서 터미널에서 실행한  **ionic-cli**를 사용하여 바로 디바이스나 에뮬레이터로 실행할 수 있다. **gulp**를 실행한 이후 **ionic-cli**로 실행해보자.

```
gulp
```
```
ionic emulate ios
```

![emulate 에러 결과](http://asset.hibrainapps.net/saltfactory/images/d4974066-22c4-4e3c-aed9-653f44e96a78)

하지만 **gulp**에 미리 실행하였음에도 불구하고 **remove-proxy**가 적용이 되지 않았다. 이유는 **ionic-cli**은 **cordova-cli** 기반으로 만들어졌는데 Cordova에서 **build**, **emulate**, **run** 을 실행하면 필요한 코드들을 복사하고 디바이스에 적용하기 위해서 다시 **prepare**을 실행하기 때문이다. 이런 이유 때문에 **gulp**에서 task 순서를 **prepare** 다음으로 **remove-proxy**를 진행하도록 정의하더라고 Cordova가 **emulate** 명령을 실행하기 전에 다시 **prepare**를 진행하기 때문이다.

그래서 우리는 [Cordova Hooks](http://cordova.apache.org/docs/en/edge/guide_appdev_hooks_index.md.html)에서 **remove-proxy** 실행하도록 등록한다. Cordova 기반으로 만들어진 Ionic 프로젝트의 디렉토리를 살펴보면 **hooks** 디렉토리가 존재한다. 이곳에 다양한 Cordova hooks를 정의할 수 있고 cordova-cli 가 실행될때 hooks를 할 수 있다.
우리는 **gulp**를 실행한 후 **cordova-cli**를 실행하게 되면 **./www* 디렉토리를 다시 복사해서 만들기 때문에 **cordova run**이나 **cordova emulate** 전에 **cordova** 실행후 앞에서 정의한 **gulp**를 다시 실행하도록 정의하자. **./hooks** 디렉토리 밑에 **after_prepare** 디렉토리 안에 **010_add_platform_class.js** 파일이 존재할 것이다. 만약 이 파일이 존재하지 않는다면 **./hooks/after_prepare/** 디렉토리 밑에 javascript 다음 내용으로 추가한다. 다른 내용은 생략하고 앞에서 만든 **gulpfile.js**를 추가한 내용을 살펴보자.

```javascript
var sh = require('shelljs');
... 생략 ...
if (rootdir) {

  // go through each of the platform directories that have been prepared
  var platforms = (process.env.CORDOVA_PLATFORMS ? process.env.CORDOVA_PLATFORMS.split(',') : []);

  for(var x=0; x<platforms.length; x++) {
    // open up the index.html file at the www root
    try {
      var platform = platforms[x].trim().toLowerCase();
      var indexPath;

      if(platform == 'android') {
        indexPath = path.join('platforms', platform, 'assets', 'www', 'index.html');
      } else {
        indexPath = path.join('platforms', platform, 'www', 'index.html');
      }

      if(fs.existsSync(indexPath)) {
        addPlatformBodyTag(indexPath, platform);
        sh.exec('gulp remove-proxy', {async:false});
      }

    } catch(e) {
      process.stdout.write(e);
    }
  }

}
```

**Cordova Hooks**를 추가한 다음 다시 iOS 시뮬레이터에 실행해보자.

```
ionic emulate ios
```

![emulate 성공](http://asset.hibrainapps.net/saltfactory/images/8d11a599-342a-424a-babf-51346762c8cd)


이제 디바이스에서도 성공적으로 데이터 요청이 가능해졌다.

## 결론

**Ionic**은 하이브리드 앱을 개발할 때 **CORS** 문제를 해결하기 위한 훌륭한 **proxy** 메카니즘을 포함하고 있다. 하지만 Ionic의 proxy는 **ionic server**의 기능이다. 이것은 디바이스에서 사용할 수 없다. 그래서 데스트탑에서 앱을 개발할 때 브라우저의 CORS 문제를 해결하기 위해서 ionic proxy를 사용하고 실제 디바이스에 빌드할 때는 proxy를 제거해야한다. 이것은 개발할 때 빈번하게 발생하는 반복 작업이 될 것이다. Ionic은 **gulp.js**를 사용하여 프레임워크 내에서 개발하는 것을 자동화할 수 있도록 지원하고 있다. 또한 Ionic은 Cordova 기반으로 만들어진 프레임워크이기 때문에 **Cordova Hooks**를 사용할 수 있다. 이 글에서 데스크탑에서 개발할 때 proxy를 사용하기 위해서 정의한 **ionic.project**의 **proxies** 정보를 실제 디바이스 디플로이하기 전에 제거하기 위한 작업을 gulpfile.js에 **remove-proxy**로 task로 등록했다. 마지막으로 Ionic이 cordova를 사용하여 디바이스에 디플로이 하기전에 **prepare** 과정을 마친 후에 **gulp**를 실행하도록 하였다. 그 결과 데스크탑에 브라우저로 개발할 때는 Ionic의 **proxy**를 사용할 수 있고 디바이스에 실행할 때는 자동으로 proxy를 제거하여 사용할 수 있게 되었다. 이 방법은 Ionic의 문서에는 나와있지 않는 방법이다. 이것은 Cordova와 Gulp의 기술이다. Ionic을 개발할 때 좀 더 하이브리드 한 앱을 하이브리드하게 개발할 수 있는 좋은 팁이 되길 기대한다.


## 관련 글

- [Ionic 기반 하이브리드 앱에서 proxy를 사용하여 CORS 문제 해결하기](http://blog.saltfactory.net/ionic/solve-cross-domain-problem-via-ionic-proxy.html)

## 소스코드

https://github.com/saltfactory/ionic-tutorial/releases/tag/proxy-demo

## 참고

1. http://ionicframework.com/docs/cli/test.html
2. http://blog.ionic.io/handling-cors-issues-in-ionic/
3. http://cordova.apache.org/docs/en/edge/guide_appdev_hooks_index.md.html

