class redis::overcommit($ensure=present) {

  file { "/etc/sysctl.d/overcommit.conf":
    ensure => $ensure,
    content => "vm.overcommit_memory=1",
  }

  if $ensure == "present" {
    exec { "overcommit-memory":
      command => "sysctl vm.overcommit_memory=1",
      onlyif => "test `/sbin/sysctl -n vm.overcommit_memory` -eq 0"
    }
  }
}
