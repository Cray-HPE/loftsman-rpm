#
# MIT License
#
# (C) Copyright 2021-2023 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
Name:      %(echo $NAME)
License:   MIT License
Summary:   Loftsman CLI
Version:   1.2.0
BuildArch: %(echo $ARCH)
URL:       https://github.com/Cray-HPE/%{name}
# MAINTAINERS: Set this to 1 once the version bumps above 1.2.0
Release:   2
Vendor:    Cray/HPE
Group:     CSM
Source:    %{name}-%{version}.tar.bz2
Provides:  %{name} = %{version}
Requires:  helm >= 3.9.4, helm < 3.9.5

%ifarch %ix86
    %global GOARCH 386
%endif
%ifarch aarch64
    %global GOARCH arm64
%endif
%ifarch x86_64
    %global GOARCH amd64
%endif

%description
Define, organize, and ship your Kubernetes workloads with Helm charts easily.

%prep
%setup -q

%build
PLATFORM_OS=linux PLATFORM_ARCH="%{GOARCH}" LOFTSMAN_VERSION=%{version} ./download.sh

%install
install -d %{buildroot}%{_bindir}
install -p -m 0755 download/%{version}/%{name}-linux-%{GOARCH} %{buildroot}%{_bindir}/%{name}

%files
%{_bindir}/%{name}
%defattr(-,root,root,-)
%doc LICENSE
