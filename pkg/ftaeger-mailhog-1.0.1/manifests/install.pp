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
  wget::fetch { 'Download MailHog binary':
    source      => $mailhog::source_file,
    destination => $mailhog::binary_file,
    timeout     => 0,
    verbose     => false,
  }

  file {$mailhog::binary_file:
    ensure  => 'present',
    mode    => '0755',
    owner    => 'root',
    group   => 'root',
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
