neo.orgneo.org#!/usr/bin/perl
neo.orgneo.org#APos: APosDoc=1.1
neo.orgneo.org#* Name: makeparam.pl
neo.orgneo.org#* Info: param maker
neo.orgneo.org#* Author: Pawel Guspiel (neo77), <neo77@panth-net.com || pawel.guspiel@hurra.com>
neo.orgneo.org#*
neo.orgneo.org#*
neo.orgneo.org
neo.orgneo.orguse strict;
neo.orgneo.orguse warnings;
neo.orgneo.org
neo.orgneo.org#=------------------------------------------------------------------------ USE, CONSTANTS..
neo.orgneo.org
neo.orgneo.orguse Template;	# template toolkit for param template
neo.orgneo.org
neo.orgneo.org
neo.orgneo.org
neo.orgneo.org#=------------------------------------------------------------------------ FUNCTIONS
neo.orgneo.org
neo.orgneo.org#=------------------------------------------------------------------------ main()
neo.orgneo.org
neo.orgneo.org
neo.orgneo.orgmy $tt = Template->new({'ABSOLUTE' => 1});
neo.orgneo.org$tt->process("$ENV{HOME}/.vim/bin/funct.param",{name => "$ARGV[0]", rq => "$ARGV[1]" });
neo.orgneo.org
