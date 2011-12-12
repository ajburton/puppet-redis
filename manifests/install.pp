define redis::install($ensure=present, $bin_dir="", $sbin_dir="", $tar_version=undef) {
  include redis::dependencies

  $version = $name
  $redis_src = "/usr/local/src/redis-${version}"

  if $tar_version == undef {
    $tar_version = $version
  }

  if $ensure == 'present' {

    file { $redis_src:
      ensure => "directory",
    }

    exec { "fetch redis ${version}": 
      command => "curl -sL http://redis.googlecode.com/files/redis-${tar_version}.tar.gz | tar --strip-components 1 -xz",
      cwd => $redis_src,
      creates => "${redis_src}/Makefile",
      require => File[$redis_src],
    }

    exec { "install redis ${version}":
      command => "make && /etc/init.d/redis-server stop && make install PREFIX=/usr/local",
      cwd => "${redis_src}/src",
      unless => "test `redis-server --version | cut -d ' ' -f 4` = '${version}'",
      require => [Exec["fetch redis ${version}"], Package[$redis::dependencies::packages]]
    }

  } elsif $ensure == 'absent' {

    file { $redis_src:
      ensure => $ensure,
      recurse => true,
      purge => true,
      force => true,
    }

    file { ["$bin_dir/redis-benchmark",
            "$bin_dir/redis-check-aof",
            "$bin_dir/redis-check-dump",
            "$bin_dir/redis-cli",
            "$sbin_dir/redis-server"]:
      ensure => $ensure,
    }
  }
}
