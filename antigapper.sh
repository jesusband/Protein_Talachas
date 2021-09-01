#!/bin/bash

#usage antigapper.sh <alin.ran> <gapupperthreshold%> <aalowerthreshold(integer)> <outputfile>
#This script determines the gap frequency per position in a ranga alignment, and delete the whole column who is beyond a threshold
#AUTHOR: Jesús Banda (UNAM, CDMX)

filename=$1
threshold=$2
mintamaa=$3
output=$4

echo "usage antigapper.sh <alin.ran> <gapupperthreshold%> <aalowerthreshold(integer)> <outputfile>"
echo "... processing $filename"

totseqs=`grep -c . $filename` #total of sequences in file
lenseq=`head -n 1 $filename | awk '{ print $NF }' | awk '{ print length }'` #length of the first sequence (since it is an alignment, all seqs are the same length)
awk '{ print $NF }' $filename | sed 's/[A-Za-z]/1/g' | sed 's/-/0/g' > albin.kk #binary transformation of the alignment
#rm keep.kk
#rm gaps.kk
col=0
until [ $col = $lenseq ];do
	(( col++ ))
	aa=`awk -F "" 'x='$col' { sum+=$x } END { print sum }' albin.kk`
	gapfrec=$(bc <<< "scale=3;(1-$aa/$totseqs)*100")
	echo $gapfrec >> gapfrec.kk
	
	gapint=${gapfrec%.*} #quito la fracción decimal, aunque 1.9 se convertirá en 1 :(
	if [ -z "$gapint" ]; then #if gapint is null, maybe because it was lower than 1 and bc makes it .5 o algo así
		gapint=0
	fi
	echo $gapint >> gaps.kk
	if [ "$gapint" -lt "$threshold" ]; then #if gapint is less than threshold
		echo "$col" >> keep.kk #no se creará si la condicion nunca se cumple
	fi
done

awk '{ print $1 }' $filename > headers.kk
awk '{ print $NF }' $filename > sequence.kk
sed 's/^/\$/;s/$/,/' keep.kk | tr -d "\n" | sed 's/,$//' | sed "s/^/-F \"\" '{ print /;s/$/}' sequence\.kk/" | xargs awk | sed 's/ //g' > newseq.kk

paste headers.kk newseq.kk > salida.kk
#aumentar algo para deshacerse de aquellas secuencias que se convierten en puros gaps
line=1

until [ $line = $totseqs ];do
	tam=`sed "${line}q;d" newseq.kk | sed 's/-//g' | awk '{ print length }'`
	if [ "$tam" -gt "$mintamaa" ]; then
		sed "${line}q;d" salida.kk >> $output
		#echo "hola"
	fi
	(( line++ ))
done

rm gapfrec.kk gaps.kk albin.kk keep.kk headers.kk sequence.kk newseq.kk salida.kk #destruimos los archivos temporales

echo "DONE!! IMPORTANT: Erase $output in case you run this script again using the same output name!!"