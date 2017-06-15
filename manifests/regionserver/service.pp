class hbase::regionserver::service {

  if $hbase::service_install {

    if $::service_provider == 'systemd' {

      exec { "systemctl-daemon-reload-${hbase::service_regionserver}":
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        path        => '/usr/bin',
      }

      file { "${hbase::service_regionserver}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hbase::service_regionserver}.service",
        mode    => '0644',
        content => template('hbase/service/unit-hbase-regionserver.erb'),
      }

      file { "/etc/init.d/${hbase::service_regionserver}":
        ensure => absent,
      }

      File[ "${hbase::service_regionserver}.service" ] ~>
      Exec[ "systemctl-daemon-reload-${hbase::service_regionserver}" ] ->
      Service[ $hbase::service_regionserver ]

    } else {

      file { "${hbase::service_regionserver}.service":
        ensure  => file,
        path    => "/etc/init.d/${hbase::service_regionserver}",
        mode    => '0755',
        content => template('hbase/init.erb'),
        before  => Service[ $hbase::server_regionserver ],
      }

    }

    service { $hbase::service_regionserver:
      ensure     => $hbase::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }
}
