class hbase::service {

  if $hbase::daemon_master { contain hbase::master::service }
  if $hbase::daemon_regionserver { contain hbase::regionserver::service }

}
