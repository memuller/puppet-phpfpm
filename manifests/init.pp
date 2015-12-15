# == Class: phpfpm
#
# See README.md
#
class phpfpm (
	$ensure = 'present',
	$user = 'www-data',
	$group = 'www-data',
	$socket = true
) {
	$running = $ensure ? {
		absent  => 'stopped',
		default => 'running',
	}

	$listen = $socket ? {
		true => '/var/run/php5-fpm.sock',
		default => '127.0.0.1:9000'
	}

	package { 'php5-fpm':
		ensure => $ensure,
	}

	service { 'php5-fpm':
		ensure  => $running
	}

	file { "/etc/php5/fpm/pool.d/www.conf": 
		ensure => $ensure,
		content => template('phpfpm/www.conf.erb'),
		notify => Service['php5-fpm'],
		require => Package['php5-fpm']
	}

}