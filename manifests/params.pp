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
          $wsman_client                   = 'wsmancli'

          $wsman_client_required_packages = ['libcurl3',
                                             'libwsman-client2',
                                             'libwsman-curl-client-transport1',
                                             'libwsman1']

          $wsman_server                   = 'openwsman'

          $wsman_server_required_packages = ['libcimcclient0',
                                             'libwsman-server1',
                                             $wsman_client_required_packages ]
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
