#!/bin/bash

#Author: Jesús Banda
#Converts a stockholm alignment (from HMMER) into fasta format. It needs the stockholm2fasta.pl script be present in the ~/bin directory.
#Usage: sto_fasta.sh <input.sto> <output.fasta>

stockholm2fasta.pl -g $1 > $1.fas
sed -i 's/\.//g' $1.fas
sed -i 's/[a-z]//g' $1.fas
cat $1.fas | sed '/^>/ s/$/\*/' | tr -d "\n" | sed 's/>/\n>/g' | sed 's/\*/\n/' | fold -w 60 > $2
sed -i '/^$/d' $2
rm $1.fas