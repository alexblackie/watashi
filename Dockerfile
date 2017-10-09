FROM centos:7

RUN yum makecache fast && \
    yum install -y https://repo.blackieops.com/centos/7/ruby-2.4.1-1.el7.centos.x86_64.rpm && \
    yum install -y gcc gcc-c++ make libxml2-devel libxslt-devel rpm-build rpm-sign openssh && \
    yum clean all && rm -fr /var/cache/yum
RUN gem install bundler --no-ri --no-rdoc

# Ensure user that matches jenkins uid is present or things get ugly
RUN useradd -u995 jenkins
