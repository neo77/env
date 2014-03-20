neo.orgneo.org#!/usr/bin/perl
neo.orgneo.org##
neo.orgneo.orguse Template;
neo.orgneo.org
neo.orgneo.orgmy $tt = Template->new({'ABSOLUTE' => 1});
neo.orgneo.org$tt->process("$ENV{HOME}/.vim/bin/funct",{name => "$ARGV[0]"});
neo.orgneo.org
