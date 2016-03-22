# == Class mailhog::params
#
# This class is meant to be called from mailhog.
# It sets variables according to platform.
#

class mailhog::params {

  #Config values for puppet module run
  $mailhog_version        = '0.2.0'
  $homedir                = '/var/lib/mailhog'
  $user                   = 'mailhog'
  $service_manage          = true
  $service_enable          = true
  $service_ensure          = 'running'
  $config_template         = 'mailhog/mailhog.conf.erb'
  $initd_template          = 'mailhog/initd-mailhog.erb'
  $service_name            = 'mailhog'
  $config                  = '/etc/mailhog.conf'

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

  #Choose Source file based on local architecture
  if $::architecture  == 'amd64' {
    $source_file = "https://github.com/mailhog/MailHog/releases/download/v${mailhog_version}/MailHog_linux_amd64"
  }
  
  elsif $::architecture  == 'arm' {
    $source_file = "https://github.com/mailhog/MailHog/releases/download/v${mailhog_version}/MailHog_linux_arm"
  }
  
  else {
    $source_file = "https://github.com/mailhog/MailHog/releases/download/v${mailhog_version}/MailHog_linux_386"
  }


}
