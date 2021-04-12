Name:      loftsman
License:   MIT License
Summary:   Loftsman CLI
Version:   %(./loftsman --version | awk '{print $3}' | tr '-' '~')
URL:       https://github.com/Cray-HPE/loftsman
Release:   %(echo ${BUILD_METADATA})
Vendor:    Cray/HPE
Group:     CSM
Source:    %{name}-%{version}.tar.gz

BuildRequires:  gcc

%description
Define, organize, and ship your Kubernetes workloads with Helm charts easily

%prep
%setup -n %{name}-%{version} -q

%install
install -d %{buildroot}%{_bindir}
install -p -m 0755 loftsman %{buildroot}%{_bindir}/loftsman
install -p -m 0755 helm %{buildroot}%{_bindir}/helm

%files
%defattr(-,root,root,-)
%doc LICENSE
%{_bindir}/loftsman
%{_bindir}/helm

%changelog
