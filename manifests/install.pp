# == Class mailhog::install
#
# This class is called from mailhog for install.
#

class mailhog::install inherits mailhog {

  # Add user to run mailhog with lower privilegues
  user { $mailhog::user:
    ensure => 'present',
    home   => $mailhog::homedir,
    system => true,
  }

  package { 'daemon':
    ensure => present,
  }

  # Deploy mailhog binary
  file { $mailhog::binary_file:
    ensure => file,
    source => "puppet:///modules/mailhog/${mailhog::source_file}",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Deploy mailhog init script
  file { $mailhog::initd:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template($mailhog::initd_template),
  }

}
