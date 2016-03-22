---
layout: post
title: HP ProLiant 서버에 RAID 1으로 Ubuntu 10.4 LTS , HP Sotware 설치 후 RAID 상태 정보 확인
category: ubuntu
tags: [ubuntu, raid, hp]
comments: true
redirect_from: /68/
disqus_identifier : http://blog.saltfactory.net/68
---

## 서론

HP ProLiant를 들여오기 전에 Ubuntu, CentOS, FreeBSD 셋 중에서 어떤 운영체제를 선택할지에 대해서 많은 고민을 했다. Ubuntu를 접하기 전에는 거의 모든 개발용 데스크탑에 CentOS를 설치해서 개발을 했는데, Ubuntu를 사용하고 난 뒤 개발용 서버들은 모두 Ubuntu로 교체를 했다. 이유는 매우 활성화된 커뮤니티와 지속적이고 빠른 라이브러리들의 업데이트 때문이였다. 하지만 내심 이번 서버는 FreeBSD를 설치하고 싶었다. Advanced TCP 스택을 사용해보고 싶어서 이기도 했고, Mac을 사용하면서 port가 얼마나 훌륭한 것인지를 알았기 때문이다. 하지만 실상 64bit RAID 구성으로 서버를 구축하고 부족한 하드 용량을 다른 서버들로 분산하고 백업용 미러까지 생각하니 개발과 동일한 운영체제를 선택하는게 가장  좋을거라 생각하고 Ubuntu를 선택했다. 또하나 생각 해야할 것이 64bit FreeBSD에 대한 안정성의 자료를 많이 찾지 못해서이기도 했다. 그래서 첫번째 운영을 ubuntu로 서비스해보고 이후에 안정화 테스트를 충분히 가진후에 마이그레이션할 생각이기도 했다. 뿐만 아니라 RAID 구성을 하는데 HP에서 제공하는 공식 관리 소프트웨어를 사용하고 싶어서 Ubuntu를 생각한 것이도 하였다.
<!--more-->

현재 Ubuntu는 11.10까지 릴리즈되었고 다운로드 받을 수 있다. 나중에 알게된 것인데 standard 버전은 1년에 한번씩 업데이트가 일어나고 지원이 중단된다는 것이다. 만약 오랜 기간의 업데이트 지원을 받으려면 LTS를 설치해야 한다는 것을 알았다. 그래서 먼저 11.10을 설치 했다가 다시 10.4.3 LTS를 다운받아서 설치했다. Ubuntu 사이트에서 직접 다운받으면 엄청나게 오래 걸리니까 국내 ftp 서버를 사용하면 빨리 받을 수 있다. 그중에서도 http://ftp.daum.net을 추천한다. Daum에서 이렇게 오픈소스를 배포해주는 서버를 공개해주는 것에 대해서 너무나 고마워하고 있다.

파일은 다음과 같이 두개의 iOS 파일이 필요하다.
하나는 Ubuntu-10.04.3-server-amd64.ios 이고 하나는 HP_ProLiant_Value_Add_Software-8.70-10-6.iso 이다.
두번재 이미지는 일종의 HP ProLiant의 관리자 소프트웨어인데 공식적으로 11.10 지원된다고 한다. 잦은 업데이트를 선호하는 사용자는 11.10에 설치하여도 무방하겠다. 다운로드는 다음 링크를 참조하면 된다 ([Ubuntu용 HP 소프트웨어 다운로드](http://h20000.www2.hp.com/bizsupport/TechSupport/SoftwareDescription.jsp?lang=en&cc=us&prodTypeId=15351&prodSeriesId=4091412&swItem=MTX-b3d56629ca784c84979546f127&prodNameId=4091432&swEnvOID=4096&swLang=8&taskId=135&mode=3))

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/8e223286-dfd1-44c8-b7d3-682d1b011e3a)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/fa978771-8a55-4e45-be50-da86821d0738)

두번째 파일을 설치하지 않아도 ubuntu를 설치하는데 전혀 문제가 되지 않는다. 하지만 HP의 RAID 구성을 확인하기 위해서 필요한 hpacucli가 필요한 이것을 설치할수 있게 도와준다. 물론 인터넷에 검색해보면 이미지 없이 바로  apt-get으로 설치하는 방법도 소개한 블로그를 볼 수 있을것이다.

조립형 PC나 HP middle tower desktop에만 리눅스를 설치하고 실제 Array Controller가 지원하는 ProLiant 급 서버는 처음 설치해보는 것이기 때문에 RAID 구성을 하는 것에 대해서 걱정을했는데, HP ProLiant는 디폴트로 HDD가 2개 설치되면 RAID 1로 잡히고,  4개면 RAID 5로 구성되기 때문에 RAID 1으로 설치하기 위해서 Smart Start를 넣어서 RAID를 구성하고 하지 않아도 된다. 특히 Linux를 설치할때는 Smart Start를 사용하는 것이 아니라 ROM base 설정을 해야하다. Smart Start에서 지원하는 운영체제는 윈도우만 가능하기 때문이다.

