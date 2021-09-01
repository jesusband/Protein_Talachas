#!/usr/bin/perl -w

#Este programa transforma caracteres de un alineamiento de secuencias ranga en números, los gaps los respeta. Esto para indentificar los caracteres correspondientes entre secuencias.
use strict;

die "usage: <carac_num_noracista.pl> <ranga.file> <output.file> <firstposition>" unless @ARGV == 3;

my $entrada=$ARGV[0];
my $salida=$ARGV[1];
my $c=$ARGV[2]; #contador
my $elem; #elemento del arreglo

open (RANGAS, "$entrada") || die "No puedo abrir el archivo ran en cuestión\n";
open (NUMERICO, ">$salida") || die "No puedo crear el archivo nrn en cuestión\n";
close (NUMERICO);
open (NRN, ">>$salida") || die "No puedo anexar en el archivo nrn en cuestión\n";
while (<RANGAS>)
{
my @ID_sec=split(/\t/,$_); #se separa la linea entre nombre y secuencia
	print NRN "$ID_sec[0]\t";
		
		chomp $ID_sec[1]; #elimino el terminador de linea.
		my @caracter=split(//,$ID_sec[1]);		
		#if(length($ID_sec[1])==scalar(@caracter)){print "La cadena de la secuencia $ID_sec[0] fue descompuesta en caracteres correctamente\n";}
		$c=$ARGV[2];
		

	foreach $elem (@caracter)
	{

	printf NRN "$elem%03d|", $c; $c++; #aqui el caracter "se convierte" en número (sólo si es una letra) y se imprime en el nuevo archivo
	#else {print NRN "$elem   |";} #si el caracter es un gap se imprime tal cual en el nuevo archivo

		}
print NRN "\n";
} 
close (RANGAS);
close (NRN);

#¿cómo hacer para que un script tan útil como este se convierta en programa como el Ranga que me dio Lorenzo? Respuesta: Con $ARGV[] y cambiando con chmod +x nombre_programa
