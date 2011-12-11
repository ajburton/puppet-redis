class redis::dependencies {
  case $operatingsystem {
    /(Ubuntu|Debian)/: {
      $packages = ["build-essential", "curl"]
      package { $packages: :ensure => installed }
    }
    /(Redhat|CentOS|Fedora)/: {
      $packages = ["gcc", "gcc-c++", "kernel-devel", "curl"]
      package { $packages: :ensure => installed }
    }
  }
}
