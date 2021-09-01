#!/bin/bash

#usage xmaffter.sh <lowerAAlimit> <mafftalgoritm> <mafftoptions(see MAFFT v7 manual)>
#This script reads any ranga (which must have ran extension) file from the current directory, and makes a mafft v7.299 alignment according to the mafft algorith chosen (mafft, linsi,ginsi, etc see MANUAL: http://mafft.cbrc.jp/alignment/software/manual/manual.html#lbAI) and the options specified by the user "--auto,--6merpair,--globalpair,--inputorder,etc" (check MAFFT manual)
#If no options are specified, "--auto" is the default
#Author: Jesús Banda
#NOTE: It is assumed that the sequences who present less gaps are the main responsible for them, which does not necessarily mean we want to delete them!!!

echo "usage xmaffter.sh <lowerAAlimit> <mafftalgoritm> <mafftoptions(see MAFFT v7 manual)>"
#iter=0

argus=( "$@" ) #Make a copy of the original arguments
minaalim=( "${argus[0]}" ) #extract the firt value
echo "MINIMAL AMINOACID LENGTH CHOSEN: $minaalim"
pop=0 #para hacer un pop del primer elemento
argus=(${argus[@]:0:$pop} ${argus[@]:$(($pop + 1))})

for filename in *.ran

