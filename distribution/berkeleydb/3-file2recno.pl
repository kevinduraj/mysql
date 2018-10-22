#!/usr/bin/perl
# Convert BerkeleyDB File into Recno
# http://search.cpan.org/~pmqs/BerkeleyDB-0.39/BerkeleyDB.pod
#------------------------------------------------------------------------------#
use strict;
use warnings;
use BerkeleyDB;
use vars qw( @array $value $cnt );
$| = 1;

#------------------------------------------------------------------------------#
my $filename = "/home/temp/links3-url.dat";
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();                                                                                                                                                             
$year += 1900; $mon=sprintf("%02d",$mon+1); $mday=sprintf("%02d",$mday); 
my $database = "/home/temp/link3-$year-$mon-$mday.bdb";

#------------------------------------------------------------------------------#
#unlink($database);
tie @array, "BerkeleyDB::Recno",
  -Filename => $database,
  -Flags    => DB_CREATE,
  or die "Cannot open file $database: $! $BerkeleyDB::Error\n";

#------------------------------------------------------------------------------#

$cnt   = 0;
$value = 1;
&load_data($filename);
print "Total=" . $cnt . "\n";
untie @array;

#------------------------------------------------------------------------------#
sub load_data
{
    my $sourcefile = shift;
    open(FILE, $sourcefile) or die "$!";

    while (<FILE>)
    {
        chomp($_);
        $_ =~ s/\"//g;
        push(@array, "$_|$value");
        print "$cnt : " . $_ . "\n" if (($cnt % 30000) == 0);
        $cnt++;
    }

    close(FILE);
}

#------------------------------------------------------------------------------#
__END__

