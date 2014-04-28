#!/usr/bin/env perl

package NapiTest;

use strict;
use warnings;
use Exporter ();
use LWP::Simple;

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
	my $shell_bin_path = $path_root . '/' . $shell_src_bin;
	
	my %url = "http://ftp.gnu.org/gnu/bash";
	my @versions = qw/
		bash-1.14.7.tar.gz
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

	print "Shell Source directory already exists - assuming that all sources already have been downloaded and compiled\n"
		&& return if ( -e $shell_src_path && -d $shell_src_path );

	print "Downloading shell: [$_]\n" && getstore( $url . '/' . $_, $shell_src_path . '/' . $_ ) foreach (@versions);
		

}

sub generate_tree {
	
}


1;
