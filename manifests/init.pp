# == Class: php
#
# Full description of class php here.
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
# include php
# php::config { 'php_config': }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
class php () {

  # install php package
  package { 'php':
    require => Exec['apt-update'],
    ensure  => installed,
  }

  # install php-fpm package
  package { 'php7.0-fpm':
    require => Package['php'],
    ensure  => installed,
  }

  # Starts the php7.0-fpm service, and monitors changes to its configuration files and reloads if nesessary
  service { 'php7.0-fpm':
    ensure  => running,
    enable  => true,
    require => Package['php7.0-fpm']
  }

  # php mods
  php::mods{ 'php-mods': }

  # mailparse (from PECL is a repository for PHP Extensions)
  php::mailparse{ 'php-mailparse': }

}
