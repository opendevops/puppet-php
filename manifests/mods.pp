# = Class: php::mods
#
# Description
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#   include apache
#   apache::vhost{ 'appserver1604':
#     projectPath => '/vagrant/www/projects'
#   }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define php::mods ($project = $title) {

  $modules = [
    # cli
    'php-cli',
    # intl
    'php-intl',
    # common
    'php-common',
    # curl
    'php-curl',
    # gd
    'php-gd',
    # mbstring
    'php-mbstring',
    # mcrypt
    'php-mcrypt',
    # mysql
    'php-mysql',
    # opcache
    'php-opcache',
    # xml
    'php-xml',
    # required for PECL (to install mailparse)
    # 'php-pear',
    'php-dev',
  ]

  package { $modules:
    ensure  => latest,
    require => Package['php'],
    notify  => Service['php7.0-fpm'],
  }

}
