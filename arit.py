#!/usr/bin/python2.7
# -- coding: utf-8 --
# Author: Jesús Banda
#It reads a file with two columns (A B) separated by a space, then executes the aritmetic operation that the user specifies. Eg: SUM will do A + B
#NOTE: It only works for integer values

from sys import argv

try:
    script, lista, operation = argv
except ValueError:
    print "\nUsage: arit.py <file> <math_operation(SUM,DIFF,TIMES,DIV)>\n"
    
arch = open(lista)
arch_lines = arch.readlines()
arch.close()

for i in xrange(len(arch_lines)):
	line = arch_lines[i].split()
	if operation in ['SUM']:
		print "%i %i" % (i+1, int(line[0])+int(line[1]))
	elif operation in ['DIFF']:
		print "%i %i" % (i+1, int(line[0])-int(line[1]))
	elif operation == "TIMES": #this sentence is different just to see that this way is also valid in python
		print "%i %i" % (i+1, int(line[0])*int(line[1]))
	elif operation in ['DIV']:
		print "%i %i" % (i+1, int(line[0])/int(line[1]))
	else:
		print "OPERATION ERROR"
		
