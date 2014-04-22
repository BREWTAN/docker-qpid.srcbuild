#!/bin/bash
export ver=0.26
mkdir qpid$ver
cd qpid$ver

svn co http://svn.apache.org/repos/asf/qpid/tags/$ver/qpid/bin
svn co http://svn.apache.org/repos/asf/qpid/tags/$ver/qpid/cpp
svn co http://svn.apache.org/repos/asf/qpid/tags/$ver/qpid/python
svn co http://svn.apache.org/repos/asf/qpid/tags/$ver/qpid/doc
svn co http://svn.apache.org/repos/asf/qpid/tags/$ver/qpid/tools

cd ..
tar cfvz qpid$ver.tar.gz qpid$ver/
rm -rf qpid$ver/
