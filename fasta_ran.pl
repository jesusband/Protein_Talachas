#!/usr/bin/perl -w

#Este programa convierte un alineamiento fasta a formato ran (como el programa Ranga de lorenzo), pero sin comerse el identificador de la primer secuencia.

my $entrada=$ARGV[0]; #entrada del usuario desde terminal como primer argumento.
my $salida=$ARGV[1]; #segundo argumento
my $flag=1; #bandera para evitar imprimir los saltos de linea

open(FASTA, "$entrada")|| die "No encuentro el archivo especificado\n";
open(SALIDA, ">$salida")|| die "No puedo crear el archivo de salida\n";
close(SALIDA);
open(RAN, ">>$salida")|| die "No puedo anezar datos al archivo de salida\n";

while(<FASTA>)
{
if($_=~/^[>]/) 
	{
	if($flag){ #aqui la bandera indica que debo suspender el salto de linea y asi no haya una linea en blanco al principio del archivo.
		#$_=~s/[>]//; #elimino la llave
		$_=substr($_,1,50); #al decirle que empiece en 1 elimino el signo ">".
		chomp $_; #elimino el salto de linea (pude hacer usado s/\n/\t/g;)
		printf RAN "%50s\t",$_; #añado un tabulador y me aseguro que todos los Identificadores sean de 20 caracteres.
		$flag=0;
		}
	else {
		print RAN "\n"; #imprimo un salto de linea para indicar que hay una nueva secuencia
		#$_=~s/[>]//; #elimino la llave
		$_=substr($_,1,50);
		chomp $_; #elimino el salto de linea (pude hacer usado s/\n/\t/g;)
		printf RAN "%50s\t",$_; #añado un tabulador
	}
	}
else #esta es la parte que imprime la secuencia
{
chomp $_; #elimino el salto de linea
print RAN "$_";
}

}
close(RAN);


