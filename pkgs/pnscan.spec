Name:		pnscan
Version:	1.14.1
Release:	1%{?dist}
Summary:	"Peter's Parallel Network Scanner"

License:	BSD
URL:		https://github.com/ptrrkssn/pnscan
Source0:	https://codeload.github.com/ptrrkssn/%{name}/tar.gz/v%{version}?dummy=/%{name}-%{version}.tar.gz
Prefix:		%{_prefix}
BuildRoot:	%{_tmppath}/%{name}-root

%description
Pnscan is a tool that can be used to survey IPv4 TCP network services.

%prep
%setup -q -n %{name}-%{version}

%build
CFLAGS="$RPM_OPT_FLAGS" ./configure --prefix=%{_prefix} --mandir=%{_mandir} --libdir=%{_libdir} --sysconfdir=/etc
make

%install
[ "$RPM_BUILD_ROOT" != "/" ] && rm -fr "$RPM_BUILD_ROOT"
make DESTDIR="$RPM_BUILD_ROOT" install

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -fr "$RPM_BUILD_ROOT"

%files
%defattr(-,root,root)
%doc README LICENSE TODO
%{_bindir}/pnscan
%{_mandir}/man1/pnscan.1.gz