do
	iter=0
	ran_fasta.sh $filename $filename.$iter.fasta
	nseqsr=1
	nseqsrb=0
	seqlength=`head -n 1 $filename | awk '{ print $NF }' | sed 's/-//g' | awk '{ print length }'` #deberia usar esta variable
	#minaalim=$(( seqlength/2 )) #Minimal Aminoacid length, comment this line and uncomment next one to change number
	#minaalim=190 #Minimal Aminoacid length #esto puede editarse a un número particular
	while [ $nseqsr != $nseqsrb ];do
		echo "Processing $filename.$iter.fasta ..."
        	${argus[@]} $filename.$iter.fasta > $filename.aln.$iter.fasta #I used $@ because the number of arguments in the script can vary.
        	#
        	#Returning to ranga
        	fasta_ran.pl $filename.aln.$iter.fasta $filename.aln.$iter.RAN #I let RAN extension in uppercase to avoid confusing with the previos ran files.
        	nseqsr=`grep -c . $filename.aln.$iter.RAN` #number of sequences per new ranga file
        	#echo "showing nseqsr"
        	#echo $nseqsr
        	
        
        	#Python
        	awk '{ print $NF }' $filename.aln.$iter.RAN | sed 's/-//g' | awk '{ print length }' > A.$iter #puntual seq length
        	awk '{ print $NF }' $filename.aln.$iter.RAN | sed 's/[Aa-Zz]//g' | awk '{ print length }' > B.$iter #puntual sequence gap length
        	arit2.py A.$iter $minaalim DIV | awk '{ print $NF }' > C.$iter #esto es sucio, pero me deshago de secuencias muy pequeñas #problema aqui
        	gapmean=`awk '{ total += $1 } END { print total/NR }' B.$iter` #determine the gap average
        	threshold=$(bc <<< "scale=3;$gapmean/$minaalim")
        	threshold=${threshold%.*} #take away the decimal fraction, although 1.999 will become just 1.
        	if [ -n "$threshold" ]; then #if threshold length is not zero (will be zero lenght because of bc delivering .5 or .2 and the int above screwed us)
        		arit2.py C.$iter $minaalim TIMES | awk '{ print $NF }' | sed 's/^0/99999999999/' > D.$iter
        		paste B.$iter D.$iter > $filename.$iter.proc.piton #I try to keep sequeces with many gaps, throwing away the ones who open those gaps
        		flag=1 #flag for the ifs
        	
        		if [ "$threshold" -le 1 ] && [ "$flag" -eq 1 ]; then
        			echo "New threshold $threshold is less than or equal to 1"
        			parased=`arit.py $filename.$iter.proc.piton DIV | grep -vE " 0$" | awk '{ print $1 }' | sort -n | sed 's/$/p;/' | tr -d "\n" | sed "s/p;$/q;d' $filename.aln.$iter.RAN/" | sed "s/^/'/"` #we use a python script which must be present in the $PATH, then keep the seqs with many gaps
        			flag=0
        		fi
			if [ "$threshold" -le 2 ] && [ "$flag" -eq 1 ]; then
        			echo "New threshold $threshold is less than or equal to 2"
        			parased=`arit.py $filename.$iter.proc.piton DIV | grep -vE "( 0| 1)$" | awk '{ print $1 }' | sort -n | sed 's/$/p;/' | tr -d "\n" | sed "s/p;$/q;d' $filename.aln.$iter.RAN/" | sed "s/^/'/"` #we use a python script which must be present in the $PATH, then keep the seqs with many gaps
        			flag=0
        		fi
        		if [ "$threshold" -le 3 ] && [ "$flag" -eq 1 ]; then
        			echo "New threshold $threshold is less than or equal to 3"
        			flag=0
        			parased=`arit.py $filename.$iter.proc.piton DIV | grep -vE "( 0| 1| 2)$" | awk '{ print $1 }' | sort -n | sed 's/$/p;/' | tr -d "\n" | sed "s/p;$/q;d' $filename.aln.$iter.RAN/" | sed "s/^/'/"` #we use a python script which must be present in the $PATH, then keep the seqs with many gaps
        		fi
        		if [ "$threshold" -le 4 ] && [ "$flag" -eq 1 ]; then
        			echo "New threshold $threshold is less than or equal to 4"
        			flag=0
        			parased=`arit.py $filename.$iter.proc.piton DIV | grep -vE "( 0| 1| 2| 3)$" | awk '{ print $1 }' | sort -n | sed 's/$/p;/' | tr -d "\n" | sed "s/p;$/q;d' $filename.aln.$iter.RAN/" | sed "s/^/'/"` #we use a python script which must be present in the $PATH, then keep the seqs with many gaps
        		fi
        		if [ "$threshold" -le 5 ] && [ "$flag" -eq 1 ]; then #less than or equal to 5
        			echo "New threshold $threshold less than or equal to 5"
        			flag=0
        			parased=`arit.py $filename.$iter.proc.piton DIV | grep -vE "( 0| 1| 2| 3| 4)$" | awk '{ print $1 }' | sort -n | sed 's/$/p;/' | tr -d "\n" | sed "s/p;$/q;d' $filename.aln.$iter.RAN/" | sed "s/^/'/"` #we use a python script which must be present in the $PATH, then keep the seqs with many gaps
        		fi
        		if [ "$threshold" -gt 5 ] && [ "$flag" -eq 1 ]; then #greater than 5
        			echo "New threshold $threshold is greater than or equal to 5"
        			flag=0
        			parased=`arit.py $filename.$iter.proc.piton DIV | grep -vE "( 0| 1| 2| 3| 4| 5)$" | awk '{ print $1 }' | sort -n | sed 's/$/p;/' | tr -d "\n" | sed "s/p;$/q;d' $filename.aln.$iter.RAN/" | sed "s/^/'/"` #we use a python script which must be present in the $PATH, then keep the seqs with many gaps
        		fi
        		(( iter++ ))
        		echo $parased | xargs sed > $filename.proc.$iter.RAN
        		nseqsrb=`grep -c . $filename.proc.$iter.RAN`
        		if [ $nseqsrb -lt 2 ]; then
        			break
        		fi
        		#echo "showing nseqsrb"
        		#echo $nseqsrb
        		ran_fasta.sh $filename.proc.$iter.RAN $filename.$iter.fasta
		
		else
			echo "###################################  FINISHED ########################################"
			echo "BEST ALIGNMENT POSSIBLE BY xmaffter: $filename.aln.$iter (fasta or RAN)"
			echo "Cannot longer reduce gapping by removing sequences, perhaps you want to try the Jesús Banda's antigapper.sh script from now on ;)"
			break
		fi
        done
        
done

echo "Removing proc files..."
rm *.proc.*
echo "DONE!!"