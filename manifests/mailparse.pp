# = Class: php::mailparse
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
define php::mailparse ($project = $title) {


  # upgrade PEAR
  # exec { "pear upgrade":
  #   require => Package["php-pear"]
  # }


  # change mbfilter.h to fix PECL mbstring bug (see https://bugs.php.net/bug.php?id=71813)
  # echo '#define HAVE_MBSTRING 1' | cat - /usr/include/php/20151012/ext/mbstring/libmbfl/mbfl/mbfilter.h > temp && mv temp /usr/include/php/20151012/ext/mbstring/libmbfl/mbfl/mbfilter.h
  # echo '#undef HAVE_MBSTRING' | cat - /usr/include/php/20151012/ext/mbstring/libmbfl/mbfl/mbfilter.h > temp && mv temp /usr/include/php/20151012/ext/mbstring/libmbfl/mbfl/mbfilter.h

  # FIX PECL MBSTRING BUG
  # change mbfilter.h to fix PECL mbstring bug (see https://bugs.php.net/bug.php?id=71813)
  exec { 'define-have-mbstring':
    # path    => "/bin:/usr/bin",
    # user    => 'root',
    command => "echo '#define HAVE_MBSTRING 1' | cat - /usr/include/php/20151012/ext/mbstring/libmbfl/mbfl/mbfilter.h > temp && mv temp /usr/include/php/20151012/ext/mbstring/libmbfl/mbfl/mbfilter.h",
    require => Package['php-dev'],
    # require => Exec['pear upgrade'],
  }
  exec { 'undef-have-mbstring':
    # path    => "/bin:/usr/bin",
    # user    => 'root',
    command => "echo '#undef HAVE_MBSTRING' | cat - /usr/include/php/20151012/ext/mbstring/libmbfl/mbfl/mbfilter.h > temp && mv temp /usr/include/php/20151012/ext/mbstring/libmbfl/mbfl/mbfilter.h",
    require => Exec['define-have-mbstring'],
  }

  # INSTALL MAILPARSER
  # install mailparser php extension (parsing and working with email messages)
  exec { 'pecl install mailparse':
    path    => '/bin:/usr/bin',
    # user    => 'root',
    command => 'pecl install mailparse',
    unless => 'pecl info mailparse',
    require => Exec['undef-have-mbstring'],
  }


  # ENABLE MAILPARSE
  # create mods-available/mailparse.ini
  exec { 'enable-mailparse':
    # path    => '/bin:/usr/bin',
    # user    => 'root',
    command => 'sudo bash -c "echo extension=mailparse.so > /etc/php/7.0/mods-available/mailparse.ini"',
    # this stops the exec running more than once (because file has been created)
    creates => '/etc/php/7.0/mods-available/mailparse.ini',
    require => Exec['pecl install mailparse'],
    # require => Package['mailparse'],

  }

  # enable mod php mailparse for php fpm (webserver php)
  file { '/etc/php/7.0/fpm/conf.d/20-mailparse.ini':
    ensure    => link,
    target    => '/etc/php/7.0/mods-available/mailparse.ini',
    require   => Exec['enable-mailparse'],
    notify    => Service['php7.0-fpm'],
  }
  # enable mod php mailparse for php cli (command line)
  # Restart php not required - configuration is loaded fresh each time you invoke PHP from the CLI
  file { '/etc/php/7.0/cli/conf.d/20-mailparse.ini':
    ensure    => link,
    target    => '/etc/php/7.0/mods-available/mailparse.ini',
    require   => File['/etc/php/7.0/fpm/conf.d/20-mailparse.ini'],
  }

  #   default: (Exec[define-have-mbstring] => Exec[undef-have-mbstring] => Exec[pecl install mailparse] => Exec[enable-mailparse] => File[/etc/php/7.0/fpm/conf.d/20-mailparse.ini] => File[/etc/php/7.0/cli/conf.d/20-mailparse.ini] => Package[php] => Package[php-dev] => Exec[define-have-mbstring])


}
