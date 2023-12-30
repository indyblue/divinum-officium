use Data::Dumper;
my $debug = strictparam('debug');
if($debug eq 'cal') {
  #print Dumper(\$q);
  print  " $command == $dayname[0]\n";
  my $wr = $winner{Rank}; #=~ s/^\s+|\s+$//g;
  $wr =~ s/^\s+|\s+$//g;
  print  "  == $winner == $wr\n";
  if($commemoratio) {
    $wr = $commemoratio{Rank}; #=~ s/^\s+|\s+$//g;
    $wr =~ s/^\s+|\s+$//g;
    print "     $commemoratio == $wr\n";
  }
  if($commemoratio2) {
    $wr = $commemoratio2{Rank}; #=~ s/^\s+|\s+$//g;
    $wr =~ s/^\s+|\s+$//g;
    print "     $commemoratio2 == $wr\n";
  }
  exit(0);
}
1;