위에서 다운받은 이미지들은 CD로 구워서 각각 설치시 사용하면 된다. 우선 Ubuntu 설치 CD를 가지고 설치하면 된다. 워낙 요즘은 GUI가 좋기 때문에 설치에 따른 설명은 따로하지 않을 것이다. 하지만 보통 일반 HDD에 설치하고는 다르게 RAID로 구성되어 있는 (여기서 말하는 RAID 구성은 HP에서 제공해주는 Array Controller가 관리하는 물리적인 RAID를 말한다. 왜냐하면 Ubuntu에서는 Software RAID 구성을 지원하기 때문이다.) HDD의 파티셔닝하는 방법은 약간 틀리다. 설치에 사용한 HP DL380는 SATA DISK가 2개 설치되어 있는데 실제적으로 논리적으로는 하나만 보이는 것이다. 아니 더 정확하게 말하면 하나의 DISK는 HP Array Controlller 로 잡혀있고 다른 DISK에 파티셔닝을 할 수 있다. 그렇게 때문에 HP Array Controller는 손대지 않고 다른 DISK에서 설치를하면 /dev/cciss/c0d0 에 파티셔닝이 진행이 된다. 메뉴얼 파티셔닝을 완료후 실체 파티셔닝이 일어날때 약간의 시간이 걸리는데 이때 Array Controller가 미러링을할 준비를 하고 DISK1에 설정하는 내용을 동일하게 DISK2에도 적용하기 시작한다. 그래서 잘 살펴보면 DISK1과 DISK2의 LED가 거의 동시에 깜빡거리는 것을 확인할 수 있다. 나머지 설치과정은 매우 단순하게 GUI에서 요구하는대로 네트워크 설정과 패지키 설정 기본 설치프로그램등을 설치하면 된다. 서버용이기 때문에 아주 간단한 OpenSSH-Server만 설치하고 나머지는 필요할때마다 apt-get으로 설치하기 위해서 모두 디폴트로 넘어갔다. 설치가 와료가 되면 리부팅되면 Ubuntu-Server가 시행된다.

다음은 RAID의 정보를 보고 싶을때 사용할 hpacucli을 설치할 차례이다. 두번재 이미지를 구운 CD를 넣고 마운트를 시킨다. 다른 리눅스는 /mnt를 사용하여 마운트를 시키는데 Ubuntu는 다음과 같이 하면 자동으로 마운트되어서 sources 목록으로 인식이 되어 버린다.

```
apt-cdrom add
```

그리고 패키지들을 설치하면 되는데 두번째 이미지에 들어 있는 것 중에서 hpacucli를 설치한다.

```
apt-get install hpacucli
```

HP Smart Array Controller가 지원되는지 설치되어 있는지 확인해보려면 다음과 같이 lspci를 이용한다.

```
lspci -nn | grep Array
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/7c384b65-3162-4c20-a1d5-249bcd346cc2)

다음은 디바이스 노드들을 살펴보자. 우리가 흔히 설치하는 RAID 구성 없이 일반 HDD만 여러개 일경우는 /dev/hda, /dev/hdb 나 /dev/sda, /dev/sdb 이런식으로 디바이스 노드가 추가된다. 히자만 RAID 구성을하면 /dev/c0d0, /dev/c0d1 이런식으로 된다.

```
ls -lah /dev/cciss
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/e1189da4-bebe-4f03-9b94-31fa3b5efdd3)

이제 모든 Controller들을 보자. 컨트롤러에 대한 정보를 보기 위해서는 우리가 설치한 hpacucli를 사용해야한다. 결과는 다음과 같다. sn(시리얼번호)가 있어서 캡쳐 대신에 텍스트만 복사해서 넣었다.

```
hpacucli controller all show
```

```
Smart Array P410i in Slot 0 (Embedded)   (sn: 시리얼번호)
```

그리고 이 Slot 0에 설치되어 있는 논리드리이버 노드들의 상태를 확인하기 위해서 다음과 같이 한다.

```
hpacucli ctrl slot=0 logicaldrive all show status
```

여기서 보면 RAID 1로 구성되어 있는 하나의 logicaldrive 1을 확인할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/07d35001-bdfd-4f56-a784-5d0172005000)

이제 실제 물리적인 DISK의 상태를 확인하기 위해서 다음 명령어를 실행 한다. 첫번째 bay의 DISK 1와 두번째 bay의 DISK 2 의 상태를 한눈에 확인할 수 있다.

```
phacucli ctrl slot=0 pd all show status
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/8912033d-f389-4bc1-a1cf-d452d1fd556d)

전체적인 요약을 보기 위해서는 다음과 같이 한다.

```
hpacucli ctrl slot=0 show config
```

```
Smart Array P410i in Slot 0 (Embedded)    (sn: 시리얼번호)

