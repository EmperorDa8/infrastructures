# Node definition for all 20 nodes
node /^node\d+$/ {
  # Include all required modules
  include python
  include webserver
  include development_tools
  include database

  # Ensure correct order of installation
  Class['python']
  -> Class['webserver']
  -> Class['development_tools']
  -> Class['database']
}

# Define Python module
class python {
  package { 'python3':
    ensure => installed,
  }

  package { 'python3-pip':
    ensure => installed,
    require => Package['python3'],
  }

  package { 'requests':
    ensure   => installed,
    provider => 'pip3',
    require  => Package['python3-pip'],
  }
}

# Define Webserver module
class webserver {
  package { 'apache2':
    ensure => installed,
  }

  service { 'apache2':
    ensure  => running,
    enable  => true,
    require => Package['apache2'],
  }
}

# Define Development tools module
class development_tools {
  # Install Node.js and npm
  $nodejs_dependencies = ['curl', 'gnupg']

  package { $nodejs_dependencies:
    ensure => installed,
  }

  exec { 'add-nodejs-repo':
    command => 'curl -fsSL https://deb.nodesource.com/setup_18.x | bash -',
    path    => ['/usr/bin', '/bin'],
    creates => '/etc/apt/sources.list.d/nodesource.list',
    require => Package['curl'],
  }

  package { 'nodejs':
    ensure  => installed,
    require => Exec['add-nodejs-repo'],
  }

  # Install Putty
  package { 'putty':
    ensure => installed,
  }
}

# Define Database module
class database {
  # Install Redis
  package { 'redis-server':
    ensure => installed,
  }

  service { 'redis-server':
    ensure  => running,
    enable  => true,
    require => Package['redis-server'],
  }

  # Redis configuration
  file { '/etc/redis/redis.conf':
    ensure  => present,
    content => template('database/redis.conf.erb'),
    notify  => Service['redis-server'],
    require => Package['redis-server'],
  }
}