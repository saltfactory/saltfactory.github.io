---
layout: post
title : Ubuntu에 대용량 USB 외장하드디스크 연결하여 사용하기
category : linux
tags : [linux, ubuntu, usb]
comments : true
redirect_from : /260/
disqus_identifier : http://blog.saltfactory.net/260
---

## 서론

Windows의 Plug & Play는 운영체제게 설치된 컴퓨터에 외부 인터페이스를 연결하면 자동으로 인식하여 사용할 수 있도록 하는 기능이다. Windows의 이 기능은 플러그인을 손쉽게 사용할 수 있도록 해 컴퓨터에 대한 특별한 전문 지식이 없어도 쉽게 사용할 수 있도록 도와준다. Ubuntu는 Unix 계열 운영체제중에서 Desktop을 위한 확장 기능이 많이 지원된다. Unbutu에서 USB 외장하드디스크를 연결하여 사용할 때 어떻게 사용할 수 있는지 알아본다.

<!--more-->

## Ubuntu 외장하드디스크 연결

우리는 docker 도입을 하기 위해서 운영체제를 Ubuntu-Server 14.04 LTS 64bit 를 새로 설치하려고 했다. 기존 서버는 Ubuntu 12.04 LTS가 아니라 업데이트 지원도 빨리 끝나버려서 old release에서 업데이트를 해야만 했기 때문에 docker 도입 결정과 함께 이전 운영체제를 업그레이드 하기로 했다. 먼저 기존의 데이터를 백업 하기 위해서 외장 하드 디스크를 USB로 연결해서 `cp`를 하면 되겠지하고 간단히 생각했다. 하지만 Ubuntu에서 USB 외장 하드 디스크가 마운트가 되지 않는 것이다. 그래서 우리는

> ubnutu에서 USB 외장하드디스크 인식되지 않을 때, USB 외장하드디스크를 마운트해서 사용하는 방법에 대해서 알아보기로 한다.

우리가 사용한 외장하드 디스크는 500G IDE를 USB 3.0으로 사용할 수 있는 외장하드 케이스에 연결된 것이다. 우리는 네트워크로 백업을 했지만 USB3.0으로 외장 하드디스크를 사용할 수 있는 방법을 알기 위해서 조사하기 시작했다.

## Ubuntu USB mount

