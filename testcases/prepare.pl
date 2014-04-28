#!/usr/bin/env perl

use strict;
use warnings;
$|++;

use lib qw(./lib/);
use NapiTest qw/:all/;

print "Preparing shells\n";
NapiTest::prepare_shells();
