# Class: hbase
# ===========================
#
# Full description of class hbase here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'hbase':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class hbase (
  
  $version           = $hbase::params::version,

  $install_dir       = $hbase::params::install_dir,
  $extract_dir       = "/opt/hbase-${version}",
  $download_dir      = $hbase::params::download_dir,
  $mirror_url        = $hbase::params::mirror_url,
  $basefilename      = "hbase-${version}-bin.tar.gz",
  $package_url       = "${mirror_url}/hbase/${version}/${basefilename}",
  $log_dir           = $hbase::params::log_dir,
  $pid_dir           = $hbase::params::pid_dir,

  $config_dir        = "${install_dir}/conf",

  $custom_hbase_site = {},

  $service_install      = $hbase::params::service_install,
  $service_master       = $hbase::params::service_master,
  $service_regionserver = $hbase::params::service_regionserver,
  $service_ensure       = $hbase::params::service_ensure,

  $hbase_group       = $hbase::params::hbase_group,
  $hbase_gid         = $hbase::params::hbase_gid,
  $hbase_user        = $hbase::params::hbase_user,
  $hbase_uid         = $hbase::params::hbase_uid,

  $package_name      = $hbase::params::package_name,
  $package_ensure    = $hbase::params::package_ensure,

  $master   = $::fqdn,
  $regionservers    = [ $::fqdn ],

) inherits hbase::params {

  group { $hbase_group:
    ensure => present,
    gid    => $hbase_gid,
  }

  user { $hbase_user:
    ensure  => present,
    uid     => $hbase_uid,
    groups  => $hbase_group,
    require => Group[ $hbase_group ],
  }

  if $master == $::fqdn {
    $daemon_master = true
  } else {
    $daemon_master = false
  }

  if member($regionservers, $::fqdn) {
    $daemon_regionserver = true
  } else {
    $daemon_regionserver = false
  }

  $hbase_site = deep_merge($hbase::params::default_hbase_site, $custom_hbase_site)

  anchor { '::hbase::start': } -> class { '::hbase::install': } -> class { '::hbase::config': } ~> class { '::hbase::service': } -> anchor { '::hbase::end': }

}
