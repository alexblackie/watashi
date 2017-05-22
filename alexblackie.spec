%define webroot /srv/www/alexblackie.com

Name:      alexblackie.com
Version:   %{version}
Release:   1%{?dist}
Summary:   The alexblackie.com website files and configuration.
License:   BSD 3-Clause
Requires:  nginx
BuildArch: noarch

%prep
tar -cf %{_sourcedir}/alexblackie.com.tar \
	--exclude-vcs \
	--exclude=.editorconfig \
	--exclude=Dockerfile.dev \
	--exclude=README.md \
	--exclude=nginx.dev.conf \
	--exclude=nginx.conf \
	--exclude=alexblackie.spec \
	--exclude=rpmbuild \
	../../
cp ../../nginx.conf %{_sourcedir}/nginx.conf

%description
Contains a snapshot of the website files for alexblackie.com.

%install
mkdir -p %{buildroot}%{webroot}
mkdir -p %{buildroot}/etc/nginx/conf.d/
tar -xvf %{_sourcedir}/alexblackie.com.tar -C %{buildroot}%{webroot}
mv %{_sourcedir}/nginx.conf %{buildroot}/etc/nginx/conf.d/alexblackie.com.conf

%files
%{webroot}
/etc/nginx/conf.d/alexblackie.com.conf

%clean
rm %{_sourcedir}/alexblackie.com.tar
rm -fr %{buildroot}
