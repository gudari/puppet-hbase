class hbase::config {

  file { "${hbase::config_dir}/hbase-site.xml":
    ensure  => file,
    owner   => $hbase::hbase_user,
    group   => $hbase::hbase_group,
    content => template('hbase/config/hbase-site.xml.erb'),
    require => File[ $hbase::config_dir ],
  }

  file { "${hbase::config_dir}/regionservers":
    ensure  => file,
    owner   => $hbase::hbase_user,
    group   => $hbase::hbase_group,
    content => template('hbase/config/regionservers.erb'),
    require => File[ $hbase::config_dir ],
  }

}
