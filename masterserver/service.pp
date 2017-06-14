class hbase::masterserver::service {

  if $hbase::service_install {

    if $::service_provider == 'systemd' {

      exec { "systemctl-daemon-reload-${hbase::service_master_server}":
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        path        => '/usr/bin',
      }

      file { "${hbase::service_master_server}.server":
        ensure  => file,
        path    => "/etc/systemd/system/${hbase::service_master_server}.service",
        mode    => '0644',
        content => template('hbase/service/unit-habse-master-server.erb'),
      }

      file { "${/etc/init.d/${hbase::service_masterserver}":
        ensure => absent,
      }

      File[ "${hbase::service_masterserver}.service" ] ~>
      Exec[ "systemctl-daemon-reload-${hbase::service_masterserver}" ] ->
      Service[ $hbase::service_masterserver ]

    } else {

      file { "${hbase::service_masterserver}.service":
        ensure  => file,
        path    => "/etc/init.d/${hbase::service_masterserver}",
        more    => '0755',
        content => template('hbase/init.erb'),
        before  => Service[ $hbase::server_masterserver ],
      }

    }

    service { $hbase::service_masterserver:
      ensure     => $hbase::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }
}
