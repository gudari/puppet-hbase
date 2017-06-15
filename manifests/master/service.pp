class hbase::master::service {

  if $hbase::service_install {

    if $::service_provider == 'systemd' {

      exec { "systemctl-daemon-reload-${hbase::service_master}":
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        path        => '/usr/bin',
      }

      file { "${hbase::service_master}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hbase::service_master}.service",
        mode    => '0644',
        content => template('hbase/service/unit-hbase-master.erb'),
      }

      file { "/etc/init.d/${hbase::service_master}":
        ensure => absent,
      }

      File[ "${hbase::service_master}.service" ] ~>
      Exec[ "systemctl-daemon-reload-${hbase::service_master}" ] ->
      Service[ $hbase::service_master ]

      } else {

      file { "${hbase::service_master}.service":
        ensure  => file,
        path    => "/etc/init.d/${hbase::service_master}",
        mode    => '0755',
        content => template('hbase/init.erb'),
        before  => Service[ $hbase::server_master ],
      }

    }

    service { $hbase::service_master:
      ensure     => $hbase::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }

  } else {
    debug('Skipping service install')
  }
}
