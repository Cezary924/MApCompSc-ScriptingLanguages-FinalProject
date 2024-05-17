#!/usr/bin/perl
# Cezary924, Projekt zaliczeniowy, Skrypt Perl, Wersja 3

use Cwd qw(abs_path);
use File::Basename qw(dirname);
use lib dirname(abs_path($0));
use CZ_PJS_gr1_PROJEKT_Perl_Modul;

# Zadeklarowanie i zainicjalizowanie zmiennych pomocniczych
$help = 0; # 1, jesli uzyto -h/--help
$quiet = 0; # 1, jesli uzyto -q/--quiet
$wrong_arg = 0; # 1, jesli wprowadzono niepoprawne argumenty wywolania
@files = (); # tablica przechowujaca nazwy zadanych plikow

# Petla zajmujaca sie argumentami wywolania skryptu
for (@ARGV) {

    if ( $_ eq "-h" ) { $help = 1 }
    elsif ( $_ eq "--help" ) { $help = 1 }
    elsif ( $_ eq "-q" ) { $quiet = 1 }
    elsif ( $_ eq "--quiet" ) { $quiet = 1 }
    elsif ( $_ =~ /^-/ ) { $wrong_arg = 1 }
    else { push @files, $_; }

}

# Obsluzenie uzycia opcji -h/--help
if ( $help eq 1 ) { CZ_PJS_gr1_PROJEKT_Perl_Modul::help_info(); exit; }

# Obsluzenie wprowadzenia niepoprawnej opcji
if ( $wrong_arg eq 1 ) { CZ_PJS_gr1_PROJEKT_Perl_Modul::wrong_arg_info(); exit; }

# Obsluzenie wprowadzenia zbyt malej liczby argumentow
scalar @files == 0 ? CZ_PJS_gr1_PROJEKT_Perl_Modul::wrong_arg_count() : ();

# Glowna petla skryptu - zapisanie informacji o katalogach do pliku wyjsciowego
$i = 1;
foreach $file_name (@files) {

    CZ_PJS_gr1_PROJEKT_Perl_Modul::process_file($file_name, $i, $quiet);

    $i = $i + 1;

}