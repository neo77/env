#!/usr/bin/perl

use strict;
use warnings;


#=------------------------------------------------------------------------ USE, CONSTANTS..


use lib $ENV{'HOME'}."/workspace/";



my $filename = $ARGV[0];
my $command = $ARGV[1];
my @inclist;
my $includes;
if ($filename =~ /pl$|pm$/) {
	open FILE, $filename;
	my @file = <FILE>;
	close FILE;
	@inclist = grep /^\s*(use\s+.*;)\s*$/, @file;

	for my $inc (@inclist) {
		chomp $inc;

		next if $inc =~ /\s*use\s*(?:lib|warnings|strict)/;
		$includes .= $inc if $inc;
	}
}
my $result;
eval {
	eval $includes if $includes;
	$result = eval $command
};
(print $@), exit if $@;
print "$result";
