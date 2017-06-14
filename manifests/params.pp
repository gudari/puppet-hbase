class hbase::params {

  $version            = '1.2.6'

  $mirror_url         = 'http://apache.rediris.es'
  $install_dir        = '/opt/hbase'
  $download_dir       = '/var/tmp/hbase'
  $log_dir            = '/var/log/hbase'
  $pid_dir            = '/var/run/hbase'

  $hbase_user         = 'hbase'
  $hbase_uid          = undef
  $hbase_group        = 'hbase'
  $hbase_gid          = undef


  $service_install    = true
  $service_name       = 'hbase'
  $service_ensure     = 'running'

  $package_name       = undef
  $package_ensure     = installed

  $default_hbase_site = {}

}
