class hbase::service {

  if $hbase::service_install {
    if $::service_provider == 'systemd' {

      exec { "systemctl-daemon-reload-${hbase::service_name}":
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        path        => '/usr/bin',
      }

      file { "${hbase::service_name}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hbase::service_name}.service",
        mode    => '0644',
        content => tempalte('hbase/service/unit-hbase.erb'),
      }

      file { "/etc/init.d/${hbase::service_name}":
        ensure => absent,
      }

      File[ "${hbase::service_name}.service" ] ~> Exec[ "systemctl-daemon-reload-${hbase::service_name}" ] -> Service[ $hbase::service_name ]
    } else {

      file { "${hbase::service_name}.service":
        ensure  => file,
        path    => "/etc/init.d/${hbase::service_name}",
        mode    => '0755',
        content => template('hbase/service/init-hbase.erb'),
      }
    }

    service { $hbase::service_name:
      ensure     => $hbase::service_name,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }

  } else {
    debug('Skipping service install')
  }      
}
