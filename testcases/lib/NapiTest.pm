#!/usr/bin/env perl

package NapiTest;

use strict;
use warnings;
$|++;

use Exporter ();
use LWP::Simple;
use Archive::Extract;

our @EXPORT = qw/
	prepare_assets
	prepare_shells
	generate_tree
/;

my $path_root = "/home/vagrant";

sub prepare_assets {

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
		bash-3.0.16.tar.gz
		bash-3.0.tar.gz
		bash-3.1.tar.gz
		bash-3.2.48.tar.gz
		bash-3.2.tar.gz
		bash-4.0-rc1.tar.gz
		bash-4.0.tar.gz
		bash-4.1.tar.gz
		bash-4.2.tar.gz
		bash-4.3.tar.gz
		/;

	die "Shell Source directory already exists - assuming that all sources already have been downloaded and compiled\n"
		if ( -e $shell_src_path && -d $shell_src_path );
	
	mkdir $shell_src_path;
	mkdir $shell_bin_path;
	STDOUT->autoflush(1);

	foreach (@versions) {

		my ($version) = m/^bash-(.*)?\.tar\.gz$/;
		my $dir_name = 'bash-' . $version;
		my $tgz_path = $shell_src_path . '/' . $_;
		my $dir_path = $shell_src_path . '/' . $dir_name;

		print "Downloading shell: [$_]\n" and getstore( $url . '/' . $_, $tgz_path );
		my $ae = Archive::Extract->new( archive => $shell_src_path . '/' . $_ );
		$ae->extract( to => $shell_src_path ) and print "Unpacked [$_]\n";

		# build it
		print ("Building...");
		system ('cd ' . $dir_path . ' && ./configure && make');

		symlink $dir_path . '/bash', $shell_bin_path . '/' . $dir_name;

	}


		

}

sub generate_tree {
	
}


1;