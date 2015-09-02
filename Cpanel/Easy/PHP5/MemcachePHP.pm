package Cpanel::Easy::PHP5::MemcachePHP;

use Cpanel::Version::Compare ();
my $php_ini = '/usr/local/lib/php.ini';
my $memcache_ver = '2.2.7';

our $easyconfig = {
	'name' => 'Memcache',
	'note' => q{Memcache PECL module.},
	'verify_on' => q{If you plan on connecting to a local memcached server, you need to also install memcached on this machine!},

	'url' => 'https://pecl.php.net/package/memcache',
	'when_i_am_off' => sub {
		my $self = shift;
		if ( !$self->get_param('makecpphp') ) {
			if ( -e '/usr/local/lib/php.ini' ) {
				Cpanel::FileUtils::regex_rep_file( '/usr/local/lib/php.ini', { qr{^\s*extension\s*=\s*"?memcache\.so"?\s*$}is => q{} }, {}, );
			}
		}
	},
	'step' => {
		'0' => {
			'name' => 'memcache: Download source',
			'command' => sub {
				my ($self) = @_;

				return $self->run_system_cmd_returnable( [ 'wget', '-O', $self->{'opt_mod_src_dir'}."/memcache-$memcache_ver.tgz", "https://pecl.php.net/get/memcache-$memcache_ver.tgz"] );
			},
		},
		'1' => {
			'name' => 'memcache: Extract source',
			'command' => sub {
				my ($self) = @_;

				mkdir("$self->{'opt_mod_src_dir'}/memcache_ext") unless ( -d "$self->{'opt_mod_src_dir'}/memcache_ext" );
				return $self->run_system_cmd_returnable( ["tar zxf $self->{'opt_mod_src_dir'}/memcache-$memcache_ver.tgz -C $self->{'opt_mod_src_dir'}/memcache_ext"] );
			},
		},
		'2' => {
			'name' => 'memcache: phpize',
			'command' => sub {
				my ($self) = @_;
				my $module_src = $self->{'opt_mod_src_dir'}."/memcache_ext/memcache-$memcache_ver";

				chdir $module_src or return ( 0, q{Could not chdir into [_1]: [_2]}, $module_src, $! );
				return $self->run_system_cmd_returnable( ['/usr/local/bin/phpize'] );
			},
		},
		'3' => {
			'name' => 'memcache: configure',
			'command' => sub {
				my ($self) = @_;

				return $self->run_system_cmd_returnable( [ './configure' ] );
			},
		},
		'4' => {
			'name' => 'memcache: make',
			'command' => sub {
				my ($self) = @_;

				return $self->run_system_cmd_returnable( [ 'make' ] );
			},
		},
		'5' => {
			'name' => 'memcache: make install',
			'command' => sub {
				my ($self) = @_;

				return $self->run_system_cmd_returnable( [ 'make install' ] );
			}, 
		},
		'6' => {
			'name' => 'memcache: Add to php.ini',
			'command' => sub {
				my ($self) = @_;
			
				my $php_ini_contents;
				open FILE, $php_ini or return ( 0, "Couldn't read [$php_ini]: $!" ); 
				$php_ini_contents = join("", <FILE>);
				close FILE;

				if ( $php_init_contents !~ /extension=memcache\.so/ ) {
					open(my $fh, '>>', $php_ini) or return ( 0, "Couldn't write [$php_ini]: $!" );
					print $fh 'extension=memcache.so';
					close $fh;
				}

				return ( 1, 'ok' );
			},
		},
	},
};


1;