[Ubuntu Mount/USB 공식문서](https://help.ubuntu.com/community/Mount/USB)를 살펴보자. 공식문서에서는 [GNOME](http://www.gnome.org), GUI를 사용하는 방법에 대해서 먼저 설명하고 있지만 우리는 본체와 네트워크 케이블만 연결되어 있는 서버라서 이 방법은 패스했다.

### 수동 마운트
처음 Ubuntu에 외장하드 디스크를 마운트하는 방법을 찾았을 때, 국내 몇개의 사이트에서 방법이 소개되어 있었지만 모두 공식 문서와 같은 내용으로 USB 하드 디스크를 수동으로 `mount` 하는 방법이였다. 방법은 다음과 같다.

먼저 연결된 USB 외장하드디스크를 확인한다.

```
fdisk -l
```

다음은 목록에서 나타나는 USB 외장하드 디스크를 해당하는 포멧으로 마운트를 한다. USB 외장하드디스크가 마운트 되어질 디렉토리를 만든다.

```
mkdir -p /media/external
```

보통 USB 외장하드디스크는 **FAT** 방식이거나 **NTFS** 방식이기 때문에 다음과 같이 할 수 있다. `fdisk -l`에서 USB 외장하드디스크가 `/dev/sdb1`으로 나타났다고 가정하고 살펴보자.

만약 USB 외장하드디스크가 **FAT** 방식일 경우,

```
mount -t vfat /dev/sdb1 /media/external -o uid=1000,gid=1000,utf8,dmask=027,fmask=137
```
만약 USB 외장하드디스크가 **NTFS** 방식일 경우,

```
mount -t ntfs-3g /dev/sdb1 /media/external
```



이 방법은 USB를 연결했을 때 `fdisk -l`로  디스크 목록이 보일때 가능하다. 다시 말해서 USB 외장하드디스크가 인식되어야 한다는 것이다.

> 우리는 `fdisk -l`을 하더라도 USB 외장하드디스크가 목록에서 나타나지 않는 문제를 가지고 있다.

### 자동 마운트
또한 우리는 USB가 인식되면 윈도우즈 처럼 자동으로 USB 외장하드디스크가 마운트되어서 사용할 수 있도록 하는 방법을 찾는 중 Ubuntu 공식 문서에서 찾게되었다.

만약 Ubuntu server 운영체제를 사용하고 있다면 [usbmount](http://packages.ubuntu.com/lucid/usbmount) 패키지를 설치하면 USB에 외장저장매체를 연결하면 자동으로 `mount`가 되어진다.

```
apt-get install usbmount
```

## Kernel 모듈

우리가 사용하는 Linux는 각 벤더마다 linux kenel에 필요한 모듈들을 사용하는데 사용되고 있는 모듈을 살펴보려면 다음과 `cat /proc/modules`를 사용하거나 `lsmod` 명령어를 사용하면 된다. 아래는 `lsmod`를 사용했을 때의 결과 예제이다.

```
Module                  Size  Used by
snd_hda_codec_realtek   255820  1
snd_hda_intel          24140  0
snd_hda_codec          90901  2 snd_hda_codec_realtek,snd_hda_intel
snd_hwdep              13274  1 snd_hda_codec
snd_pcm                80244  2 snd_hda_intel,snd_hda_codec
snd_timer              28659  1 snd_pcm
snd                    55295  6 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
soundcore              12600  1 snd
snd_page_alloc         14073  2 snd_hda_intel,snd_pcm
i915                  450979  1
drm_kms_helper         40745  1 i915
drm                   184133  2 i915,drm_kms_helper
i2c_algo_bit           13184  1 i915
video                  18951  1 i915
lp                     13349  0
ppdev                  12849  0
psmouse                59039  0
serio_raw              12990  0
parport_pc             32111  0
parport                36746  3 lp,ppdev,parport_pc
r8169                  46630  0
```

## UAS module

kenel 모듈 중에 [UAS(USB Attached SCSI](http://en.wikipedia.org/wiki/USB_Attached_SCSI) 가 있다. 이 모듈은 UAS 프로토콜, 다시 말해서 USB 저장매체로 데이터를 전송하는 프로토콜을 구현한 모듈인데 현재 Ubuntu에서는 USB 3.0 일 경우 문제가 있어서 UAS 모듈을 삭제한다. kenel 모듈을 삭제하는 방법은 `rmmod` 명령어를 사용하는 것이다. 다음과 같이 uas 모듈을 삭제할 수 있다.

```
rmmod uas
```

또는 모듈의 **blacklist**를 만들어서 비활성화하는 방법도 있다. kenel 모듈의 blacklist는 `/etc/modeprobe.d`에서 참조하는데 다음과 같이 `blacklist.conf` 파일을 만들고 `uas`를 blacklist로 등록한다.

```
vi /etc/modprobe.d/blacklist.conf
```

```
blacklist uas
```

## exFAT 형식 포맷

이젠 Ubuntu에 USB 외장하드디스크를 연결해서 사용할 수 있는 준비를 모두 마쳤다. 우리는 모든 운영체제에서 Read/Write를 할 수 있게 500G 하드디스크를 **FAT** 형식으로 포맷을 했는데, FAT 형식은 4G 이상 대용량 파일을 저장할 수 없다는 에러를 만나서 [exFAT](http://en.wikipedia.org/wiki/ExFAT) 형식으로 다시 포맷을 했다. Mac OS X (10.9.x) 에서는 NTFS 포멧 형식을 지원하고 있지 않는다. 그리고 Mac OS X에서는 NTFS로 포멧되어진 외장하드디스크는 read only로 마운트가 되어진다. 그래서 우리는 exFAT으로 USB 외장하드디스크를 포맷했다. Mac OS X 에서 USB 외장하드디스크를 포맷하기 위해서는 [Disk Utility](http://en.wikipedia.org/wiki/Disk_Utility)를 상용하면 된다.

![exfat](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/e6a3e566-5f5e-41ba-bfcf-0e0ff36ef0da)


## USB 외장하드디스크 마운트

exFAT으로 포맷되어진 USB 외장하드디스크를 Ubuntu에 연결한다. 그리고 `fdisk -l` 명령어를 실행해보자.
![fdisk](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/e764076c-0dee-405a-b8d9-c92979c75d4a)

처음 우리가 USB 외장하드디스크를 연결해서 `fdisk -l`을 실행했을 때는 디스크 목록에 외장하드디스크가 나타나지 않았는데 이젠 `/dev/sde1` 500G 하드디스크가 목록에 나타나는 것을 볼 수 있다. 우리는 **exFAT**으로 포맷했는데 Ubuntu에서 인식할 때는 **NTFS**로 인식이 되는 것 같다.

우리는 앞에서 `usbmount`를 설치해서 USB 외장 하드디스크가 연결되면 자동으로 `mount` 되도록 했다. 마운트는 USB가 연결되는 순서대로 **/media/usb순번**으로 마운트가 된다. 우리는 첫번째로 USB 외장 하드디스크를 연결해서 마운트를 했기 대문에 `/mnt/usb0`으로 USB 외장 하드디스크가 마운트가 되었다.

```
cd /media/usb0
```

```
touch README.md
```

## 결론

작은 연구소나 개인 사무실, 개인이 연구하거나 개발할 때 PC에 Linux 서버를 설치해서 사용하는 경우가 많다. 때로는 운영하고 있던 서버를 업그레이드하거나 데이터를 백업해야하는 일이 발생한다. 요즘은 Cloud 저장소에 데이터를 백업하거나 또는 원격 서버에 백업을 하는 경우가 많지만, 네트워크 제한이나 특정한 이유로 물리적으로 다른 디스크로 데이터를 백업 받아야하는 경우가 종종 발생한다. 예전에는 하드디스크를 **slave**로  마운트 시켜서 데이터를 백업했지만 최근 USB 외장 하드디스크의 용량이 커지면서 더이상 서버를 뜯어서 하드디스크를 추가로 달아서 백업하지 않고 간단히 USB 외장 하드디스크에 바로 백업할 수 있게 되었다. Linux도 많이 발전하게 되어서 kenel에 다양한 모듈이 지원되면서 간단히 USB를 연결하는 것 만으로 대용량 USB 외장 하드디스크를 바로 사용할 수 있게 되었다. 하지만, Ubuntu에서 외장 하드디스크를 연결하여 사용할 때 버그로 인해서 외장하드 인식이 불가능할 수도 있는데 우리는 `rmmod uas`나 `blacklist uas`를 사용해서 USB 인식의 문제를 수정했다. 또한 대용량 데이터를 백업할 때는 **exFAT** 포멧을 사용하면 된다는 것을  살펴보았다. 느린 네트워크 백업이 답답하거나 디스크 풀 백업을 해야할 경우는 이젠 쉽게 USB 외장 하드디스크를 연결해서 백업해보는 것도 해결책 중에 하나라고 생각한다.

