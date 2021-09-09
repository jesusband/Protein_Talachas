#!/usr/bin/python2.7
# -- coding: utf-8 --
# Author: Jesús Banda
# Truncates/Prunes a ran alignment to a particular sequence, which will not have any gap.
# NOTE: the query must have the same character length as the target(s) (gaps are welcome!!)

from sys import argv

try:
    script, ranga, query = argv
except ValueError:
    print "\nUsage: align_trunc.py <MSA.ran> <seqnum_query(reference_line)>\n"

ran = open(ranga)
ran_lines = ran.readlines() #list of lines
ran.close()

### For the query
wt = int(query) #same as a split('',query) in perl #wt is the reference
### For the ranga alignment
line = ran_lines[wt-1].split('\t') #separates name and seq 
sequence = line[1].rstrip() # similar to chomp in perl


printable = [] #array for "printable" positions	
for i in range(len(sequence)): #positions scanner
	if sequence[i] != "-":
		printable.append(i)
	else:
		pass

#print printable
		
for i in range(len(ran_lines)):
	line = ran_lines[i].split('\t') #separates name and seq
	name = line[0]
	sec = list(line[1].rstrip()) #chomping
	print "%s\t%s" % (name, ''.join(list(sec[j] for j in printable))) #prints the selected positions per sequence
	
