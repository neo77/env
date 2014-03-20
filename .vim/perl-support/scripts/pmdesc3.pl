neo.orgneo.org#!/usr/bin/perl
neo.orgneo.org#===================================================================================
neo.orgneo.org#
neo.orgneo.org#         FILE:  pmdesc3
neo.orgneo.org#
neo.orgneo.org#     SYNOPSIS:  Find versions and descriptions of installed perl Modules and PODs
neo.orgneo.org#
neo.orgneo.org#  DESCRIPTION:  See POD below.
neo.orgneo.org#
neo.orgneo.org#      CREATED:  15.06.2004 22:12:41 CEST
neo.orgneo.org#     REVISION:  $Id: pmdesc3.pl,v 1.1.1.1 2012/01/28 10:22:30 mehner Exp $
neo.orgneo.org#         TODO:  Replace UNIX sort pipe.
neo.orgneo.org#                 
neo.orgneo.org#===================================================================================
neo.orgneo.org
neo.orgneo.orgpackage pmdesc3;
neo.orgneo.org
neo.orgneo.orgrequire 5.6.1;
neo.orgneo.org
neo.orgneo.orguse strict;
neo.orgneo.orguse warnings;
neo.orgneo.orguse Carp;
neo.orgneo.orguse ExtUtils::MakeMaker;
neo.orgneo.orguse File::Find           qw(find);
neo.orgneo.orguse Getopt::Std          qw(getopts);
neo.orgneo.org#use version;
neo.orgneo.orgour $VERSION        = qw(1.2.3);  # update POD at the end of this file
neo.orgneo.org
neo.orgneo.orgmy  $MaxDescLength  = 150;        # Maximum length for the description field:
neo.orgneo.org                                  # prevents slurping in big amount of faulty docs.
neo.orgneo.org
neo.orgneo.orgmy  $rgx_version  = q/\Av?\d+(\.\w+)*\Z/; # regex for module versions 
neo.orgneo.org
neo.orgneo.org#===  FUNCTION  ====================================================================
neo.orgneo.org#         NAME:  usage
neo.orgneo.org#===================================================================================
neo.orgneo.orgsub usage {
neo.orgneo.org  my  $searchdirs = " "x12;
neo.orgneo.org  $searchdirs .= join( "\n"." "x12, sort { length $b <=> length $a } @INC ) . "\n";
neo.orgneo.org  print <<EOT;
neo.orgneo.orgUsage:   pmdesc3.pl [-h] [-s] [-t ddd] [-v dd] [--] [dir [dir [dir [...]]]]
neo.orgneo.orgOptions:  -h         print this message
neo.orgneo.org          -s         sort output (not under Windows)
neo.orgneo.org          -t ddd     name column has width ddd (1-3 digits); default 36
neo.orgneo.org          -v  dd     version column has width ddd (1-3 digits); default 10
neo.orgneo.org          If no directories given, searches:
neo.orgneo.org$searchdirs
neo.orgneo.orgEOT
neo.orgneo.org  exit;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#===  FUNCTION  ====================================================================
neo.orgneo.org#         NAME:  get_module_name
neo.orgneo.org#===================================================================================
neo.orgneo.orgsub get_module_name {
neo.orgneo.org  my ($path, $relative_to) = @_;
neo.orgneo.org
neo.orgneo.org  local $_ = $path;
neo.orgneo.org  s!\A\Q$relative_to\E/?!!;
neo.orgneo.org  s! \.p(?:m|od) \z!!x;
neo.orgneo.org  s!/!::!g;
neo.orgneo.org
neo.orgneo.org  return $_;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#===  FUNCTION  ====================================================================
neo.orgneo.org#         NAME:  get_module_description
neo.orgneo.org#===================================================================================
neo.orgneo.orgsub get_module_description 
neo.orgneo.org{
neo.orgneo.org  my  $desc;
neo.orgneo.org  my  ($INFILE_file_name) = @_;                 # input file name
neo.orgneo.org
neo.orgneo.org  undef $/;                                     # undefine input record separator
neo.orgneo.org
neo.orgneo.org  open  my $INFILE, '<', $INFILE_file_name
neo.orgneo.org      or die  "$0 : failed to open  input file '$INFILE_file_name' : $!\n";
neo.orgneo.org
neo.orgneo.org  my  $file = <$INFILE>;                        # slurp mode
neo.orgneo.org
neo.orgneo.org  close  $INFILE
neo.orgneo.org      or warn "$0 : failed to close input file '$INFILE_file_name' : $!\n";
neo.orgneo.org
neo.orgneo.org  $file =~  s/\cM\cJ/\cJ/g;                     # remove DOS line ends 
neo.orgneo.org  $file =~  m/\A=head1\s+NAME(.*?)\n=\w+/s;     # file starts with '=head1' (PODs)
neo.orgneo.org  $desc = $1;
neo.orgneo.org
neo.orgneo.org  if ( ! defined $desc  )
neo.orgneo.org  {
neo.orgneo.org    $file =~  m/\n=head1\s+NAME(.*?)\n=\w+/s;   # '=head1' is embedded
neo.orgneo.org    $desc = $1;
neo.orgneo.org  }
neo.orgneo.org
neo.orgneo.org  if ( ! defined $desc  )
neo.orgneo.org  {
neo.orgneo.org    $file =~  m/\n=head1\s+DESCRIPTION(.*?)\n=\w+/s; # '=head1' is embedded
neo.orgneo.org    $desc = $1;
neo.orgneo.org  }
neo.orgneo.org
neo.orgneo.org  if ( defined $desc )
neo.orgneo.org  {
neo.orgneo.org    $desc =~ s/B<([^>]+)>/$1/gs;                # remove bold markup
neo.orgneo.org    $desc =~ s/C<([^>]+)>/'$1'/gs;              # single quotes to indicate literal
neo.orgneo.org    $desc =~ s/E<lt>/</gs;                      # replace markup for <
neo.orgneo.org    $desc =~ s/E<gt>/>/gs;                      # replace markup for >
neo.orgneo.org    $desc =~ s/F<([^>]+)>/$1/gs;                # remove filename markup
neo.orgneo.org    $desc =~ s/I<([^>]+)>/$1/gs;                # remove italic markup
neo.orgneo.org    $desc =~ s/L<([^>]+)>/$1/gs;                # remove link markup
neo.orgneo.org    $desc =~ s/X<([^>]+)>//gs;                  # remove index markup
neo.orgneo.org    $desc =~ s/Z<>//gs;                         # remove zero-width character
neo.orgneo.org    $desc =~ s/S<([^>]+)>/$1/gs;                # remove markup for nonbreaking spaces
neo.orgneo.org
neo.orgneo.org    $desc =~ s/\A[ \t\n]*//s;                   # remove leading whitespaces
neo.orgneo.org    $desc =~ s/\n\s+\n/\n\n/sg;                 # make true empty lines
neo.orgneo.org    $desc =~ s/\n\n.*$//s;                      # discard all trailing paragraphs
neo.orgneo.org    $desc =~ s/\A.*?\s+-+\s+//s;                # discard leading module name
neo.orgneo.org    $desc =~ s/\n/ /sg;                         # join lines
neo.orgneo.org    $desc =~ s/\s+/ /g;                         # squeeze whitespaces
neo.orgneo.org    $desc =~ s/\s*$//g;                         # remove trailing whitespaces
neo.orgneo.org    $desc =  substr $desc, 0, $MaxDescLength;   # limited length
neo.orgneo.org  }
neo.orgneo.org  return $desc;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#===  FUNCTION  ====================================================================
neo.orgneo.org#         NAME:  get_module_version
neo.orgneo.org#===================================================================================
neo.orgneo.orgsub get_module_version {
neo.orgneo.org  local $_;                                     # MM->parse_version is naughty
neo.orgneo.org  my $vers_code = MM->parse_version($File::Find::name) || '';
neo.orgneo.org  $vers_code = undef unless $vers_code =~ /$rgx_version/;
neo.orgneo.org  return $vers_code;
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#===  FUNCTION  ====================================================================
neo.orgneo.org#         NAME:  MAIN
neo.orgneo.org#===================================================================================
neo.orgneo.org
neo.orgneo.orgmy %visited;
neo.orgneo.org
neo.orgneo.org$|++;
neo.orgneo.org
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.org#  process options and command line arguments
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.orgmy  %options;
neo.orgneo.org
neo.orgneo.orggetopts("hst:v:", \%options)         or $options{h}=1;
neo.orgneo.org
neo.orgneo.orgmy  @args = @ARGV;
neo.orgneo.org@ARGV = @INC unless @ARGV;
neo.orgneo.org
neo.orgneo.orgusage() if $options{h};                               #  option -h  :  usage
neo.orgneo.org
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.org#  option -t : width of the module name column
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.orgusage() if $options{t} && $options{t}!~/^\d{1,3}$/;   # width 1-3 digits
neo.orgneo.org
neo.orgneo.org$options{t} = "36" unless $options{t};
neo.orgneo.org
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.org#  option -v : width of the version column
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.orgusage() if $options{v} && $options{v}!~/^\d{1,2}$/;   # width 1-2 digits
neo.orgneo.org
neo.orgneo.org$options{v} = "10" unless $options{v};
neo.orgneo.org
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.org#  option -s  :  install an output filter to sort the module list
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.orgif ($options{s}) {
neo.orgneo.org    usage() if $^O eq "MSWin32";
neo.orgneo.org    if ( open(ME, "-|") ) {
neo.orgneo.org        $/ = "";
neo.orgneo.org        while ( <ME> ) {
neo.orgneo.org            chomp;
neo.orgneo.org            print join("\n", sort split /\n/), "\n";
neo.orgneo.org        }
neo.orgneo.org        exit;
neo.orgneo.org    }
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.org#  process 
neo.orgneo.org#---------------------------------------------------------------------------
neo.orgneo.org# 
neo.orgneo.org# :WARNING:15.04.2005:Mn: under Windows descending into subdirs will be
neo.orgneo.org# suppressed by the the preprocessing part of the following call to find
neo.orgneo.org# :TODO:16.04.2005:Mn: remove code doubling
neo.orgneo.org# 
neo.orgneo.orgif ( $^O ne "MSWin32" ) {                       # ----- UNIX, Linux, ...
neo.orgneo.org
neo.orgneo.org    for my $inc_dir (sort { length $b <=> length $a } @ARGV) {
neo.orgneo.org        find({
neo.orgneo.org                wanted => sub {
neo.orgneo.org                    return unless /\.p(?:m|od)\z/ && -f;
neo.orgneo.org
neo.orgneo.org                    #---------------------------------------------------------------------
neo.orgneo.org                    #  return from function if there exists a pod-file for this module
neo.orgneo.org                    #---------------------------------------------------------------------
neo.orgneo.org                    my $pod = $_;
neo.orgneo.org                    my $pm  = $_;
neo.orgneo.org                    if ( m/\.pm\z/ )
neo.orgneo.org                    {
neo.orgneo.org                        $pod  =~ s/\.pm\z/\.pod/; 
neo.orgneo.org                        return if -f $pod;
neo.orgneo.org                    }
neo.orgneo.org
neo.orgneo.org                    my $module  = get_module_name($File::Find::name, $inc_dir);
neo.orgneo.org                    my $version;
neo.orgneo.org                    if ( /\.pod\z/ )
neo.orgneo.org                    {
neo.orgneo.org                        $pm =~ s/\.pod\z/\.pm/; 
neo.orgneo.org                        #-------------------------------------------------------------------
neo.orgneo.org                        #  try to find the version from the pm-file
neo.orgneo.org                        #-------------------------------------------------------------------
neo.orgneo.org                        if ( -f $pm )
neo.orgneo.org                        {
neo.orgneo.org                            local $_;
neo.orgneo.org                            $version = MM->parse_version($pm) || "";
neo.orgneo.org                            $version = undef unless $version =~ /$rgx_version/;
neo.orgneo.org                        }
neo.orgneo.org                    }
neo.orgneo.org                    else
neo.orgneo.org                    {
neo.orgneo.org                        $version = get_module_version($_);
neo.orgneo.org                    }
neo.orgneo.org                    my $desc = get_module_description($_);
neo.orgneo.org
neo.orgneo.org                    $version = defined $version ? " ($version)" : " (n/a)";
neo.orgneo.org                    $desc    = defined $desc    ? " $desc"      : " <description not available>";
neo.orgneo.org
neo.orgneo.org                    printf("%-${options{t}}s%-${options{v}}s%-s\n", $module, $version, $desc ); 
neo.orgneo.org
neo.orgneo.org                },
neo.orgneo.org
neo.orgneo.org                preprocess => sub {
neo.orgneo.org                    my ($dev, $inode) = stat $File::Find::dir or return;
neo.orgneo.org                    $visited{"$dev:$inode"}++ ? () : @_;
neo.orgneo.org                },
neo.orgneo.org            },
neo.orgneo.org            $inc_dir);
neo.orgneo.org    }
neo.orgneo.org}
neo.orgneo.orgelse {                                          # ----- MS Windows
neo.orgneo.org    for my $inc_dir (sort { length $b <=> length $a } @ARGV) {
neo.orgneo.org        find({
neo.orgneo.org                wanted => sub {
neo.orgneo.org                    return unless /\.p(?:m|od)\z/ && -f;
neo.orgneo.org
neo.orgneo.org                    #---------------------------------------------------------------------
neo.orgneo.org                    #  return from function if there exists a pod-file for this module
neo.orgneo.org                    #---------------------------------------------------------------------
neo.orgneo.org                    my $pod = $_;
neo.orgneo.org                    my $pm  = $_;
neo.orgneo.org                    if ( m/\.pm\z/ )
neo.orgneo.org                    {
neo.orgneo.org                        $pod  =~ s/\.pm\z/\.pod/; 
neo.orgneo.org                        return if -f $pod;
neo.orgneo.org                    }
neo.orgneo.org
neo.orgneo.org                    my $module  = get_module_name($File::Find::name, $inc_dir);
neo.orgneo.org                    my $version;
neo.orgneo.org                    if ( /\.pod\z/ )
neo.orgneo.org                    {
neo.orgneo.org                        $pm =~ s/\.pod\z/\.pm/; 
neo.orgneo.org                        #-------------------------------------------------------------------
neo.orgneo.org                        #  try to find the version from the pm-file
neo.orgneo.org                        #-------------------------------------------------------------------
neo.orgneo.org                        if ( -f $pm )
neo.orgneo.org                        {
neo.orgneo.org                            local $_;
neo.orgneo.org                            $version = MM->parse_version($pm) || "";
neo.orgneo.org                            $version = undef unless $version =~ /$rgx_version/;
neo.orgneo.org                        }
neo.orgneo.org                    }
neo.orgneo.org                    else
neo.orgneo.org                    {
neo.orgneo.org                        $version = get_module_version($_);
neo.orgneo.org                    }
neo.orgneo.org                    my $desc = get_module_description($_);
neo.orgneo.org
neo.orgneo.org                    $version = defined $version ? " ($version)" : " (n/a)";
neo.orgneo.org                    $desc    = defined $desc    ? " $desc"      : " <description not available>";
neo.orgneo.org
neo.orgneo.org                    printf("%-${options{t}}s%-${options{v}}s%-s\n", $module, $version, $desc ); 
neo.orgneo.org
neo.orgneo.org                },
neo.orgneo.org            },
neo.orgneo.org            $inc_dir);
neo.orgneo.org    }
neo.orgneo.org}
neo.orgneo.org
neo.orgneo.org#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neo.orgneo.org#  Modul Documentation
neo.orgneo.org#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neo.orgneo.org
neo.orgneo.org=head1 NAME
neo.orgneo.org  
neo.orgneo.orgpmdesc3 - List name, version, and description of all installed perl modules and PODs
neo.orgneo.org
neo.orgneo.org=head1 SYNOPSIS
neo.orgneo.org
neo.orgneo.org    pmdesc3.pl
neo.orgneo.org
neo.orgneo.org    pmdesc3.pl ~/perllib
neo.orgneo.org
neo.orgneo.org=head1 DESCRIPTION
neo.orgneo.org
neo.orgneo.org  pmdesc3.pl [-h] [-s] [-t ddd] [-v dd] [--] [dir [dir [dir [...]]]]
neo.orgneo.org
neo.orgneo.org  OPTIONS:  -h     : print help message; show search path
neo.orgneo.org            -s     : sort output (not under Windows)
neo.orgneo.org            -t ddd : name column has width ddd (1-3 digits); default 36
neo.orgneo.org            -v  dd : version column has width dd (1-2 digits); default 10
neo.orgneo.org
neo.orgneo.orgFind name, version and description of all installed Perl modules and PODs.
neo.orgneo.orgIf no directories given, searches @INC .
neo.orgneo.orgThe first column of the output (see below) can be used as module name or
neo.orgneo.orgFAQ-name for perldoc.
neo.orgneo.org
neo.orgneo.orgSome modules are split into a pm-file and an accompanying pod-file.
neo.orgneo.orgThe version number is always taken from the pm-file.
neo.orgneo.org
neo.orgneo.orgThe description found will be cut down to a length of at most
neo.orgneo.org150 characters (prevents slurping in big amount of faulty docs).
neo.orgneo.org
neo.orgneo.org
neo.orgneo.org=head2 Output
neo.orgneo.org
neo.orgneo.orgThe output looks like this:
neo.orgneo.org
neo.orgneo.org   ...
neo.orgneo.orgIO::Socket         (1.28)  Object interface to socket communications
neo.orgneo.orgIO::Socket::INET   (1.27)  Object interface for AF_INET domain sockets
neo.orgneo.orgIO::Socket::UNIX   (1.21)  Object interface for AF_UNIX domain sockets
neo.orgneo.orgIO::Stty           (n/a)   <description not available>
neo.orgneo.orgIO::Tty            (1.02)  Low-level allocate a pseudo-Tty, import constants.
neo.orgneo.orgIO::Tty::Constant  (n/a)   Terminal Constants (autogenerated)
neo.orgneo.org   ...
neo.orgneo.org
neo.orgneo.orgThe three parts module name, version and description are separated
neo.orgneo.orgby at least one blank.
neo.orgneo.org
neo.orgneo.org=head1 REQUIREMENTS
neo.orgneo.org
neo.orgneo.orgExtUtils::MakeMaker, File::Find, Getopt::Std
neo.orgneo.org
neo.orgneo.org=head1 BUGS AND LIMITATIONS
neo.orgneo.org
neo.orgneo.orgThe command line switch -s (sort) is not available under non-UNIX operating
neo.orgneo.orgsystems.  An additional shell sort command can be used.
neo.orgneo.org
neo.orgneo.orgThere are no known bugs in this module.
neo.orgneo.org
neo.orgneo.orgPlease report problems to Fritz Mehner, mehner@fh-swf.de .
neo.orgneo.org
neo.orgneo.org=head1 AUTHORS
neo.orgneo.org
neo.orgneo.org  Tom Christiansen, tchrist@perl.com (pmdesc)
neo.orgneo.org  Aristotle, http://qs321.pair.com/~monkads/ (pmdesc2)
neo.orgneo.org  Fritz Mehner, mehner@fh-swf.de (pmdesc3.pl)
neo.orgneo.org
neo.orgneo.org=head1 NOTES
neo.orgneo.org
neo.orgneo.orgpmdesc3.pl is based on pmdesc2 (Aristotle, http://qs321.pair.com/~monkads/).
neo.orgneo.orgpmdesc3.pl adds extensions and bugfixes.
neo.orgneo.org
neo.orgneo.orgpmdesc2 is based on pmdesc (Perl Cookbook, 1. Ed., recipe 12.19).
neo.orgneo.orgpmdesc2 is at least one magnitude faster than pmdesc.
neo.orgneo.org
neo.orgneo.org=head1 VERSION
neo.orgneo.org
neo.orgneo.org1.2.3
neo.orgneo.org
neo.orgneo.org=cut
neo.orgneo.org
