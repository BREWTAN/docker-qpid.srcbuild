

INSTRUCTION qpid 

FROM brew/centos

MAINTAINER  BrewTan

ENV QVERS 0.26

ADD qpid${QVERS}.tar.gz /opt/

###################
# yum install

RUN yum makecache -y &&\
yum update -y &&\
yum install -y cmake boost-devel libuuid-devel pkgconfig gcc-c++ make ruby help2man doxygen graphviz python-devel perl-devel perl-libs libtool cyrus-sasl-devel nss-devel nspr-devel xqilla-devel xerces-c-devel ruby ruby-devel swig libdb-cxx-devel libaio-devel rpm-build

#####################
# change qpid and then build
RUN  mkdir /opt/qpid${QVERS}/cpp/rel &&  cd /opt/qpid${QVERS}/cpp/rel  \
   && cmake -DCMAKE_BUILD_TYPE=Release  -D CPACK_BINARY_RPM:BOOL=ON ../ \
   && sed -i -e 's/define JRNL_DBLK_SIZE/define JRNL_DBLK_SIZE 512\/\//' \
      -e 's/define JRNL_MAX_NUM_FILES/define JRNL_MAX_NUM_FILES 512\/\//' /opt/qpid${QVERS}/cpp/src/qpid/legacystore/jrnl/jcfg.h \
   && make all install package || echo 'ignore'
#RUN yum install -y rpm-build #&& cd /opt/qpid${QVERS}/cpp/rel && make package || echo 'ignore '
RUN  cd /opt/qpid${QVERS}/python/ && ./setup.py build && ./setup.py install \
   && cd /opt/qpid${QVERS}/tools/ && ./setup.py build && ./setup.py install
RUN cp -rf /opt/qpid${QVERS}/cpp/rel/_CPack_Packages/Linux/RPM/qpid-cpp-${QVERS}-Linux  /rpmbuild/BUILDROOT/qpid-cpp-${QVERS}-1.x86_64/ &&\
   cp /usr/bin/qpid* /rpmbuild/BUILDROOT/qpid-cpp-${QVERS}-1.x86_64/usr/local/sbin/ \
&& mkdir -p /rpmbuild/BUILDROOT/qpid-cpp-${QVERS}-1.x86_64/usr/lib/python2.6/site-packages \
&& cp -rf  /usr/lib/python2.6/site-packages/qpid* /usr/lib/python2.6/site-packages/mllib \
           /rpmbuild/BUILDROOT/qpid-cpp-${QVERS}-1.x86_64/usr/lib/python2.6/site-packages/ \
&& cd /opt/qpid${QVERS}/cpp/rel/ && cp examples/messaging/drain examples/messaging/spout /rpmbuild/BUILDROOT/qpid-cpp-${QVERS}-1.x86_64/usr/local/bin/  \
&& rpmbuild -bb _CPack_Packages/Linux/RPM/SPECS/qpid-cpp.spec \
&& cp /opt/qpid${QVERS}/cpp/rel/_CPack_Packages/Linux/RPM/*.rpm /opt/qpid-cpp-${QVERS}.x86_64.rpm

RUN cd /opt/qpid${QVERS}/cpp/rel && make clean && cd ..&& rm -rf /opt/qpid${QVERS}/cpp/rel


RUN yum clean all

ADD qpidd.conf /usr/local/etc/qpid/qpidd.conf
ADD supervisord.conf /etc/supervisord.conf

RUN mkdir /var/log/qpid/

EXPOSE 22 5672

#######################
# setup default env

ADD envset.sh /usr/bin/envset.sh
ENV QPID_DATA_DIR /opt/qpidstore
ENV QPID_LOG_ENABLE info+
ENV QPID_WORKER_THREADS 10
ENV QPID_NUM_JFILES     64
ENV QPID_JFILE_SIZE     16
ENV QPID_HA_CLUSTER     no
ENV QPID_HA_BROKERS_URL 127.0.0.1

CMD ["/usr/bin/supervisord"]
