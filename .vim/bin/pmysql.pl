#!/usr/bin/perl

use strict;
use warnings;
#=------------------------------------------------------------------------ USE, CONSTANTS..


use FindBin qw/$Bin/;
use lib $Bin."/../../../";

use Data::Dumper;

my $login = $ARGV[0];
$login = $ARGV[1] if $ARGV[1] =~ /[^"]p?mysql/;
$login = $ARGV[2] if $ARGV[2] =~ /[^"]p?mysql/;

$login =~ s/^\s*#\s*//;
$login =~ s/p?mysql:?//;
$login = '-uuser -hhost -ppass db' if $login =~ /defined/;
my $command = $ARGV[3];
$command =~ s/APOSMAKLOTA/'/g;
$|=1;
print (("-"x40)."\n");
$|=0;
open MYSQL, "|mysql $login --default-character-set=utf8";
print MYSQL $command;
close MYSQL;


