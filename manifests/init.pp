# Class: mailhog
# ===========================
#
#
# Ian Kent did a wonderful job on developing MailHog 
# (https://github.com/mailhog/). 
#
# A nice little tool you could use to receive mail and show them in a smart
#  WebUI. 
# The advantage is MailHog doesn't care about domains and users. It just lists
# all received mails (no matter what source or destination) in its WebUI.
# So it's perfectly easy to check what mails are processed on the local system. 
#
# Mailhog sets up a small MTA like daemon to receive incoming mail. It defaults
# to port 1025 for incoming smtp traffic as the service is running as 
# non-root user.
# So make sure to send all mail to this port. To do this one could use a tool
# like nullmailer. If required one could release individual mails to a real
# world SMTP server for convenience. 
#
#
# This puppet module installs and configures MailHog on a linux system. 
# It provides a init.d script along with a configuration.
#
#
#
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#

class mailhog (
  # MailHog config values
  $api_bind_ip             = $mailhog::params::api_bind_ip,
  $api_bind_port           = $mailhog::params::api_bind_port,
  $api_bind_host           = $mailhog::params::api_bind_host,
  $cors_origin             = $mailhog::params::cors_origin,
  $hostname                = $mailhog::params::hostname,
  $invite_jim              = $mailhog::params::invite_jim,
  $jim_accept              = $mailhog::params::jim_accept,
  $jim_disconnect          = $mailhog::params::jim_disconnect,
  $jim_linkspeed_affect    = $mailhog::params::jim_linkspeed_affect,
  $jim_linkspeed_max       = $mailhog::params::jim_linkspeed_max,
  $jim_linkspeed_min       = $mailhog::params::jim_linkspeed_min,
  $jim_reject_auth         = $mailhog::params::jim_reject_auth,
  $jim_reject_recipient    = $mailhog::params::jim_reject_recipient,
  $jim_reject_sender       = $mailhog::params::jim_reject_sender,
  $mongo_coll              = $mailhog::params::mongo_coll,
  $mongo_db                = $mailhog::params::mongo_db,
  $mongo_uri_ip            = $mailhog::params::mongo_uri_ip,
  $mongo_uri_port          = $mailhog::params::mongo_uri_port,
  $outgoing_smtp           = $mailhog::params::outgoing_smtp,
  $smtp_bind_addr_ip       = $mailhog::params::smtp_bind_addr_ip,
  $smtp_bind_addr_port     = $mailhog::params::smtp_bind_addr_port,
  $storage                 = $mailhog::params::storage,
  $ui_bind_addr_ip         = $mailhog::params::ui_bind_addr_ip,
  $ui_bind_addr_port       = $mailhog::params::ui_bind_addr_port,

  # Puppet module config values
  $config_template         = $mailhog::params::config_template,
  $initd_template          = $mailhog::params::initd_template,
  $config                  = $mailhog::params::config,
  $initd                   = $mailhog::params::initd,
  $service_manage          = $mailhog::params::service_manage,
  $service_enable          = $mailhog::params::service_enable,
  $service_ensure          = $mailhog::params::service_ensure,
  $service_name            = $mailhog::params::service_name,
  $binary_path             = $mailhog::params::binary_path,
  $binary_file             = $mailhog::params::binary_file,
  $source_file             = $mailhog::params::source_file,
  $download_url            = $mailhog::params::download_url,
  $user                    = $mailhog::params::user,
  $homedir                 = $mailhog::params::homedir,
  $mailhog_version         = $mailhog::params::mailhog_version,
  $wget_cache_dir          = $mailhog::params::wget_cache_dir,
  $download_mailhog        = $mailhog::params::download_mailhog,
) inherits mailhog::params {
  
  #Validate values to match required type

  # MailHog config values
  validate_ip_address($api_bind_ip)
  validate_integer($api_bind_port, 65535, 0)
  validate_string($api_bind_host)
  validate_string($cors_origin)
  validate_string($hostname)
  validate_bool($invite_jim)
  validate_numeric($jim_accept)
  validate_numeric($jim_disconnect)
  validate_numeric($jim_linkspeed_affect)
  validate_numeric($jim_linkspeed_max)
  validate_numeric($jim_linkspeed_min)
  validate_numeric($jim_reject_auth)
  validate_numeric($jim_reject_recipient)
  validate_numeric($jim_reject_sender)
  validate_string($mongo_coll)
  validate_string($mongo_db)
  validate_ip_address($mongo_uri_ip)
  validate_integer($mongo_uri_port, 65535, 0)
  validate_string($outgoing_smtp)
  validate_ip_address($smtp_bind_addr_ip)
  validate_integer($smtp_bind_addr_port, 65535, 0)
  validate_string($storage)
  validate_ip_address($ui_bind_addr_ip)
  validate_integer($ui_bind_addr_port, 65535, 0)

  # Puppet module config values
  validate_absolute_path($config)
  validate_bool($service_manage)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_string($service_name)
  validate_string($binary_path)
  validate_absolute_path($binary_file)
  validate_string($user)
  validate_absolute_path($homedir)


  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'mailhog::begin': } ->
  class { '::mailhog::install': } ->
  class { '::mailhog::config': } ~>
  class { '::mailhog::service': } ->
  anchor { 'mailhog::end': }
}
