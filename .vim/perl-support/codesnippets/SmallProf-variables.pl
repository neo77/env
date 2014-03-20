neo.orgneo.org#
neo.orgneo.org# Devel::SmallProf : variables which can be used to affect what gets profiled.
neo.orgneo.org#
neo.orgneo.orguse Devel::SmallProf;
neo.orgneo.org
neo.orgneo.org$DB::drop_zeros  = 0;            # Do not show lines which were never called: 1
neo.orgneo.org$DB::grep_format = 0;            # Output on a format similar to grep : 1
neo.orgneo.org$DB::profile     = 1;            # Turn off profiling for a time: 0
neo.orgneo.org%DB::packages    = ('main'=>1);  # Only profile code in a certain package.
neo.orgneo.org
