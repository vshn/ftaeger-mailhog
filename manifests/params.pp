# == Class mailhog::params
#
# This class is meant to be called from mailhog.
# It sets variables according to platform.
#

class mailhog::params {

  #Config values for puppet module run
  $mailhog_version        = '1.0.0'
  $homedir                = '/usr/local/bin/mailhog'
  $user                   = 'mailhog'
  $service_manage          = true
  $service_enable          = true
  $service_ensure          = 'running'
  $config_template         = 'mailhog/mailhog.conf.erb'
  $initd_template          = 'mailhog/initd-mailhog.erb'
  $systemd_template        = 'mailhog/systemd-mailhog.erb'
  $service_name            = 'mailhog'
  $config                  = '/etc/mailhog.conf'
  $download_mailhog        = true
  $wget_cache_dir          = undef

  #Config values for mailhog config file
  $api_bind_ip             = '0.0.0.0'
  $api_bind_port           = '8025'
  $api_bind_host           = undef
  $cors_origin             = undef
  $hostname               = $::fqdn
  $invite_jim             = false
  $jim_accept             = '0.99'
  $jim_disconnect         = '0.005'
  $jim_linkspeed_affect   = '0.01'
  $jim_linkspeed_max       = '10240'
  $jim_linkspeed_min       = '10240'
  $jim_reject_auth         = '0.05'
  $jim_reject_recipient   = '0.05'
  $jim_reject_sender       = '0.05'
  $mongo_coll             = 'messages'
  $mongo_db               = 'mailhog'
  $mongo_uri_ip           = '127.0.0.1'
  $mongo_uri_port         = '27017'
  $outgoing_smtp           = undef
  $smtp_bind_addr_ip       = '127.0.0.1'
  $smtp_bind_addr_port     = '1025'
  $storage                 = 'memory'
  $ui_bind_addr_ip         = '0.0.0.0'
  $ui_bind_addr_port       = '8025'

  case $::osfamily {
    'Debian': {
      #Debian specific config
      $binary_path             = '/usr/bin'
      $binary_file             = "${binary_path}/mailhog"
      $initd                   = "/etc/init.d/${service_name}"
    }
    'RedHat', 'Amazon': {
      #RedHat specific config
      $binary_path             = '/usr/bin'
      $binary_file             = "${binary_path}/mailhog"
      $initd                   = "/etc/init.d/${service_name}"
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $repo_arch = $::architecture ? {
    /^.*64$/ => 'amd64',
    default => $::architecture,
  }

  #Choose source files based on local architecture
  case $repo_arch {
    'amd64': {
      $download_url = "https://github.com/mailhog/MailHog/releases/download/v${mailhog_version}/MailHog_linux_amd64"
      $source_file  = 'puppet:///modules/mailhog/MailHog_linux_amd64'
    }
    'arm': {
      $download_url = "https://github.com/mailhog/MailHog/releases/download/v${mailhog_version}/MailHog_linux_arm"
      $source_file  = 'puppet:///modules/mailhog/MailHog_linux_arm'
    }
    '386', 'i386': {
      $download_url = "https://github.com/mailhog/MailHog/releases/download/v${mailhog_version}/MailHog_linux_386"
      $source_file  = 'puppet:///modules/mailhog/MailHog_linux_386'
    }
    default: {
      fail("${::architecture} not supported")
    }
  }
}
