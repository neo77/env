neo.orgneo.org
neo.orgneo.org#----------------------------------------------------------------------
neo.orgneo.org#  subroutine : print_hash
neo.orgneo.org#----------------------------------------------------------------------
neo.orgneo.orgsub print_hash {
neo.orgneo.org  my  $hashref  = shift;      # 1. parameter : hash reference
neo.orgneo.org  print "\n";
neo.orgneo.org  while ( my ( $key, $value ) = each %$hashref ) {
neo.orgneo.org    print "'$key'\t=>\t'$value'\n";
neo.orgneo.org  }       # -----  end while  -----
neo.orgneo.org} # ----------  end of subroutine print_hash  ----------
neo.orgneo.org
