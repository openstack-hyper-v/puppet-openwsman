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
#    pywinrm => 'true',
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
  $pywinrm          = $openwsman::params::pywinrm,
)inherits openwsman::params {
  validate_re($::osfamily, '^(Debian|RedHat)$', 'This module only works on Debian and Red Hat based systems.')
  package { $openwsman::wsman_client:
    ensure => latest,
  }
  package { $openwsman::wsman_server:
    ensure => latest,
  }
  package { $openwsman::wsman_python:
    ensure => latest,
  }

  if $openwsman::pywinrm == true {
    package {'python-pip':
      ensure => latest,
    }

    package {'pywinrm':
      ensure   => latest,
      source   => 'http://github.com/diyan/pywinrm/archive/master.zip',
      provider => pip,
      require  => Package['python-pip'],
    }
    exec{'get-wsmancmd.py':
      command => '/usr/bin/wget -c https://raw.githubusercontent.com/cloudbase/unattended-setup-scripts/master/wsmancmd.py',
      cwd     => '/usr/local/bin',
    }

    file {'/usr/local/bin/wsmancmd.py':
      ensure  => file,
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      require => Exec['get-wsmancmd.py'],
    }
  }

  file {'/etc/pam.d/openwsman':
    ensure  => present,
    require => Package[$openwsman::wsman_server],
  }

  file {'/etc/openwsman':
    ensure  => directory,
    require => Package[$openwsman::wsman_client],
  }
  file {'/etc/openwsman/openwsman_client.conf':
    ensure  => present,
    content => template('openwsman/openwsman_client.conf.erb'),
    require => Package[$openwsman::wsman_client],
  }
  file {'/etc/openwsman/openwsman.conf':
    ensure  => present,
    content => template('openwsman/openwsman.conf.erb'),
    require => Package[$openwsman::wsman_client],
  }
  file {'/etc/openwsman/ssleay.cnf':
    ensure  => present,
    content => template('openwsman/ssleay.cnf.erb'),
    require => Package[$openwsman::wsman_client],
  }

}
