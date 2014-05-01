#!/usr/bin/env perl

package NapiTest;

use strict;
use warnings;
$|++;
use 5.010;

use Exporter ();
use LWP::Simple;
use Archive::Extract;
use Carp;

our @EXPORT = qw/
	prepare_env
	prepare_assets
	prepare_shells
/;

our $path_root = "/home/vagrant";


sub prepare_assets {
	my $assets_tgz = "napi_test_files.tgz";
	my $assets_path = $path_root . '/' . $assets_tgz;
	my $url = "https://www.dropbox.com/s/gq2wbfkl7ep1uy8/napi_test_files.tgz";

	croak "assets directory already exists\n" and return if ( -e $path_root . '/napi_test_files' ); 
	print "Downloading assets\n" and system("wget $url -O $assets_path")
		unless ( -e $assets_path );

	my $ae = Archive::Extract->new( archive => $assets_path );
	$ae->extract( to => $path_root ) and print "Unpacked assets\n";
}


sub prepare_env {
	my $arch = `/usr/bin/gcc -print-multiarch`;
	
	$ENV{LIBRARY_PATH} = '/usr/lib/' . $arch;
	$ENV{C_INCLUDE_PATH} = '/usr/include/' . $arch;
	$ENV{CPLUS_INCLUDE_PATH} = '/usr/include/' . $arch;

	print "Exporting...\n";
	print "LIBRARY_PATH: " . $ENV{LIBRARY_PATH};
	print "C_INCLUDE_PATH: " . $ENV{C_INCLUDE_PATH};
	print "CPLUS_INCLUDE_PATH: " . $ENV{CPLUS_INCLUDE_PATH};
}


sub set_old_gcc {
	state $orig_path = $ENV{PATH};
	state $orig_libs = $ENV{LIBRARY_PATH} // '';
	state $orig_cinc = $ENV{C_INCLUDE_PATH} // '';

	if (shift) {
		print "Exporting path to include local gcc\n";
		$ENV{PATH} = $path_root . '/' . 'gcc-3.0/bin:' . $orig_path;
		$ENV{LIBRARY_PATH} = '/usr/lib/i386-linux-gnu:' . $orig_libs;
		$ENV{C_INCLUDE_PATH} = '/usr/include/i386-linux-gnu:' . $orig_cinc;
	}
	else {
		print "Exporting default path\n";
		$ENV{PATH} = $orig_path;
		prepare_env();
	}
}


sub prepare_shells {

	my $shell_src_dir = "shells_src";
	my $shell_src_path = $path_root . '/' . $shell_src_dir;
	
	my $shell_bin_dir = "shells_bin";
	my $shell_bin_path = $path_root . '/' . $shell_bin_dir;
	
	my $url = "http://ftp.gnu.org/gnu/bash";
	my @versions = qw/
		bash-2.0.tar.gz
		bash-2.01.1.tar.gz
		bash-2.01.tar.gz
		bash-2.02.1.tar.gz
		bash-2.02.tar.gz
		bash-2.03.tar.gz
		bash-2.04.tar.gz
		bash-2.05.tar.gz
		bash-2.05a.tar.gz
		bash-2.05b.tar.gz
		bash-3.0.tar.gz
		bash-3.1.tar.gz
		bash-3.2.48.tar.gz
		bash-3.2.tar.gz
		bash-4.0.tar.gz
		bash-4.1.tar.gz
		bash-4.2.tar.gz
		bash-4.3.tar.gz
		/;

	carp "Shell Source directory already exists - assuming that all sources already have been downloaded and compiled\n" and return
		if ( -e $shell_src_path && -d $shell_src_path );
	
	mkdir $shell_src_path;
	mkdir $shell_bin_path;
	STDOUT->autoflush(1);

	my $cnt = 0;

	foreach (@versions) {

		my ($version) = m/^bash-(.*)?\.tar\.gz$/;
		my $dir_name = 'bash-' . $version;
		my $tgz_path = $shell_src_path . '/' . $_;
		my $dir_path = $shell_src_path . '/' . $dir_name;

		print "Downloading shell: [$_]\n" and getstore( $url . '/' . $_, $tgz_path ) unless ( -e $tgz_path );
		
		my $ae = Archive::Extract->new( archive => $shell_src_path . '/' . $_ );
		$ae->extract( to => $shell_src_path ) and print "Unpacked [$_]\n";

		set_old_gcc( $cnt < 10 );

		# build it
		print ("Building...");
		system ('cd ' . $dir_path . ' && ./configure && make 2>&1 | tee compilation.log');

		symlink $dir_path . '/bash', $shell_bin_path . '/' . $dir_name;

		$cnt++;
	}
}

1;
