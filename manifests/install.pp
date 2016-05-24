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

  # Download Mailhog binary
  if $mailhog::download_mailhog {
    include wget

    # Deploy mailhog binary
    wget::fetch { $mailhog::download_url:
      destination => $mailhog::binary_file,
      timeout     => 0,
      verbose     => false,
      cache_dir   => '/var/cache/wget',
    }

    file {$mailhog::binary_file:
      ensure => 'present',
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
    }
    
    notify { 'downloaded':
      message => "MailHog binary sourced from ${mailhog::download_url}",
    }
  }

  # else use binary files located on puppet master.
  else {
    file {$mailhog::binary_file:
      ensure => 'present',
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      source => $mailhog::source_file,
    }
    
    notify { 'Not downloaded':
      message => 'MailHog binary sourced from Puppet master',
    }
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
