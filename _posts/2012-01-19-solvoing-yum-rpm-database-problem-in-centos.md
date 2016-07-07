---
layout: post
title: CentOS에서 rpm 데이터베이스 문제로 yum을 사용할 수 없을 때
category: linux
tags: [linux, centos, rpm, yum]
comments: true
redirect_from: /96/
disqus_identifier : http://blog.saltfactory.net/96
---

## 서론

CentOS는 enterprise 오픈소스 리눅스 서버이다. redhat의 서비스와 소프트웨어를 사용할 수 있다는게 가장 큰 강점이고 안정성 또한 훌륭한 서버이다. 학생들은 Fedora를 많이 사용하겠지만 실상 서비스를 운영하다보면 업데이트를 자주하는 운영체제보다는 안전한 운영체제가 더 좋기 때문에 한때 Oracle서버를 운영하기 위해서 CentOS를 이용했었다. 아직도 CentOS는 오픈 소스 서버로서 인기 있는 운영체제중에 하나이다. CentOS는 Ubuntu의 apt와 같은 패키지 관리 툴이 있는데 yum 이라는 것을 사용한다. apt도 `sources.list`에 리파지토리를 등록하여 사용하듯이 yum 또한 리파티토리를 사용해서 관련 패키지를 쉽게 다운받고 설치하고 업데이트하거나 삭제할 수 있다.

<!--more-->

## RPM 데이터베이스 문제

CentOS에서 가끔 yum을 사용하다가 갑지가 yum이 이상하게 사용중에 에러가 발생할 때가 있다. yum은 rpm 패키지를 관리하는데 이 때 rpm 패키지에 관련된 정보를 사용하는 데이터베이스에 이상이 생겨서 발생하는 문제라는 것을 CentOS 커뮤니티에서 찾아볼 수 있었다. 다음 링크에가면 이 문제애 대한 thread를 확인할 수 있다. http://www.centos.org/modules/newbb/viewtopic.php?topic_id=20237

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/fd3fdffd-0cf7-4887-a98e-7835d30d785d)

```
Traceback (most recent call last):
  File "/usr/bin/yum", line 29, in ?
    yummain.user_main(sys.argv[1:], exit_code=True)
  File "/usr/share/yum-cli/yummain.py", line 229, in user_main
    errcode = main(args)
  File "/usr/share/yum-cli/yummain.py", line 145, in main
    (result, resultmsgs) = base.buildTransaction()
  File "/usr/lib/python2.4/site-packages/yum/__init__.py", line 647, in buildTransaction
    (rescode, restring) = self.resolveDeps()
  File "/usr/lib/python2.4/site-packages/yum/depsolve.py", line 704, in resolveDeps
    for po, dep in self._checkFileRequires():
  File "/usr/lib/python2.4/site-packages/yum/depsolve.py", line 939, in _checkFileRequires
    if not self.tsInfo.getOldProvides(filename) and not self.tsInfo.getNewProvides(filename):
  File "/usr/lib/python2.4/site-packages/yum/transactioninfo.py", line 414, in getNewProvides
    for pkg, hits in self.pkgSack.getProvides(name, flag, version).iteritems():
  File "/usr/lib/python2.4/site-packages/yum/packageSack.py", line 300, in getProvides
    return self._computeAggregateDictResult("getProvides", name, flags, version)
  File "/usr/lib/python2.4/site-packages/yum/packageSack.py", line 470, in _computeAggregateDictResult
    sackResult = apply(method, args)
  File "/usr/lib/python2.4/site-packages/yum/sqlitesack.py", line 861, in getProvides
    return self._search("provides", name, flags, version)
  File "/usr/lib/python2.4/site-packages/yum/sqlitesack.py", line 43, in newFunc
    return func(*args, **kwargs)
  File "/usr/lib/python2.4/site-packages/yum/sqlitesack.py", line 837, in _search
    for pkg in self.searchFiles(name, strict=True):
  File "/usr/lib/python2.4/site-packages/yum/sqlitesack.py", line 43, in newFunc
    return func(*args, **kwargs)
  File "/usr/lib/python2.4/site-packages/yum/sqlitesack.py", line 586, in searchFiles
    self._sql_pkgKey2po(rep, cur, pkgs)
  File "/usr/lib/python2.4/site-packages/yum/sqlitesack.py", line 470, in _sql_pkgKey2po
    pkg = self._packageByKey(repo, ob['pkgKey'])
  File "/usr/lib/python2.4/site-packages/yum/sqlitesack.py", line 413, in _packageByKey
    po = self.pc(repo, cur.fetchone())
  File "/usr/lib/python2.4/site-packages/yum/sqlitesack.py", line 68, in __init__
    self._read_db_obj(db_obj)
  File "/usr/lib/python2.4/site-packages/yum/sqlitesack.py", line 94, in _read_db_obj
    setattr(self, item, _share_data(db_obj[item]))
TypeError: unsubscriptable object
```

## RPM 데이터베이스 삭제

해결 방법은 기존의 rpm 데이터베이스를 삭제하고 다시 rebuild 해주면 되는 것이다. 아래 순서대로 `yum clean`을 하고 rpm 데이터베이스 삭제후 rpm 데이터베이스를 리빌드하고 마지막으로 `yum update`를 해주면 다시 yum을 이용해서 정상적으로 패키지 관리를 할 수 있게 된다.

```
yum clean all
```

```
rm -rf /var/lib/rpm/__db*
```

```
rpm --rebuilddb
```

```
yum update
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/04d56e2b-4ff9-4bc8-960b-ef2a139ab40d)


