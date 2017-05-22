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
	--exclude=alexblackie.spec \
	--exclude=rpmbuild \
	../../

%description
Contains a snapshot of the website files for alexblackie.com.

%install
mkdir -p %{buildroot}%{webroot}
tar -xvf %{_sourcedir}/alexblackie.com.tar -C %{buildroot}%{webroot}

%files
%{webroot}

%clean
rm %{_sourcedir}/alexblackie.com.tar
rm -fr %{buildroot}
