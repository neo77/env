neo.orgneo.org#!/usr/bin/perl 
neo.orgneo.org#===============================================================================
neo.orgneo.org#
neo.orgneo.org#         FILE:  csv2err.pl
neo.orgneo.org#
neo.orgneo.org#        USAGE:  ./csv2err.pl [-hH] -i CSV-file -n source-file [ -o outfile ][ -s criterion ]
neo.orgneo.org#
neo.orgneo.org#  DESCRIPTION:  Generate a Vim-quickfix compatible errorfile from a CSV-file 
neo.orgneo.org#                produced by Devel::NYTProf.
neo.orgneo.org#                Specify CSV-file with full path.
neo.orgneo.org#                Specify source-file with full path.
neo.orgneo.org#      OPTIONS:  ---
neo.orgneo.org# REQUIREMENTS:  ---
neo.orgneo.org#         BUGS:  ---
neo.orgneo.org#        NOTES:  ---
neo.orgneo.org#       AUTHOR:  Dr. Fritz Mehner (fgm), mehner@fh-swf.de
neo.orgneo.org#      COMPANY:  FH Südwestfalen, Iserlohn
neo.orgneo.org#      VERSION:  2.0
neo.orgneo.org#      CREATED:  13.02.2009 17:04:00
neo.orgneo.org#     REVISION:  $Id: csv2err.pl,v 1.1.1.1 2012/01/28 10:22:30 mehner Exp $
neo.orgneo.org#===============================================================================
neo.orgneo.org
neo.orgneo.orguse strict;
neo.orgneo.orguse warnings;
neo.orgneo.org
neo.orgneo.orguse Getopt::Std;
neo.orgneo.orguse File::Basename;
neo.orgneo.org
neo.orgneo.orgour( $opt_H, $opt_h, $opt_i, $opt_o, $opt_s, $opt_n );
neo.orgneo.orggetopts('hHi:o:s:n:');                            # process command line arguments
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  check for parameters
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.orgif ( defined $opt_h || !defined $opt_i ) {      # process option -h
neo.orgneo.org	usage();
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.orgmy	$criterion		= 'file line time calls time_per_call';
neo.orgneo.orgmy	$sortcriterion	= 'none';
neo.orgneo.org
neo.orgneo.orgif ( defined $opt_s ) {
neo.orgneo.org	$sortcriterion	= $opt_s;
neo.orgneo.org	usage() until $criterion =~ m/\b$opt_s\b/;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.orgmy  $csv_file_name = $opt_i;                    # input file name
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  output file
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org
neo.orgneo.orgif ( defined $opt_o ) {
neo.orgneo.org	open  FILE,  "> $opt_o" or do {
neo.orgneo.org		warn "Couldn't open $opt_o: $!.  Using STDOUT instead.\n";
neo.orgneo.org		undef $opt_o;
neo.orgneo.org	};
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.orgmy $handle = ( defined $opt_o ? \*FILE : \*STDOUT );
neo.orgneo.org
neo.orgneo.orgif ( defined $opt_o ) {
neo.orgneo.org	close  FILE
neo.orgneo.org		or warn "$0 : failed to close output file '$opt_o' : $!\n";
neo.orgneo.org	unlink $opt_o;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  prepare file names
neo.orgneo.org#  The quickfix format needs the absolute file name of the source file.
neo.orgneo.org#  This file name is constructed from the mame of the csv-file, e.g.
neo.orgneo.org#    PATH/nytprof/test-pl-line.csv
neo.orgneo.org#  gives
neo.orgneo.org#    PATH/test.pl
neo.orgneo.org#  The name of the output file is also constructed:
neo.orgneo.org#    PATH/nytprof/test.pl.err
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.orgmy  $src_filename	= $opt_n;
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  read the CSV-file
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.orgopen  my $csv, '<', $csv_file_name
neo.orgneo.org  or die  "$0 : failed to open  input file '$csv_file_name' : $!\n";
neo.orgneo.org
neo.orgneo.orgmy  $line;
neo.orgneo.orgforeach my $i ( 1..3 ) {                        # read the header
neo.orgneo.org	$line = <$csv>;
neo.orgneo.org	print $line;
neo.orgneo.org}
neo.orgneo.org$line = <$csv>;                                 # skip NYTProf format line
neo.orgneo.org
neo.orgneo.orgprint "#\n# sort criterion:  $sortcriterion\n";
neo.orgneo.orgprint    "#         FORMAT:  filename : line number : time : calls : time/call : code\n#\n";
neo.orgneo.org
neo.orgneo.orgmy  @rawline= <$csv>;                           # rest of the CSV-file
neo.orgneo.orgchomp @rawline;
neo.orgneo.org
neo.orgneo.orgclose  $csv
neo.orgneo.org  or warn "$0 : failed to close input file '$csv_file_name' : $!\n";
neo.orgneo.org
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.org# filter lines
neo.orgneo.org#  input format: <time>,<calls>,<time/call>,<source line> 
neo.orgneo.org# output format: <filename>:<line>:<time>:<calls>:<time/call>: <source line>
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.orgmy  $sourcelinenumber 	= 0;
neo.orgneo.orgmy  $sourceline;
neo.orgneo.orgmy  $cookedline;
neo.orgneo.orgmy  @linepart;
neo.orgneo.orgmy  @line;
neo.orgneo.orgmy	$delim	= ':';
neo.orgneo.org
neo.orgneo.org
neo.orgneo.orgforeach my $n ( 0..$#rawline ) {
neo.orgneo.org	$sourcelinenumber++;
neo.orgneo.org	@linepart    = split ( /,/, $rawline[$n] );
neo.orgneo.org	$sourceline	 = join( ',', @linepart[3..$#linepart] );
neo.orgneo.org	$cookedline  = $src_filename.$delim.$sourcelinenumber.$delim;
neo.orgneo.org	$cookedline .= join( $delim, @linepart[0..2] ).$delim.' ';
neo.orgneo.org	$cookedline .= $sourceline;
neo.orgneo.org	unless ( defined $opt_H && ( $linepart[0]+$linepart[1]+$linepart[2] == 0 ) ) {
neo.orgneo.org		push @line, $cookedline;
neo.orgneo.org	}
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  sort file names (field index 0)
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.orgif ( $sortcriterion eq 'file' ) {
neo.orgneo.org	@line	= sort {
neo.orgneo.org		my $ind	= ( $a !~ m/^[[:alpha:]]$delim/ ) ? 0 : 1;
neo.orgneo.org		my @a	= split /$delim/, $a;
neo.orgneo.org		my @b	= split /$delim/, $b;
neo.orgneo.org        $a[$ind] cmp $b[$ind];                  # ascending
neo.orgneo.org	} @line;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  sort line numbers (field index 1)
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.orgif ( $sortcriterion eq 'line' ) {
neo.orgneo.org	@line	= sort {
neo.orgneo.org		my $ind	= ( $a !~ m/^[[:alpha:]]$delim/ ) ? 1 : 2;
neo.orgneo.org		my @a	= split /$delim/, $a;
neo.orgneo.org		my @b	= split /$delim/, $b;
neo.orgneo.org        $a[$ind] <=> $b[$ind];                  # ascending
neo.orgneo.org	} @line;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  sort time (index 2)
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.orgif ( $sortcriterion eq 'time'  ) {
neo.orgneo.org	@line	= sort {
neo.orgneo.org		my $ind	= ( $a !~ m/^[[:alpha:]]$delim/ ) ? 2 : 3;
neo.orgneo.org		my @a	= split /$delim/, $a;
neo.orgneo.org		my @b	= split /$delim/, $b;
neo.orgneo.org        $b[$ind] <=> $a[$ind];                  # descending
neo.orgneo.org	} @line;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  sort calls (index 3)
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.orgif ( $sortcriterion eq 'calls'  ) {
neo.orgneo.org	@line	= sort {
neo.orgneo.org		my $ind	= ( $a !~ m/^[[:alpha:]]$delim/ ) ? 3 : 4;
neo.orgneo.org		my @a	= split /$delim/, $a;
neo.orgneo.org		my @b	= split /$delim/, $b;
neo.orgneo.org        $b[$ind] <=> $a[$ind];                  # descending
neo.orgneo.org	} @line;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  sort time_per_call (index 4)
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.orgif ( $sortcriterion eq 'time_per_call'  ) {
neo.orgneo.org	@line	= sort {
neo.orgneo.org		my $ind	= ( $a !~ m/^[[:alpha:]]$delim/ ) ? 4 : 5;
neo.orgneo.org		my @a	= split /$delim/, $a;
neo.orgneo.org		my @b	= split /$delim/, $b;
neo.orgneo.org        $b[$ind] <=> $a[$ind];                  # descending
neo.orgneo.org	} @line;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  write result
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.orgforeach my $line ( @line ) {
neo.orgneo.org	print $line, "\n";
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.org#  subroutine usage()
neo.orgneo.org#-------------------------------------------------------------------------------
neo.orgneo.orgsub usage {
neo.orgneo.orgprint <<EOF;
neo.orgneo.orgusage: $0 [-hH] -i CSV-file -n source-file  [ -o outfile ][ -s criterion ]
neo.orgneo.org  -h       this message
neo.orgneo.org  -H       hot spots only ( time, calls, and time/call are zero)
neo.orgneo.org  -i       input file (CSV)
neo.orgneo.org  -n       source file (*.pl or *.pm)
neo.orgneo.org  -s       sort criterion (file, line,  time, calls, time_per_call)
neo.orgneo.orgEOF
neo.orgneo.orgexit 0;
neo.orgneo.org}	# ----------  end of subroutine usage  ----------
