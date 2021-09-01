#!/usr/bin/python2.7
# -- coding: utf-8 --
# Author: Jesús Banda
#It reads a file with a single column and a scalar integer, then do the proper arithmetic operation specified. Like a vector operation. Eg: SUM will do A + number
#It outputs position and new value
#NOTE: It only works for integer values

from sys import argv

try:
    script, lista, number, operation = argv
except ValueError:
    print "\nUsage: arit2.py <file> <scalar> <math_operation(SUM,DIFF,TIMES,DIV)>\n"
    
arch = open(lista)
arch_lines = arch.readlines()
arch.close()

for i in xrange(len(arch_lines)):
	line = arch_lines[i].rstrip()
	if operation in ['SUM']:
		print "%i %i" % (i+1, int(line)+int(number))
	elif operation in ['DIFF']:
		print "%i %i" % (i+1, int(line)-int(number))
	elif operation == "TIMES": #this sentence is different just to see that this way is also valid in python
		print "%i %i" % (i+1, int(line)*int(number))
	elif operation in ['DIV']:
		print "%i %i" % (i+1, int(line)/int(number))
	else:
		print "OPERATION ERROR"