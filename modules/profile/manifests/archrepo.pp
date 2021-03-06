class profile::archrepo {
  package {'nginx':
    ensure => latest
  }

  service {'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx'],
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    content => template('data/archrepo/nginx.conf.epp'),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/sites-enabled':
    ensure => directory,
  } ->
  file { '/etc/nginx/sites-available':
    ensure => directory,
  } ->
  file { '/etc/nginx/sites-available/arch.repo.alan-jenkins.com.conf':
    ensure  => file,
    content => template('data/archrepo/arch.repo.alan-jenkins.com.conf.epp'),
    require => Package['nginx'],
    notify  => Service['nginx'],
  } ->
  file { '/etc/nginx/sites-enabled/arch.repo.alan-jenkins.com.conf':
    ensure  => link,
    target  => '/etc/nginx/sites-available/arch.repo.alan-jenkins.com.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  group { 'archrepo':
    ensure => present,
  } ->
  User <| title == 'alan' |> {
    groups +> ['archrepo'],
  } ->
  file { '/srv/http/repo':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
  }

  file { '/srv/http/repo/arch':
    ensure  => directory,
    owner   => 'root',
    group   => 'archrepo',
    mode    => '0775',
    require => File['/srv/http/repo'],
  }

  file { '/srv/http/repo/arch/x86_64':
    ensure  => directory,
    owner   => 'root',
    group   => 'archrepo',
    mode    => '0775',
    require => File['/srv/http/repo/arch'],
  }

  file { '/srv/http/repo/arch/arm':
    ensure  => directory,
    owner   => 'root',
    group   => 'archrepo',
    mode    => '0775',
    require => File['/srv/http/repo/arch'],
  }

  file { '/srv/http/repo/arch/i686':
    ensure  => directory,
    owner   => 'root',
    group   => 'archrepo',
    mode    => '0775',
    require => File['/srv/http/repo/arch'],
  }
}
