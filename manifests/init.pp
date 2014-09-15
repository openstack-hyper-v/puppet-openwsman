# == Class: openwsman
#
# Full description of class openwsman here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'openwsman':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2014 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class openwsman (
    $openwsman_client = $openwsman::params::openwsman_client,
    $openwsman_server = $openwsman::params::openwsman_server,
) inherits openwsman::params {
validate_re($::osfamily, '^(Debian|RedHat)$', 'This module only works on Debian and Red Hat based systems.')

  package { $wsman_client:
    ensure => latest,
  }
  package { $wsman_server:
    ensure => latest,
  }

  file {'/etc/pam.d/openwsman':
    ensure  => present,
    require => Package[$wsman_server],
  }

  file {'/etc/openwsman':
    ensure  => directory,
    require => Package[$wsman_client],
  }
  file {'/etc/openwsman/openwsman_client.conf':
    ensure  => present,
    require => Package[$wsman_client],
  }
  file {'/etc/openwsman/openwsman.conf':
    ensure  => present,
    require => Package[$wsman_client],
  }
  file {'/etc/openwsman/ssleay.cnf':
    ensure  => present,
    require => Package[$wsman_client],
  }

}
