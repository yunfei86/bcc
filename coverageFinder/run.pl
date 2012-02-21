use strict;
use warnings;

my $infile=$ARGV[0]; #"test.coverage"
my $infile2="2_coverage/geneLength.txt"; #$ARGV[1];

my $stream=$ARGV[1];

my $outfile1="$infile.table";

my %hash;
my %pos;
my %strand;
open(IN,"<$infile") or die "can not open $infile !";
open(IN2,"<$infile2") or die "can not open $infile2 !";

open(OUT,">$outfile1") or die "can not open $outfile1 !";;

while(<IN2>){
  chomp;
  my @tmp=split/\t/,$_;
  my $key=join "\t",$tmp[0],$tmp[1];
  $hash{$key}=$tmp[2];
  #print $key."\n";
}

my $c=0;
while(<IN>){
  chomp;
  $c++;
  my @tmp=split/\t/,$_;
  my $key=join "\t",$tmp[0],$tmp[1];
  $key=join "\t",$key;
  if(! exists $pos{$key}){
    $pos{$key}=[];
  }
  $pos{$key}=[@{$pos{$key}},$tmp[10]];
  $strand{$key}=$tmp[6];
#  print "$tmp[6]\n";
#  print "$key | @{$pos{$key}}\n";
#  print $c."\n" if ($c % 100000 ==0 );
}

foreach my $i(keys %pos){
#  print $i."|".scalar(@{$pos{$i}})."|"."@{$pos{$i}}\n";
  if(lc($stream) eq "down"){
    if($strand{$i} eq "+"){
      my @depth=@{$pos{$i}};
      my $k=$#depth+1;
      while($k<1000){
	$depth[$k]=0;
      $k++;
      }
      print OUT $i ."\t".$strand{$i}."\t".$hash{$i}."\t".join("\t",@depth)."\n";
    }else{
      my @depth=reverse(@{$pos{$i}});
      my $k=$#depth+1;
      while($k<1000){
	$depth[$k]=0;
	$k++;
      }
      print OUT $i ."\t".$strand{$i}."\t".$hash{$i}."\t".join("\t",@depth)."\n";
    }
  }
  elsif(lc($stream) eq "up"){
    if($strand{$i} eq "-"){
      my @depth=@{$pos{$i}};
      my $k=$#depth+1;
      while($k<1000){
	$depth[$k]=0;
	$k++;
      }
      @depth=reverse(@depth);
      print OUT $i ."\t".$strand{$i}."\t".$hash{$i}."\t".join("\t",@depth)."\n";
    }else{
      my @depth=reverse(@{$pos{$i}});
      my $k=$#depth+1;
      while($k<1000){
	$depth[$k]=0;
	$k++;
      }
      @depth=reverse(@depth);
      print OUT $i ."\t".$strand{$i}."\t".$hash{$i}."\t".join("\t",@depth)."\n";
    }
  }
}


close(OUT);
close(IN);
close(IN2);
