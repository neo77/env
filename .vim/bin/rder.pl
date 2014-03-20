#!/usr/bin/perl

use strict;
use warnings;


#=------------------------------------------------------------------------ USE, CONSTANTS..



use Data::Dumper;

my $head = $ARGV[0];
my $line = $ARGV[1];

my ($sep) = `echo -e '$head' '\n' '$line' '\n' | $ENV{APOS_TOPDIR}/APos/tools/bin/recorddumper.pl - | grep Detected` =~ /Detected sep = (.*)$/g;
$sep=~s/(.)/\\\\\\$1/g;
my @result = `echo -e '$head' '\n' '$line' '\n' | $ENV{APOS_TOPDIR}/APos/tools/bin/recorddumper.pl - $sep 2 3`;
print join "",@result;


