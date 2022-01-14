Name:      loftsman
License:   MIT License
Summary:   Loftsman CLI
Version:   1.2.0
URL:       https://github.com/Cray-HPE/loftsman
Release:   %(echo ${BUILD_METADATA})
Vendor:    Cray/HPE
Group:     CSM
Provides:  loftsman = %{version}
Source0:   download.sh
BuildRequires: coreutils
BuildRequires: jq-1.6
BuildRequires: wget

%description
Define, organize, and ship your Kubernetes workloads with Helm charts easily

%build
cp %{SOURCE0} ./
LOFTSMAN_VERSION=%{version} ./download.sh

%install
install -d %{buildroot}%{_bindir}
install -p -m 0755 loftsman %{buildroot}%{_bindir}/loftsman
install -p -m 0755 helm %{buildroot}%{_bindir}/helm

%files
%defattr(-,root,root,-)
%doc LICENSE
%{_bindir}/loftsman
%{_bindir}/helm
