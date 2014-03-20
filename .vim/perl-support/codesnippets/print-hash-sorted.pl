neo.orgneo.org
neo.orgneo.org#----------------------------------------------------------------------
neo.orgneo.org#  subroutine : print_hash_sorted
neo.orgneo.org#----------------------------------------------------------------------
neo.orgneo.orgsub print_hash_sorted {
neo.orgneo.org  my  $hashref  = shift;      # 1. parameter : hash reference
neo.orgneo.org  print "\n";
neo.orgneo.org  foreach my $key ( sort keys %$hashref ) {
neo.orgneo.org    print "'$key'\t=>\t'$$hashref{$key}'\n";
neo.orgneo.org  }       # -----  end foreach  -----
neo.orgneo.org} # ----------  end of subroutine print_hash_sorted  ----------
neo.orgneo.org
