# == Class mailhog::params
#
# This class is meant to be called from mailhog.
# It sets variables according to platform.
#

class mailhog::params {
  case $::osfamily {
    'Debian': {
      #Config values for puppet module run
      $config_template         = 'mailhog/mailhog.conf.erb'
      $initd_template          = 'mailhog/initd-mailhog.erb'
      $config                  = '/etc/mailhog.conf'
      $service_manage          = true
      $service_enable          = true
      $service_ensure          = 'running'
      $service_name            = 'mailhog'
      $binary_path            = '/usr/bin'
      $binary_file            = "${binary_path}/mailhog"
      $user                   = 'mailhog'
      $homedir                = '/var/lib/mailhog'
      $mailhog_version        = '0.1.9'
      $initd                   = "/etc/init.d/${service_name}"
    }
    'RedHat', 'Amazon': {
      #Config values for puppet module run
      $config_template         = 'mailhog/mailhog.conf.erb'
      $initd_template          = 'mailhog/initd-mailhog.erb'
      $config                  = '/etc/mailhog.conf'
      $service_manage          = true
      $service_enable          = true
      $service_ensure          = 'running'
      $service_name            = 'mailhog'
      $binary_path            = '/usr/bin'
      $binary_file            = "${binary_path}/mailhog"
      $user                   = 'mailhog'
      $homedir                = '/var/lib/mailhog'
      $mailhog_version        = '0.1.9'
      $initd                   = "/etc/init.d/${service_name}"
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

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



  #Choose Source file based on local architecture
  if $::architecture  == 'amd64' {
    $source_file = "MailHog_linux_v${mailhog_version}_amd64"
  }
  
  elsif $::architecture  == 'arm' {
    $source_file = "MailHog_linux_v${mailhog_version}_arm"
  }
  
  else {
    $source_file = "MailHog_linux_v${mailhog_version}_386"
  }


}
