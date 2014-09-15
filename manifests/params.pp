# == Class: openwsman::params
#
# OpenWSMAN Parameters
#
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2014 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class openwsman::params {

  $version        = undef
  $ensure         = present
  $service_state  = running
  $service_enable = true

  case $::osfamily {
    'Debian':{
      case $::operatingsystem {
        'Ubuntu':{
          $wsman_client = 'wsmancli'
          $wsman_server = 'openwsman'
        }
      }
    }
    'Redhat':{
      case $::operatingsystem {
        'Centos':{
          $wsman_client = 'openwsman-client'
          $wsman_server = 'openwsman-server'
        }
      }
    }
    default:{
      warning("${::osfamily} is unsupported by module: ${::modulename}")
    }
  }

}
