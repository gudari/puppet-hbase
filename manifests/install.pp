class hbase::install {

  file { $hbase::download_dir:
    ensure  => directory,
    owner   => $hbase::hbase_user,
    group   => $hbase::hbase_group,
    require => [
      Group[ $hbase::hbase_group ],
      User[ $hbase::hbase_user ],
    ],
  }

  file { $hbase::extract_dir:
    ensure  => directory,
    owner   => $hbase::hbase_user,
    group   => $hbase::hbase_group,
    require => [
      Group[ $hbase::hbase_group ],
      User[ $hbase::hbase_user ],
    ],
  }

  file { $hbase::log_dir:
    ensure  => directory,
    owner   => $hbase::hbase_user,
    group   => $hbase::hbase_group,
    require => [
      Group[ $hbase::hbase_group ],
      User[ $hbase::hbase_user ],
    ],
  }

  file { $hbase::pid_dir:
    ensure  => directory,
    owner   => $hbase::hbase_user,
    group   => $hbase::hbase_group,
    require => [
      Group[ $hbase::hbase_group ],
      User[ $hbase::hbase_user ],
    ],
  }

  if $hbase::package_name == undef {
    include ::archive

    archive { "${hbase::download_dir}/${hbase::basefilename}":
      ensure          => present,
      extract         => true,
      extract_command => 'tar xfv %s --strip-components=1',
      extract_path    => $hbase::extract_dir,
      source          => $hbase::package_url,
      creates         => "${hbase::extract_dir}/bin",
      cleanup         => true,
      user            => $hbase::hbase_user,
      group           => $hbase::hbase_group,
      require         => [
        File[ $hbase::download_dir ],
        File[ $hbase::extract_dir ],
        Group[ $hbase::hbase_group ],
        User[ $hbase::hbase_user ],
      ],
      before          => File[ $hbase::install_dir ],
    }
  } else {

    package { $hbase::package_name:
      ensure => $hbase::package_ensure,
      before => File[ $hbase::install_dir ],
    }
  }

  file { $hbase::install_dir:
    ensure  => link,
    target  => $hbase::extract_dir,
    require => File[ $hbase::extract_dir],
  }

  file { $hbase::config_dir:
    ensure  => directory,
    owner   => $hbase::hbase_user,
    group   => $hbase::hbase_group,
    require => [
      Group[ $hbase::hbase_group ],
      User[ $hbase::hbase_user ],
      Archive[ "${hbase::download_dir}/${hbase::basefilename}" ],
    ],
  }
}

