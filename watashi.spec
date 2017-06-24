%define webroot /srv/watashi

Name:      watashi
Version:   1.0
Release:   1%{?dist}
Summary:   The application that powers alexblackie.com.
License:   BSD 3-Clause
BuildArch: x86_64
Requires: ruby >= 2.4.0

%pre
/usr/bin/getent group watashi || /usr/sbin/groupadd -r watashi
/usr/bin/getent passwd watashi || /usr/sbin/useradd -r -d /srv/watashi -g watashi -s /sbin/nologin watashi

%postun
if [ "$1" = "1" ]; then
  # "1" means upgrade, not uninstall.
  systemctl restart watashi
fi

%prep
bundle install --deployment --binstubs
tar -cf %{_sourcedir}/watashi.tar \
	--exclude-vcs \
	--exclude=README.markdown \
	--exclude=watashi.spec \
	--exclude=rpmbuild \
  --exclude=watashi.service \
	../../

%description
Deploys the Watashi application (the software behind alexblackie.com).

%install
mkdir -p %{buildroot}%{webroot}
mkdir -p %{buildroot}/etc/systemd/system

cp ../../watashi.service %{buildroot}/etc/systemd/system/watashi.service

tar -xf %{_sourcedir}/watashi.tar -C %{buildroot}%{webroot}

%files
%{webroot}
/etc/systemd/system/watashi.service

%clean
rm %{_sourcedir}/watashi.tar
rm -fr %{buildroot}
