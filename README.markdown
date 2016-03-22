#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with mailhog](#setup)
    * [What mailhog affects](#what-mailhog-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mailhog](#beginning-with-mailhog)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module lets you use Puppet to install and configure MailHog

## Module Description

MailHog is an email testing tool for developers written by Ian Kent (https://github.com/mailhog/). It receives mail and displays it in a WebUI. No login required, no need for user accounts. Just all received mail is shown in the WebUI. 

You can access the WebUI by opening http://$::ipaddress:8025 (default port, feel free to change) in your browser. 

MailHog will receive mail (default is smtp on port 1025) and will display it in the WebUI. You can view and delete the mail. If required one could also forward the mail to the corresponding external Mailserver for the receipients e-mail domain. 

The configuration is straight forward - take a look at the params.pp class for default values.

Due to the size limitation on puppet forge the module will download the mailhog binary to the target system. 

## Setup

### What mailhog affects

* Deploys mailhog binary depending on the architecture the local machine uses (amd64, arm or x86). 
* Creates a "mailhog" user
* Deploys a mailhog.conf file with the available config values
* Deploys a initd script to start/stop mailhog as a daemon
* installs "daemon" package


### Setup Requirements

This mailhog module requires:
* [puppetlabs-stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib) 
* [maestrodev-wget](https://forge.puppetlabs.com/maestrodev/wget)


### Beginning with mailhog

The simplest way to get MailHog up and running with the mailhog module is to just add the mailhog-class to your manifest:

```puppet
include mailhog
```

That's it! Really. Didn't hurt, did it? ;-)

You want to change the ip & port MailHog receives incoming mails? No problem:
```puppet
class { 'mailhog':
  smtp_bind_addr_ip   => "1.2.3.4",
  smtp_bind_addr_port => "1125"
}

include mailhog
```
## Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here. 

##Reference

### Classes
#### Public Classes
* `mailhog`: Main class, includes all other classes

#### Private Classes
* `mailhog::params`:  Holds default values for MailHog & module config
* `mailhog::install`: Handles deployment of user, dependencies and mailhog binary
* `mailhog::config`:  Handles deployment of mailhog config file
* `mailhog::service`: Handles deployment of the init.d script



###Parameters
The following parameters are available in the ::mailhog class:


####MailHog config values
| parameter                                |      default value      |  description |
|------------------------------------------|-------------------------|--------------|
| `$mailhog::params::api_bind_ip`          | 0.0.0.0   | The IP address the API server will be bound to. |
| `$mailhog::params::api_bind_port`        | 8025      | The port the API server will be bound to. |
| `$mailhog::params::api_bind_host`        | undef     | API URL for MailHog UI to connect to, e.g. http://some.host:1234 if API and WebUI are deployed on different hosts/IPs. |
| `$mailhog::params::cors_origin`          | undef     | CORS Access-Control-Allow-Origin header for API endpoints. |
| `$mailhog::params::hostname`             | $::fqdn   | Hostname to use for EHLO/HELO and message IDs. |
| `$mailhog::params::invite_jim`           | false     | Decide whether to invite Jim, the chaos monkey. Jim is the MailHog Chaos Monkey, inspired by Netflix. He will:<br><ul><li>Reject connections</li><li>Rate limit connections</li><li>Reject authentication</li><li>Reject senders</li><li>Reject recipients</li></ul>|
| `$mailhog::params::jim_accept`           | 0.99      | Chance of accepting an incoming connection (1.0 = 100%) |
| `$mailhog::params::jim_disconnect`       | 0.005     | Chance of a disconnect |
| `$mailhog::params::jim_linkspeed_affect` | 0.1       | Chance of the link speed being affected for an incoming mail |
| `$mailhog::params::jim_linkspeed_max`    | 10240     | Maximum link speed (in bytes per second) |
| `$mailhog::params::jim_linkspeed_min`    | 1024      | Minimum link speed (in bytes per second) |
| `$mailhog::params::jim_reject_auth`      | 0.05      | Chance of rejecting authentication (AUTH) |
| `$mailhog::params::jim_reject_recipient` | 0.05      | Chance of rejecting a recipient (RCPT TO) |
| `$mailhog::params::jim_reject_sender`    | 0.05      | Chance of rejecting a sender (MAIL FROM) |
| `$mailhog::params::mongo_coll`           | messages  | MongoDB collection if MongoDB is being used as backend storage |
| `$mailhog::params::mongo_db`             | mailhog   | MongoDB database if MongoDB is being used as backend storage |
| `$mailhog::params::mongo_uri_ip`         | 127.0.0.1 | MongoDB URI IP if MongoDB is being used as backend storage |
| `$mailhog::params::mongo_uri_port`       | 27017     | MongoDB URI port if MongoDB is being used as backend storage |
| `$mailhog::params::outgoing_smtp`        | undef     | JSON file containing outgoing SMTP servers |
| `$mailhog::params::smtp_bind_addr_ip`    | 127.0.0.1 | SMTP bind interface, this is where MailHog will receive incoming mails |
| `$mailhog::params::smtp_bind_addr_port`  | 1025      | SMTP bind port, this is where MailHog will receive incoming mails |
| `$mailhog::params::storage`              | memory    | Message storage: memory or mongodb |
| `$mailhog::params::ui_bind_addr_ip`      | 0.0.0.0   | HTTP bind interface for WebUI |
| `$mailhog::params::ui_bind_addr_port`    | 8025      | HTTP bind port for WebUI |



####Puppet module config values
| parameter                                |      default value       |  description |
|------------------------------------------|--------------------------|--------------|
| `$mailhog::params::version`              | 0.2.0                    | Version of Mailhog to be used. Feel free to look up the latest release version from [GitHub](https://github.com/mailhog/MailHog/releases/latest) |
| `$mailhog::params::config_template`      | mailhog/mailhog.conf.erb | Name and position of the ERB-template for the mailhog config file.
| `$mailhog::params::config`               | /etc/mailhog.conf        | Path and filename for mailhog config file at the target system |
| `$mailhog::service_manage`               | true                     | Whether the service should be managed by this module or not. |
| `$mailhog::params::service_enable`       | true                     | Whether the service should be started on boot or not. |
| `$mailhog::params::service_ensure`       | running                  | Either "running" or "stopped" |
| `$mailhog::params::service_name`         | mailhog                  | Name of the service |
| `$mailhog::params::binary_path`          | /usr/bin                 | Where to place the mailhog binary at the target system |
| `$mailhog::params::binary_file`          | ${binary_path}/mailhog   | Path of the mailhog binary at the target system |
| `$mailhog::params::user`                 | mailhog                  | Username of the user running mailhog service at the target system. |
| `$mailhog::params::homedir`              | /var/lib/mailhog         | Home directory of above mailhog user. |
| `$mailhog::params::mailhog_version`      | 0.2.0                    | This is the mailhog version used for the target system. |


## Limitations

Today the module was tested with Ubuntu 14.04 and 12.04 only. It might work with other Linux versions though. The more time I have the more I will test. Any help would be really appreciated. 


## Development

Feel free to pull the repository and commit changes. I will review them asap and add them if I think they are helpful or reasonable. No guarantees but a lot of heart ;-)


###Contributors

To see who's already involved, see the [list of contributors.](https://github.com/ftaeger/ftaeger-mailhog/graphs/contributors)


