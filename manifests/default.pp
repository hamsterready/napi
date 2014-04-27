import 'netinstall.pp'

exec { "apt-get update":
  path => "/usr/bin",
}


package { "busybox":
	ensure => present,
    require => Exec["apt-get update"],
}


package { "make":
	ensure => present,
    require => Exec["apt-get update"],
}


package { "patch":
	ensure => present,
    require => Exec["apt-get update"],
}


package { "gcc-multilib":
	ensure => present,
    require => Exec["apt-get update"],
}


package { "g++-multilib":
	ensure => present,
    require => Exec["apt-get update"],
}


package { "ncurses-dev":
	ensure => present,
    require => Exec["apt-get update"],
}


package { "libwww-perl":
	ensure => present,
    require => Exec["apt-get update"],
}

file { "/home/vagrant/bin":
  ensure  => "directory",
  owner => "vagrant",
  mode => 750
}


file { "/home/vagrant/bin/sh":
	ensure => "link",
	target => "/bin/busybox",
}


file { "/home/vagrant/bin/napi.sh":
	ensure => "link",
	target => "/vagrant/napi.sh",
}


file { "/home/vagrant/bin/subotage.sh":
	ensure => "link",
    target => "/vagrant/subotage.sh",
}


puppi::netinstall { "gcc3":
  url => "http://gcc.igor.onlinedirect.bg/old-releases/gcc-3/gcc-3.0.tar.bz2",
  source_filename => "gcc-3.0.tar.bz2",
  source_filetype => ".bz2",
  source_dirname => "gcc",
  extracted_dir => "gcc-3.0",
  destination_dir => "/tmp",
  postextract_command => "export LIBRARY_PATH=/usr/lib/$(gcc -print-multiarch) && export C_INCLUDE_PATH=/usr/include/$(gcc -print-multiarch) && export CPLUS_INCLUDE_PATH=/usr/include/$(gcc -print-multiarch) && /tmp/gcc-3.0/configure --enable-shared --enable-languages=c  --disable-libgcj --disable-java-net --disable-static-libjava && make 2>&1 | tee compilation.log"
}

