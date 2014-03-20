neo.orgneo.org#!/usr/bin/perl -w
neo.orgneo.org
neo.orgneo.org# vimparse.pl - Reformats the error messages of the Perl interpreter for use
neo.orgneo.org# with the quickfix mode of Vim
neo.orgneo.org#
neo.orgneo.org# Copyright (©) 2001 by Jörg Ziefle <joerg.ziefle@gmx.de>
neo.orgneo.org# You may use and distribute this software under the same terms as Perl itself.
neo.orgneo.org#
neo.orgneo.org# Usage: put one of the two configurations below in your ~/.vimrc (without the
neo.orgneo.org# description and '# ') and enjoy (be sure to adjust the paths to vimparse.pl
neo.orgneo.org# before):
neo.orgneo.org#
neo.orgneo.org# Program is run interactively with 'perl -w':
neo.orgneo.org#
neo.orgneo.org# set makeprg=$HOME/bin/vimparse.pl\ %\ $*
neo.orgneo.org# set errorformat=%f:%l:%m
neo.orgneo.org#
neo.orgneo.org# Program is only compiled with 'perl -wc':
neo.orgneo.org#
neo.orgneo.org# set makeprg=$HOME/bin/vimparse.pl\ -c\ %\ $*
neo.orgneo.org# set errorformat=%f:%l:%m
neo.orgneo.org#
neo.orgneo.org# Usage:
neo.orgneo.org#	vimparse.pl [-c] [-f <errorfile>] <programfile> [programargs]
neo.orgneo.org#
neo.orgneo.org#		-c	compile only, don't run (perl -wc)
neo.orgneo.org#		-f	write errors to <errorfile>
neo.orgneo.org#
neo.orgneo.org# Example usages:
neo.orgneo.org#	* From the command line:
neo.orgneo.org#		vimparse.pl program.pl
neo.orgneo.org#
neo.orgneo.org#		vimparse.pl -c -f errorfile program.pl
neo.orgneo.org#		Then run vim -q errorfile to edit the errors with Vim.
neo.orgneo.org#
neo.orgneo.org#	* From Vim:
neo.orgneo.org#		Edit in Vim (and save, if you don't have autowrite on), then
neo.orgneo.org#		type ':mak' or ':mak args' (args being the program arguments)
neo.orgneo.org#		to error check.
neo.orgneo.org#
neo.orgneo.org# Version history:
neo.orgneo.org#	0.2 (04/12/2001):
neo.orgneo.org#		* First public version (sent to Bram)
neo.orgneo.org#		* -c command line option for compiling only
neo.orgneo.org#		* grammatical fix: 'There was 1 error.'
neo.orgneo.org#		* bug fix for multiple arguments
neo.orgneo.org#		* more error checks
neo.orgneo.org#		* documentation (top of file, &usage)
neo.orgneo.org#		* minor code clean ups
neo.orgneo.org#	0.1 (02/02/2001):
neo.orgneo.org#		* Initial version
neo.orgneo.org#		* Basic functionality
neo.orgneo.org#
neo.orgneo.org# Todo:
neo.orgneo.org#	* test on more systems
neo.orgneo.org#	* use portable way to determine the location of perl ('use Config')
neo.orgneo.org#	* include option that shows perldiag messages for each error
neo.orgneo.org#	* allow to pass in program by STDIN
neo.orgneo.org#	* more intuitive behaviour if no error is found (show message)
neo.orgneo.org#
neo.orgneo.org# Tested under SunOS 5.7 with Perl 5.6.0.  Let me know if it's not working for
neo.orgneo.org# you.
neo.orgneo.org
neo.orgneo.orguse strict;
neo.orgneo.orguse Getopt::Std;
neo.orgneo.org
neo.orgneo.orguse vars qw/$opt_c $opt_f $opt_h/; # needed for Getopt in combination with use strict 'vars'
neo.orgneo.org
neo.orgneo.orguse constant VERSION => 0.2;
neo.orgneo.org
neo.orgneo.orggetopts('cf:h');
neo.orgneo.org
neo.orgneo.org&usage if $opt_h; # not necessarily needed, but good for further extension
neo.orgneo.org
neo.orgneo.orgif (defined $opt_f) {
neo.orgneo.org
neo.orgneo.org    open FILE, "> $opt_f" or do {
neo.orgneo.org	warn "Couldn't open $opt_f: $!.  Using STDOUT instead.\n";
neo.orgneo.org	undef $opt_f;
neo.orgneo.org    };
neo.orgneo.org
neo.orgneo.org};
neo.orgneo.org
neo.orgneo.orgmy $handle = (defined $opt_f ? \*FILE : \*STDOUT);
neo.orgneo.org
neo.orgneo.org(my $file = shift) or &usage; # display usage if no filename is supplied
neo.orgneo.orgmy $args = (@ARGV ? ' ' . join ' ', @ARGV : '');
neo.orgneo.org
neo.orgneo.orgmy @lines = `perl @{[defined $opt_c ? '-c ' : '' ]} -w "$file$args" 2>&1`;
neo.orgneo.org
neo.orgneo.orgmy $errors = 0;
neo.orgneo.orgforeach my $line (@lines) {
neo.orgneo.org
neo.orgneo.org	chomp($line);
neo.orgneo.org	my ($file, $lineno, $message, $rest);
neo.orgneo.org	
neo.orgneo.org	# original line:
neo.orgneo.org	#	if ($line =~ /^(.*)\sat\s(.*)\sline\s(\d+)(\.|,\snear\s\".*\")$/) {
neo.orgneo.org	if ($line =~ /^(.*)\sat\s(.*)\sline\s(\d+)(\.|,\s(?:near\s\".*\"?|at end of line))$/) {
neo.orgneo.org
neo.orgneo.org		($message, $file, $lineno, $rest) = ($1, $2, $3, $4);
neo.orgneo.org		$errors++;
neo.orgneo.org		$message .= $rest if ($rest =~ s/^,//);
neo.orgneo.org		print $handle "$file:$lineno:$message\n";
neo.orgneo.org
neo.orgneo.org	} else { next };
neo.orgneo.org
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.orgif (defined $opt_f) {
neo.orgneo.org
neo.orgneo.org	my $msg;
neo.orgneo.org	if ($errors == 1) {
neo.orgneo.org
neo.orgneo.org		$msg = "There was 1 error.\n";
neo.orgneo.org
neo.orgneo.org	} else {
neo.orgneo.org
neo.orgneo.org		$msg = "There were $errors errors.\n";
neo.orgneo.org
neo.orgneo.org	};
neo.orgneo.org
neo.orgneo.org	print STDOUT $msg;
neo.orgneo.org	close FILE;
neo.orgneo.org	unlink $opt_f unless $errors;
neo.orgneo.org
neo.orgneo.org};
neo.orgneo.org
neo.orgneo.orgsub usage {
neo.orgneo.org
neo.orgneo.org    (local $0 = $0) =~ s/^.*\/([^\/]+)$/$1/; # remove path from name of program
neo.orgneo.org    print<<EOT;
neo.orgneo.orgUsage:
neo.orgneo.org	$0 [-c] [-f <errorfile>] <programfile> [programargs]
neo.orgneo.org
neo.orgneo.org		-c	compile only, don't run (executes 'perl -wc')
neo.orgneo.org		-f	write errors to <errorfile>
neo.orgneo.org
neo.orgneo.orgExamples:
neo.orgneo.org	* At the command line:
neo.orgneo.org		$0 program.pl
neo.orgneo.org		Displays output on STDOUT.
neo.orgneo.org
neo.orgneo.org		$0 -c -f errorfile program.pl
neo.orgneo.org		Then run 'vim -q errorfile' to edit the errors with Vim.
neo.orgneo.org
neo.orgneo.org	* In Vim:
neo.orgneo.org		Edit in Vim (and save, if you don't have autowrite on), then
neo.orgneo.org		type ':mak' or ':mak args' (args being the program arguments)
neo.orgneo.org		to error check.
neo.orgneo.orgEOT
neo.orgneo.org
neo.orgneo.org    exit 0;
neo.orgneo.org
neo.orgneo.org};
