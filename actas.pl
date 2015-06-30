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
      $este_acta = [ $columnas ];
    } else {
      if ( $este_acta ) {
	push @$este_acta, $columnas;
      }
    }
}

for my $a (@actas ) {
  my $first = $a->[0];
  my $second = $a->[1];
  say $first, $second;
}
