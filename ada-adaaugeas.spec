#
# spec file for package ada-adaaugeas
#

%define pagname AdaAugeas
%define libname libadaaugeas
%define soname 0_1_0

Name:           ada-adaaugeas
Version:        0.1.0
Release:        1
Summary:        Ada bindings for AUGEAS library
License:        MIT
Group:          Development/Libraries
URL:            https://github.com/ray2501/AdaAugeas
Source:         %{pagname}-%{version}.tar.gz
BuildRequires:  gcc-ada
BuildRequires:  make
BuildRequires:  augeas-devel

%description
Augeas is a configuration editing tool.
It parses configuration files in their native formats
and transforms them into a tree.

This package is Ada bindings for AUGEAS library.


%package -n %{libname}%{soname}
Summary:        Library files for ada-adaaugeas
Group:          System/Libraries
Obsoletes:      %{libname}%{soname} < %{version}

%description -n %{libname}%{soname}
The %{libname}%{soname} package contains library files for ada-adaaugeas.


%package devel
Summary:        Development files for ada-adaaugeas
Requires:       %{name} = %{version}
Requires:       %{libname}%{soname} = %{version}

%description devel 
The %{name}-devel package contains source code and linking information for
developing applications that use ada-adaaugeas.

%prep
%setup -q -n %{pagname}-%{version}

%build
make PREFIX=/usr LIBDIR=lib64

%install
make DESTDIR=%{buildroot} PREFIX=/usr LIBDIR=lib64 install

%post -n %{libname}%{soname} -p /sbin/ldconfig
%postun -n %{libname}%{soname} -p /sbin/ldconfig

%files -n %{libname}%{soname}
%{_libdir}/*.so.*

%files
%license LICENSE
%doc README.md

%files devel
%{_includedir}/*
%{_libdir}/*.so
%{_libdir}/adaaugeas
%dir /usr/share/gpr
/usr/share/gpr/adaaugeas.gpr

%changelog

