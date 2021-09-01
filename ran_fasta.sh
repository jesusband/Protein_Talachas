#!/bin/bash

#Author: Jesús Banda
#Converts a ranga file into a fasta file
#Usage: ran_fasta.sh <input.ran> <output.fasta>

sed -r 's/^\s+//' $1 | sed 's/^/>/' | tr "\t" "\n" | fold -w 60 > $2
