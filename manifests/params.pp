# == Class: openwsman::params
#
# OpenWSMAN Default Parameters
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

  $version               = undef
  $ensure                = present
  $service_state         = running
  $service_enable        = true
  $wsman_http_port       = '5985'
  $wsman_use_ipv4        = 'yes'
  $wsman_use_ipv6        = 'yes'
  $wsman_ssl_cert_file   = '/etc/openwsman/servercert.pem'
  $wsman_ssl_key_file    = '/etc/openwsman/serverkey.pem'
  $wsman_ssleay_bitsize  = '1024'
  $pywinrm               = undef
  $cim_default_namespace = 'root/cimv2'
  $cimom_host            = 'localhost'
  $cimom_port            = '5989'
  $cimom_use_ssl         = 'yes'
  $cimom_verify_ssl_cert = 'yes'
  $cimom_ssl_trust_store = '/etc/ssl/certs'



  case $::osfamily {
    'Debian':{
      $wsman_client = 'wsmancli'
      $wsman_client_required_packages = [ 'libcurl3', 'libwsman-client2', 'libwsman-curl-client-transport1', 'libwsman1' ]
      $wsman_server = 'openwsman'
      $wsman_server_required_packages = [ 'libcimcclient0','libwsman-server1', $wsman_client_required_packages ]
      $wsman_python = 'python-openwsman'
    }
    'Redhat':{
      $wsman_client = 'openwsman-client'
      $wsman_server = 'openwsman-server'
      $wsman_python = 'openwsman-python'
    }
    default:{ warning("${osfamily} is unsupported by module puppet-openwsman") }
  }
}
