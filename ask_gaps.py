#!/usr/bin/python2.7
# -- coding: utf-8 --
# Author: Jesús Banda
# Calculates and display the percentage of gaps at every position in a ran alignment.

from sys import argv
import re

try:
    script, ranga = argv
except ValueError:
    print "\nUsage: askgaps.py <rangafile>\n"
    
ran = open(ranga)
ran_lines = ran.readlines() #list of lines
ran.close()

def size(num): #Initializes the gaps counting vector
    gaps = [] # gaps per site
    for i in range(num):
        gaps.append([])
        gaps[i] = 0
    return gaps

## JUST FOR THE BEGINNING
line = ran_lines[0].split('\t') #separates name and seq 
sequence = line[1].rstrip() # similar to chomp in perl
gaps = size(len(sequence)) #Global variable
##

for i in range(len(ran_lines)):
    linex = ran_lines[i].split('\t') #separates name and seq
    seq = linex[1].rstrip() # similar to chomp in perl
    sites = list(seq) # similar to split(//,$linex[1]) in perl
    #gaps = size(len(sites))
    for j in range(len(sites)):
        if re.search(r'\-', sites[j]):
            gaps[j] += 1 # no actualiza más allá de la primer secuencia
        else:
            pass
            
    
print "There are %s sequences and %s sites per sequence\n" % (len(ran_lines), len(gaps))
print "Site\tGaps\tPercentage of gaps\n"
for i in range(len(gaps)):
    percent = (gaps[i] * 100.0) / len(ran_lines)
    print "%s\t%s\t%s\n" % (i+1, gaps[i], percent)

