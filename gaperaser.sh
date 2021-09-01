#!/bin/bash

#usage: gaperaser.sh <aln.ran> <output>
#This script outputs erases the gaps from a ranga alignment. It is useful if an alignment program needs it this way (perhaps CD-HIT).
#AUTHOR: Jesús Banda (UNAM, CDMX)

echo "Usage: gaperaser.sh <aln.ran> <output>"

alin=$1
out=$2

awk -F "\t" '{ print $1 }' $alin > headers.borrame #headers
awk -F "\t" '{ print $NF }' $alin | sed 's/-//g' > seqs.borrame #ungapped sequences

paste headers.borrame seqs.borrame > $out
rm headers.borrame seqs.borrame
echo "DONE!! New file is $out"