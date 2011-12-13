class redis::params {
  case $operatingsystem {
    ubuntu, debian: {
      $server_init = "puppet:///modules/redis/debian/redis-server.init"
    }
    redhat, centos: {
      $server_init = "puppet:///modules/redis/redhat/redis-server.init"
    }
  }
}
