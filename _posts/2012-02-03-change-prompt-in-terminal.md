---
layout: post
title: 리눅스 터미널 프롬프트 정보와 색상 변경하기
category: linux
tags: [unix, linux, prompt, terminal]
comments: true
redirect_from: /99/
disqus_identifier : http://blog.saltfactory.net/99
---

## 서론

유닉스기반 운영체제를 사용한다면 터미널(terminal)을 가장 많이 사용할 것이다. 이번 포스트에서는 터미널의 정보와 색상 정보를 어떻게 변경하여 사용하는지에 대해서 소개한다.

<!--more-->

## Prompt 기본 표현

터미널을 사용할때 프롬프트(Prompt)는 많은 정보를 포함할 수 있다. bash shell 에서 프롬프트는 `$PS1`이라는 shell 변수에 들어있다. 다음은 Mac의 터미널을 열면 기본적으로 나타나는 프롬프트이다. `$PS1`에 어떤 정보가 저장되어 있는지 확인하기 위해서 `$PS1` 변수를 echo 하면 다음과 같이 나타난다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d5d69554-a43b-4e6f-98fd-66f800153d77)

* `\h` 는 현재의 호스트의 이름(hostname)을 나타내는 것이다.
* `\W` 는 현재의 위치의 디렉토리(Working Directory)를 나타내는 것이다.
* `\u` 는 현재의 로그인된 사용자 (user name)을 나타내는 것이다

Mac에서 디퐅트 프롬프트는 다음 코드 들이 저장되어 있다.

```
\h:\W \u\$
```

이 코드는은 다음과 같은 뜻을 나타내고 있는 것이다.

```
{호스트이름}:{현재 디렉토리} {로그인된 사용자}$
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/3d456f9d-7fa4-44cb-9460-0493d7e8dc88)

만약 프롬프트에 현재의 시간을 나타내고 싶으면 `\t` 를 사용하면 된다. 다음 예는 `({현재시간}) {로그인된 사용자}$` 를 나타내려고 할때이다.

```
export PS1="(\t) \u$ "
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f6f02332-74ce-4b75-b533-fb629d93e2c0)

## Prompt 코드 정보  

프롬프트에 들어갈 수 있는 코드는 다음과 같다.

* \a : an ASCII bell character (07)
* \d : the date in "Weekday Month Date" format (e.g., "Tue May 26")
* \D{format} :	the format is passed to strftime(3) and the result is inserted into the prompt string; an empty format results in a locale-specific time representation. The braces are required
* `\e` : an ASCII escape character (033)
* `\h` : the hostname up to the first '.'
* `\H` : the hostname
* `\j` : the number of jobs currently managed by the shell
* `\l` : the basename of the shell’s terminal device name
* `\n` : newline
* `\r` : carriage return
* `\s` : the name of the shell, the basename of $0 (the portion following the final slash)
* `\t` : the current time in 24-hour HH:MM:SS format
* `\T` : the current time in 12-hour HH:MM:SS format
* `\@` : the current time in 12-hour am/pm format
* `\A` : the current time in 24-hour HH:MM format
* `\u` : the username of the current user
* `\v` : the version of bash (e.g., 2.00)
* `\V` : the release of bash, version + patch level (e.g., 2.00.0)
* `\w` : the current working directory, with $HOME abbreviated with a tilde
* `\W` : the basename of the current working directory, with $HOME abbreviated with a tilde
* `\!` : the history number of this command
* `\#` : the command number of this command
* `\$` : if the effective UID is 0, a #, otherwise a $
* `\nnn` : the character corresponding to the octal number nnn
* `\\` : a backslash
* `\[` : begin a sequence of non-printing characters, which could be used to embed a terminal control sequence into the prompt
* `\]` : end a sequence of non-printing characters

위의 코드와 문자열, 숫자, 특수 기호를 조합하여 자신에 맞는 프로프트를 만들어 낼 수 있다. 터미널에서 작업을 하다보면 프롬프트와 command(명령어) 하나의 문자인 것 처럼 보여서 구분이 되지 않을 때가 있을 수도 있다. 그래서 호스트 이름과 디렉토리 이름 그리고 현재 로그인된 사용자의 이름을 구분되어지면 좋겠다고 생각할 것이다. 이 때, 위의 코드 처럼 색상을 지정하는 코드도 존재한다.

## Prompt 색상 정보

* `0;30` : Black
* `0;34` : Blue
* `0;32` : Green
* `0;36` : Cyan
* `0;31` : Red
* `0;35` : Purple
* `0;33` : Brown
* `0;34` : Blue
* `0;32` : Green
* `0;36` : Cyan
* `0;31` : Red
* `0;35` : Purple
* `0;33` : Brown
* `\e[` : Start color scheme
* `x;y` : Color pair to use (x;y)
* `$PS1` : is your shell prompt
* `\e[m` : Stop color scheme

만약 프롬프트를 모두 빨간 색으로 하고 싶으면 다음과 같이 하면 된다.

```
export PS1="\e[0;31m[\u@\h \W]\$ \e[m "
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d54e1989-988f-4884-a949-8ad6e24ce33f)


색상 정보를 이렇게 복잡한 식으로 넣었서 사용한다면 작성하기도 어렵고 혼란스럽게 된다. 그래서 다음과 같이 색상코드만 따로 변수에 만들어서 사용한다. 다음 코드를 `~/.bashrc` 나 `~/.profile`에 저장한다.

```
# define colors
C_DEFAULT="\[\033[m\]"
C_WHITE="\[\033[1m\]"
C_BLACK="\[\033[30m\]"
C_RED="\[\033[31m\]"
C_GREEN="\[\033[32m\]"
C_YELLOW="\[\033[33m\]"
C_BLUE="\[\033[34m\]"
C_PURPLE="\[\033[35m\]"
C_CYAN="\[\033[36m\]"
C_LIGHTGRAY="\[\033[37m\]"
C_DARKGRAY="\[\033[1;30m\]"
C_LIGHTRED="\[\033[1;31m\]"
C_LIGHTGREEN="\[\033[1;32m\]"
C_LIGHTYELLOW="\[\033[1;33m\]"
C_LIGHTBLUE="\[\033[1;34m\]"
C_LIGHTPURPLE="\[\033[1;35m\]"
C_LIGHTCYAN="\[\033[1;36m\]"
C_BG_BLACK="\[\033[40m\]"
C_BG_RED="\[\033[41m\]"
C_BG_GREEN="\[\033[42m\]"
C_BG_YELLOW="\[\033[43m\]"
C_BG_BLUE="\[\033[44m\]"
C_BG_PURPLE="\[\033[45m\]"
C_BG_CYAN="\[\033[46m\]"
C_BG_LIGHTGRAY="\[\033[47m\]"
```

호스트이름과 디렉토리 정보를 각각 다른 색상으로 나타내고 싶으면 다음과 같이 한다.

```
export PS1="$C_CYAN\h:$C_YELLOW\W \$$C_DEFAULT "
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/5bfe330e-ebef-4e8b-bec2-a1998825aed2)
이제 호스트이름 디렉토리 그리고 명려어의 색상을 모두 자신이 원하는대로 변경할 수 있게 되었다.

## 참조

1. http://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
2. http://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
3. http://apple.stackexchange.com/questions/9821/can-i-make-my-mac-os-x-terminal-color-items-according-to-syntax-like-the-ubuntu


