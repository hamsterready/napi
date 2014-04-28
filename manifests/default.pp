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


package { "ncurses-dev":
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

