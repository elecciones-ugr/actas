#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;
use utf8;
use open IO => ':locale';

# use HTML::TableExtract;
use Mojo::DOM qw(tree);
use File::Slurp::Tiny qw(read_file);

use Data::Dumper;

my $html_file = shift || "actas.htm";

my $html = read_file( $html_file);

die "Problemas con $html_file" if !$html;
my $dom = Mojo::DOM->new( $html);

my $filas = $dom->find( 'tr' );

my @actas;

my $este_acta;
for my $f (@$filas ) {
    my $columnas = $f->find('td');
    if ($f->all_text() =~ /ACTA /) {
      if ($este_acta ) {
	push @actas, $este_acta;
      }
      $este_acta = [ $f->all_text() ];
    } else {
      if ( $este_acta ) {
	push @$este_acta, $f->all_text();
      }
    }
}

say "Sector,Centro,Electores,Votan,Válidas,Nulas,Blancas,Pilar Aranda, Indalecio Sánchez-Montesinos";
for my $a (@actas ) {
  my ($sector) = ($a->[0] =~ /SECTOR -\s+(.+)/);
  shift @$a;
  my $resto = join("\n",  @$a );
  my ($centro) = ($resto =~ /^(.+?)\s+electores/gs);
  $centro =~ s/,/ - /;
  $centro =~ s/\"//g;
  my ($electores,$votan,$validas,$nulas,$blancas, 
      $uno, $pilar, $dos, $indalecio) = ($resto =~ /(\d+)/g );
  $nulas = $nulas || 0;
  $blancas = $blancas || 0;
  $pilar = $pilar || 0;
  $indalecio = $indalecio || 0;
  say "\"$sector\",\"$centro\",$electores,$votan,$validas,$nulas,$blancas,$pilar,$indalecio";
}
#Cuidado: ñapa aquí:
say "\"Eméritos\",\"Hospital Real\", 10, 10, 10, 0, 1, 7, 2";
