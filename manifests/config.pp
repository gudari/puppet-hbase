class hbase::config {

  file { "${hbase::config_dir}/hbase-site.xml":
    ensure  => file,
    owner   => $hbase::hbase_user,
    group   => $hbase::hbase:group,
    content => tempalte('hbase/config/hbase-site.xml.erb'),
    require => File[ $hbase::config_dir ],
  }

  file { "${hbase::config_dir}/regionservers":
    ensure  => file,
    owner   => $hbase::hbase_user,
    group   => $habse::hbase_group,
    content => template('hbase/config/regionserver.erb'),
    require => File[ $hbase::config_dir ],
  }

}
