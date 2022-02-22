#!/usr/bin/perl
# percentAA_site_nonracist.pl by Jesús Banda
# This script calculates the frequency of each site of a ran multiple sequence alignment regardless if the first sequence has gaps or not.
use strict; use warnings;

die "usage: percentAA_site_nonracist.pl <msa_file.ran>\n" unless @ARGV == 1;

open(my $ran, "$ARGV[0]") || die "File error\n";
my @aminos=("V","L","T","K","W","H","F","I","R","M","A","P","G","S","C","N","Q","Y","D","E"); #one letter code of aminoacids
#my @sites = (); #stores the different caracter states present in a site.
my $c = 0; #count
my $tam = 0; #universal sequence length
#my %resi = (); #residues hash (keys for residue, values for frequency) #v2
#my $msa = 0;
my $msa = `grep -c . $ARGV[0]`;
chomp $msa;
print "#Size of MSA is $msa\n";


while(<$ran>){
    my @seq = split ("\t", $_);
    $tam = $seq[1] =~ tr/[A-Z]|\-/[A-Z]\-/; #determines the length of the sequence, it only needs to be done once; since all sequences are the same length due to gaps.
    #print "#Each sequence has $tam sites\n"; #v1
    last;
}
close($ran);
#print "SITE\tRESIDUE\tCOUNT\n"; #version 1


for(my $site = 1; $site <= $tam; $site++){
    #print "$site\t";#version 1
    my $nogap = `cat $ARGV[0] | awk -F "\t" '{ print \$2 }' | awk -F "" '{ print \$$site }' | head -n 1`; #what is the caracter in the corresponding site of the first sequence (GUIDE sequence)
    chomp $nogap;
    
       my %resi = (); #v2
       foreach my $aa (@aminos){
           $c=`cat $ARGV[0] | awk -F "\t" '{ print \$2 }' | awk -F "" '{ print \$$site}' | grep -c "$aa"`;
           chomp $c;
           if($c){
               #print "$aa $c "; #version 1
               $resi{$aa} = $c; #v2
           }
       }
       # print "\n"; #version 1
       print "$site\t";
       foreach my $resn (sort {$resi{$b} <=> $resi{$a}} keys %resi){print "$resn"} #v2
       print "\t";
       my $acum = 0;
       foreach my $resn (sort {$resi{$b} <=> $resi{$a}} keys %resi) {my $perc = ($resi{$resn})*100/$msa; $acum += $perc; printf("%.1f", $perc); print ","}
       print "\tGAPS="; my $gap = 100 - $acum; printf ("%.1f", $gap);
       print "\n"; #v2
    
}
