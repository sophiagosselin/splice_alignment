#!/usr/bin/perl
use strict;
use warnings;

#Sophia Gosselin 2022
#Description: Takes an input multiple fasta sequence alignment and cuts out a section
#Usage: perl splice_alignment.pl START_OF_CUT END_OF_CUT
#if you want to cut off from the beginning use 0 as your cutoff1

#Inputs
my $alignment = $ARGV[0];
my $cutoff1 = $ARGV[1];
my $cutoff2 = $ARGV[2];
$cutoff1++;
$cutoff2++;
my $cutlength = $cutoff2-$cutoff1;

open(IN, "< $alignment");
my %sequences;
my $sequence = 0;
my $asc;
while(<IN>){
  chomp;
  if($_=~/\>/){
    if($sequence ne "0"){
      $sequences{$asc}=$sequence;
    }
    $asc=$_;
    $sequence="";
  }
  else{
    $sequence.=$_;
  }
}
$sequences{$asc}=$sequence;
close IN;

open(OUT, "+> $alignment.spliced");
open(SPLICE, "+> spliced_section.fasta");
foreach my $seq_alignment (keys %sequences){
  my @sequence_breakdown = split("",$sequences{$seq_alignment});
  my @splice_section = splice(@sequence_breakdown,$cutoff1,$cutlength);
  print OUT "$seq_alignment\n";
  print SPLICE "$seq_alignment\n";
  foreach my $pos (@sequence_breakdown){
    print OUT "$pos";
  }
  print OUT "\n";
  foreach my $pos (@splice_section){
    print SPLICE "$pos";
  }
  print SPLICE "\n";
}
close OUT;
close SPLICE;