array A (SAS, Unused Space: 0 MB)

logicaldrive 1 (931.5 GB, RAID 1, OK)

physicaldrive 1I:1:1 (port 1I:box 1:bay 1, SAS, 1 TB, OK)
physicaldrive 1I:1:2 (port 1I:box 1:bay 2, SAS, 1 TB, OK)

SEP (Vendor ID 벤더 아이디, Model  모델명) 250 (WWID: 아이디)
```

자세히 보기 위해서는 다음과 같이 한다.

```
hpacucli ctrl slot=0 show config detail
```

디테일 정보를 보면 알겠지만 RAID 1로 구성되어 있고 RAID 1의 특징대로 두개의 DISK가 Mirror Group으로 만들어져 있는 것을 확인 할 수 있다.

```
Smart Array P410i in Slot 0 (Embedded)
   Bus Interface: PCI
   Slot: 0
   Serial Number: 시리얼번호
   Cache Serial Number: 시리얼번호
   RAID 6 (ADG) Status: Disabled
   Controller Status: OK
   Hardware Revision: Rev C
   Firmware Version: 3.66
   Rebuild Priority: Medium
   Expand Priority: Medium
   Surface Scan Delay: 15 secs
   Surface Scan Mode: Idle
   Queue Depth: Automatic
   Monitor and Performance Delay: 60 min
   Elevator Sort: Enabled
   Degraded Performance Optimization: Disabled
   Inconsistency Repair Policy: Disabled
   Wait for Cache Room: Disabled
   Surface Analysis Inconsistency Notification: Disabled
   Post Prompt Timeout: 0 secs
   Cache Board Present: True
   Cache Status: OK
   Accelerator Ratio: 100% Read / 0% Write
   Drive Write Cache: Disabled
   Total Cache Size: 256 MB
   No-Battery Write Cache: Disabled
   Battery/Capacitor Count: 0
   SATA NCQ Supported: True

   Array: A
      Interface Type: SAS
      Unused Space: 0 MB
      Status: OK

      Logical Drive: 1
         Size: 931.5 GB
         Fault Tolerance: RAID 1
         Heads: 255
         Sectors Per Track: 32
         Cylinders: 65535
         Strip Size: 256 KB
         Status: OK
         Array Accelerator: Enabled
         Unique Identifier: 아이디
         Disk Name: /dev/cciss/c0d0
         Mount Points: /boot 9.3 GB, / 899.8 GB
         OS Status: LOCKED
         Logical Drive Label: 라벨
         Mirror Group 0:
            physicaldrive 1I:1:1 (port 1I:box 1:bay 1, SAS, 1 TB, OK)
         Mirror Group 1:
            physicaldrive 1I:1:2 (port 1I:box 1:bay 2, SAS, 1 TB, OK)

      physicaldrive 1I:1:1
         Port: 1I
         Box: 1
         Bay: 1
         Status: OK
         Drive Type: Data Drive
         Interface Type: SAS
         Size: 1 TB
         Rotational Speed: 7200
         Firmware Revision: HPD1
         Serial Number: 시리얼번호
         Model:   모델명
         Current Temperature (C): 43
         Maximum Temperature (C): 52
         PHY Count: 2
         PHY Transfer Rate: 6.0GBPS, Unknown

      physicaldrive 1I:1:2
         Port: 1I
         Box: 1
         Bay: 2
         Status: OK
         Drive Type: Data Drive
         Interface Type: SAS
         Size: 1 TB
         Rotational Speed: 7200
         Firmware Revision: HPD3
         Serial Number: 시리얼번호
         Model: HP      모델명
         Current Temperature (C): 42
         Maximum Temperature (C): 51
         PHY Count: 2
         PHY Transfer Rate: 6.0GBPS, Unknown

   SEP (Vendor ID 벤더 아이디, Model  모데명) 250
      Device Number: 250
      Firmware Version: RevC
      WWID: 아이디
      Vendor ID: 벤더아이디
      Model:  모델명  
```

## 결론

Ubuntu는 처음 Desktop을 위해서 만들어졌고 그 유명세가 더해졌지만 Server환경에 최적화한 Ubuntu-Server 버전도 있다. 그리고 Ubuntu는 많은 communicator와  committer가 있기 때문에 드이라브 지원 및 라이브러리 업데이트가 매우 빠른편이다. 그리고 HP와 같은 서버에서도 공식적인 툴과 소프트웨어를 제공해주고 있다. 여기 예는 hpacucli을 이용해서 cli 환경만 소개했지만 HP sotware 안에는 웹으로 디시크를 관리할 수 있는 HP System management도 제공하고 있다. 웹 환경으로 관리하는 방법은 다음 기회에 포스팅할 계획이다.

