class hbase::service {

  if $hbase::daemon_masterserver { contain hbase::masterserver::service }
  if $hbase::daemon_regionserver { contain hbase::regionserver::service }

}
