---
layout: post
title : Ubuntu에 IPv6 비활성화 설정
category : ubuntu
tags : [ubuntu, linux, ipv6, network]
comments : true
redirect_from : /70/
disqus_identifier : http://blog.saltfactory.net/70
---

## 서론

요즘 운영체제는 모두 IPv6를 지원하고 있지만 현재는 IPv4만 사용하고 있기 때문에 IPv4와 IPv6를 동시에 사용해서 시스템의 성능을 낮추기 보다는 IPv6 설정을 비활성화하는 것이 서버 성능 향상에 도움이 된다.
<!--more-->

Ubuntu에서 IPv6 기능을 비활성화 하는 방법은 Ubuntu의 시스템 설정을 담당하는 /etc/sysctl.conf에다 IPv6를 비활성화 한다고 추가해주면 된다.
우선 현재 시스템의 IPv6 기능이 활성화되어 있는지 비활성화 되어 있는지 확인하기 위해서 disable_ipv6 파일을 살펴보자.

```
sudo cat /proc/sys/net/ipv6/conf/all/disable_ipv6
```

만약에 0 이 출력되면 현재 IPv6 기능이 활성화 되어 있다는 것이다. 즉 IPv6 기능을 비화성화하는 작업을 해야 한다는 의미이기도 하다. 하지만 향후 IPv6가 대중화되고 시스템에서 IPv6 기능을 사용한다면 이 비활성화 작업을 다시 활성화시키는 작업으로 진행하면 된다.
IPv6를 비활성화하기 위해서 sysctl.conf 파일에 다음 파라미터를 추가한다.

```
sudo vi /etc/sysctl.conf
```

```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

저장하고 나와서 시스템 컨트롤 파일을 다시 리로드해준다.

```
sudo sysctl -p
```

다시 disable_ipv6 파일을 확인해서 1이 출력되면 IPv6 기능을 비활성화하는 작업이 성공적으로 설정된 것이다.

```
sudo cat /proc/sys/net/ipv6/conf/all/disable_ipv6
```

