neo.orgneo.org
neo.orgneo.orguse File::Find;                   # File::Find - Traverse a directory tree
neo.orgneo.org
neo.orgneo.orgmy  @directory_list   = ( '.' );  # directory_list used by File::Find::find()
neo.orgneo.org
neo.orgneo.orgmy  $files_processed  = 0;        # counts the files processed by process_file()
neo.orgneo.org
neo.orgneo.org#-----------------------------------------------------------------------
neo.orgneo.org# Process a single file in a directory
neo.orgneo.org#-----------------------------------------------------------------------
neo.orgneo.orgsub process_file {
neo.orgneo.org  my  $filename      = $_;                # filename without directory
neo.orgneo.org  my  $filename_full = $File::Find::name; # filename with    directory
neo.orgneo.org  my  $directory     = $File::Find::dir;  # directory only
neo.orgneo.org
neo.orgneo.org  # print "$directory  :  $filename  :  $filename_full\n";
neo.orgneo.org
neo.orgneo.org  $files_processed++;
neo.orgneo.org
neo.orgneo.org  return ;
neo.orgneo.org} # ----------  end of subroutine process_file  ----------
neo.orgneo.org
neo.orgneo.org
neo.orgneo.org#-----------------------------------------------------------------------
neo.orgneo.org#  Process all files in a directory recursively
neo.orgneo.org#-----------------------------------------------------------------------
neo.orgneo.orgfind( \&process_file, @directory_list );
neo.orgneo.org
neo.orgneo.orgprint "\nfiles processed : $files_processed\n";
neo.orgneo.org
