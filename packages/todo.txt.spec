Name: todo.txt	
Version: 2.9	
Release: 39
Summary: The todo.txt CLI.	

License: GPLv3 (http://www.gnu.org/copyleft/gpl.html)	
URL: http://todotxt.com/ 		
Source0: todo.txt_cli-%{version}.%{release}.tar.gz	
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

Requires: sed >= 4.1.4, grep >= 2.5.1

%description
TODO.TXT Command Line Interface
If you’ve got a file called todo.txt on your computer right now, you’re in the right place. Countless software applications and web sites can manage your to-do list with all sorts of bells and whistles. But if you don’t want to depend on someone else’s data format or someone else’s server, a plain text file is the way to go.

Problem is, you don’t want to launch a full-blown text editor every time you need to add an item to your to-do list, or mark one that’s already there as complete. With a simple but powerful shell script called todo.sh, you can interact with todo.txt at the command line for quick and easy, Unix-y access.

%prep
%setup -q -c


%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/opt/todo.txt
install -m 755 %{name}_cli-%{version}.%{release}/todo.sh %{buildroot}/opt/todo.txt
install -m 744 %{name}_cli-%{version}.%{release}/todo.cfg %{buildroot}/opt/todo.txt
mkdir -p %{buildroot}/etc/bash_completion.d
install -m 644 %{name}_cli-%{version}.%{release}/todo_completion %{buildroot}/etc/bash_completion.d/todo

%clean
rm -rf %{buildroot}

%post
ln -s /opt/todo.txt/todo.sh /usr/bin/todo

%preun
rm -f /usr/bin/todo

%postun
rmdir /opt/todo.txt

%files
%defattr(-,root,root,-)
%doc
/opt/todo.txt/*
/etc/bash_completion.d/*
%changelog

