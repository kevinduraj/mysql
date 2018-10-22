#!/usr/bin/perl
#-----------------------------------------------------------------------#
use Time::HiRes qw ( time alarm sleep );
use IO::Async::Loop;
use Net::Async::CassandraCQL;
use Protocol::CassandraCQL qw( CONSISTENCY_QUORUM CONSISTENCY_ANY );
$| = 1;

my $loop = IO::Async::Loop->new;
my $cass = Net::Async::CassandraCQL->new(
   host => "192.168.1.159",
   keyspace => "cloud4",
   default_consistency => CONSISTENCY_ANY,
   #default_consistency => CONSISTENCY_QUORUM,
);

$loop->add( $cass );
$cass->connect->get;
 
my @f;
my $filename = 'url-facebook.dat';

open(my $fh, $filename) or die "Could not open file '$filename' $!";

while (my $row = <$fh>) {

  $i++;

  chomp $row;
  next if $row =~ /(\'|\[|\%)/; 
  #next if length($row) < 10;
  #next if length($row) > 200;;
  #skip next if $i < 79_880_000; 

  # 1 Months TTL =  2_592_000
  # 2 Months TTL =  5_184_000 
  # 3 Months TTL =  7_776_000 
  # 6 Months TTL = 15_552_000
  # my $range   = 15_552_000;
  # my $minimum =  7_776_000;
  # my $random_number = int(rand($range)) + $minimum;
  # my $SQL = "INSERT INTO visit (url) VALUES ('$row') USING TTL $random_number;";

  my $SQL = "INSERT INTO lfacebook (url) VALUES ('$row');";
  push @f, $cass->query( $SQL );

  if ($i % 10000 == 0) {

      1 while ($1 =~ s/^(-?\d+)(\d{3})/$1,$2/); # print with thousand separator 
      print $i . " " . $SQL . "\n";
      Future->needs_all( @f )->get;
      @f=(); 
      #sleep 1;
  }

}
#-----------------------------------------------------------------------#
__END__

vi /usr/local/lib64/perl5/Protocol/CassandraCQL.pm


   TYPE_CUSTOM    => 0x0000,
   TYPE_ASCII     => 0x0001,
   TYPE_BIGINT    => 0x0002,
   TYPE_BLOB      => 0x0003,
   TYPE_BOOLEAN   => 0x0004,
   TYPE_COUNTER   => 0x0005,
   TYPE_DECIMAL   => 0x0006,
   TYPE_DOUBLE    => 0x0007,
   TYPE_FLOAT     => 0x0008,
   TYPE_INT       => 0x0009,
   TYPE_TEXT      => 0x000A,
   TYPE_TIMESTAMP => 0x000B,
   TYPE_UUID      => 0x000C,
   TYPE_VARCHAR   => 0x000D,
   TYPE_VARINT    => 0x000E,
   TYPE_TIMEUUID  => 0x000F,
   TYPE_INET      => 0x0010,
   TYPE_LIST      => 0x0020,
   TYPE_MAP       => 0x0021,
   TYPE_SET       => 0x0022,

   CONSISTENCY_ANY          => 0x0000,
   CONSISTENCY_ONE          => 0x0001,
   CONSISTENCY_TWO          => 0x0002,
   CONSISTENCY_THREE        => 0x0003,
   CONSISTENCY_QUORUM       => 0x0004,
   CONSISTENCY_ALL          => 0x0005,
   CONSISTENCY_LOCAL_QUORUM => 0x0006,
   CONSISTENCY_EACH_QUORUM  => 0x0007,
   CONSISTENCY_SERIAL       => 0x0008,
   CONSISTENCY_LOCAL_SERIAL => 0x0009,
   CONSISTENCY_LOCAL_ONE    => 0x000A,

