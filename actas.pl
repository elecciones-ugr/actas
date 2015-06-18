#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;
use utf8;
use open IO => ':locale';

# use HTML::TableExtract;
use HTML::TableExtract qw(tree);

use Data::Dumper;

my $html = shift || "actas.htm";

# my $te = HTML::TableExtract->new(headers => ['SECTOR']);
my $te = HTML::TableExtract->new();
$te->parse_file($html);

# foreach my $ts ($te->table_states) {
#   my @cells=();
#
#   foreach my $row ($ts->rows) {
#     my $valor = join(',', @$row)."\n";
#     push @cells,$valor;
#   }
#
#   print @cells;
# }

foreach my $ts ($te->tables){
  my $tree = $ts->tree();

  foreach my $rows (0..$tree->maxrow){
    my @cells=();

    for my $cols (0..$tree->maxcol){
      my $val = $tree->cell($rows,$cols)->as_text;
      # $val =~ s/^\s+|\s+$| -+$//g;
      # $val =~ s/ -+$//g;
      $val =~ s/^\s+|\s+$|\s-\s*+$//g;
      if ($val ne ""){
        print Dumper($val);
        # print $val." ";
      }
    }
    print "\n";
  }
}
