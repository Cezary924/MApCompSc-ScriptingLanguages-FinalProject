# Cezary924, Projekt zaliczeniowy, Skrypt Perl, Modul, Wersja 3

package CZ_PJS_gr1_PROJEKT_Perl_Modul;

# Funkcja wypisujaca na ekran informacje o uruchomieniu skryptu
sub usage_info {

    print "Uzycie: $0 [OPCJE] PLIK\n";
    print "Opcje:\n";
    print "  -h, --help   Wyswietla pomoc\n";
    print "  -q, --quiet  Nie wyswietla informacji o dzialaniu skryptu\n";
    print "Przyklady:\n";
    print "  $0 PLIK\n";
    print "    Skrypt przetwarza dane zawarte w pliku o nazwie PLIK.\n";
    print "  $0 PLIK1 PLIK2\n";
    print "    Skrypt przetwarza dane zawarte w pliku o nazwie PLIK1.\n";
    print "    Analogicznie dla pliku PLIK2.\n";

}

# Funkcja wypisujaca na ekran pomocne informacje o skrypcie
sub help_info {

    print "Cezary924, Projekt zaliczeniowy, Skrypt Perl\n";
    print "Skrypt przetwarzajacy dane o plikach na informacje o katalogach,\n";
    print "w ktorych sie znajduja. Dane pobrane zostaja ze wskazanych plikow,\n";
    print "ktore zawieraja tylko linie postaci:\n";
    print "'sciezka_do_pliku|nazwa_pliku|rozmiar_w_bajtach|typ'.\n";
    print "Mozliwe typy plikow: 'regular', 'symbolic_link', 'hard_link'.\n";
    print "Dane te zostana wykrzystane do zebrania informacji o katalogach\n";
    print "- dotyczyc beda wylacznie plikow znajdujacych sie bezposrednio\n";
    print "w danym katalogu\n";
    print "Wyniki dzialania skryptu zostana zapisane w plikach 'OUTPUT_PERL_X',\n";
    print "gdzie X to numer zadanego pliku (kolejnosc zgodna z wprowadzonymi\n";
    print "argumentami).\n";
    print "Zapis linii postaci: 'sciezka_katalogu|liczba_plikow|rozmiar_plikow_w_bajt";
    print "(cd.)|liczb_zwyklych_plikow|liczb_dowiazan_miekkich|liczb_dowiazan_twardych'\n";
    usage_info();

}

# Funkcja wypisujaca na ekran informacje o blednych argumentach
sub wrong_arg_info {

    print STDERR "Wprowadzono nieprawidlowy argument!\n";
    usage_info();

}

# Funkcja wypisujaca na ekran informacje o zbyt malej liczbie wprowadzonych argumentow
sub wrong_arg_count {

    print STDERR "Wprowadzono za malo argumentow!\n";
    usage_info();

}

# Funkcja do przetwarzania plikow i zapisywania
# informacji o katalogach do plikow
sub process_file {

    my ($file_name, $index, $quiet) = @_;

    my $wrong_line = 0;

    my %catalog_file_count;
    my %catalog_file_size;
    my %catalog_file_different_type_count;

    open $file_in, '<', $file_name or die "Nie mozna otworzyc pliku $file_name!";
    while (<$file_in>) {

        if ($_ =~ /^[\/]\S+[|]\S+[|]\d+[|]\D+$/) {

            @words = split(/\|/, $_);
            $catalog = $words[0];
            $catalog =~ s/$words[1]//;
            $type = $words[3];
            $type =~ s/\s+//g;
            if (exists $catalog_file_count{$catalog}) {

                $catalog_file_count{$catalog} += 1;
                $catalog_file_size{$catalog} += $words[2];
                if ($type eq "regular") { $catalog_file_different_type_count{$catalog}{'regular'} += 1; }
                elsif ($type eq "symbolic_link") { $catalog_file_different_type_count{$catalog}{'symbolic_link'} += 1; }
                else { $catalog_file_different_type_count{$catalog}{'hard_link'} += 1; }

            } else {

                $catalog_file_count{$catalog} = 1;
                $catalog_file_size{$catalog} = $words[2];
                if ($type eq "regular") {

                    $catalog_file_different_type_count{$catalog}{'regular'} = 1;
                    $catalog_file_different_type_count{$catalog}{'symbolic_link'} = 0;
                    $catalog_file_different_type_count{$catalog}{'hard_link'} = 0;

                } elsif ($type eq "symbolic_link") {

                    $catalog_file_different_type_count{$catalog}{'regular'} = 0;
                    $catalog_file_different_type_count{$catalog}{'symbolic_link'} = 1;
                    $catalog_file_different_type_count{$catalog}{'hard_link'} = 0;

                } else {

                    $catalog_file_different_type_count{$catalog}{'regular'} = 0;
                    $catalog_file_different_type_count{$catalog}{'symbolic_link'} = 0;
                    $catalog_file_different_type_count{$catalog}{'hard_link'} = 1;

                }

            }

        } else {

            $_ =~ s/\s+$//;
            print STDERR "Plik $file_name zawiera niepoprawna linie!\n'$_'\n";
            $wrong_line = 1;
            last;

        }

    }
    close $file_in;

    if ($wrong_line eq 0) {

        if ($quiet eq 0) {

            $output_file = "OUTPUT_PERL_$index";
            if (-e $output_file) {

                unlink $output_file or die "Nie udalo się usunac pliku: $output_file";

            }

            open $file_out, '>>', $output_file or die "Nie mozna otworzyc pliku $output_file!";
            for $key (sort keys %catalog_file_count) {

                print $file_out "$key|";
                print $file_out "$catalog_file_count{$key}|";
                print $file_out "$catalog_file_size{$key}|";
                print $file_out "$catalog_file_different_type_count{$key}{'regular'}|";
                print $file_out "$catalog_file_different_type_count{$key}{'symbolic_link'}|";
                print $file_out "$catalog_file_different_type_count{$key}{'hard_link'}\n";

            }
            close $file_out;

            print "Dane na podstawie pliku $file_name zapisano w pliku $output_file.\n";

        }

    }

}

1;