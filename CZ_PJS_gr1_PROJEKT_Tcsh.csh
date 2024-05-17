#!/usr/bin/tcsh
# Cezary924, Projekt zaliczeniowy, Skrypt Tcsh, Wersja 3

# Zadeklarowanie i zainicjalizowanie zmiennych pomocniczych
set bash_script="CZ_PJS_gr1_PROJEKT_Bash.sh" # nazwa skryptu Bash
set perl_script="CZ_PJS_gr1_PROJEKT_Perl.pl" # nazwa skryptu Perl
set python_script="CZ_PJS_gr1_PROJEKT_Python.py" # nazwa skryptu Python
set show_tables=true # false, jesli uzyto -t
set output_to_file=false # true, jesli uzyto -o
set graphical_graphs=false # true, jesli uzyto -g
set help=false # true, jesli uzyto -h/--help
set quiet=false # true, jesli uzyto -q/--quiet
set wrong_arg=false # true, jesli wprowadzono niepoprawne argumenty wywolania
set args=() # tablica przechowujaca argumenty potencjalnie bedace sciezkami

# Petla zajmujaca sie argumentami wywolania skryptu
if ( $# > 0 ) then

    foreach var ($argv)

        if (("$var" == "-h") || ("$var" == "--help")) then

            set help=true

        else if (("$var" == "-q") || ("$var" == "--quiet")) then

            set quiet=true

        else if ("$var" == "-o") then

            set output_to_file=true
        
        else if ("$var" == "-g") then

            set graphical_graphs=true
        
        else if ("$var" == "-t") then

            set show_tables=false

        else if ("$var" =~ -*) then

            set wrong_arg=true

        else

            set args=( $args "$var" )

        endif

    end

endif

# Dodanie katalogu biezacego, jesli nie wprowadzono zadnego argumentu
if ( $#args == 0 ) then

    set var=`pwd`
    set args=( $args "$var" )

endif

# Obsluzenie wprowadzenia niepoprawnej opcji
if ( $wrong_arg == true ) then

    goto wrong_arg_info

endif

# Obsluzenie uzycia opcji -h/--help
if ( $help == true ) then

    goto help_info

endif

# Sprawdzenie, czy wprowadzone argumenty sa poprawnymi sciezkami
set i=0
set paths=() # tablica przechowujaca sciezki zadanych katalogow
foreach var ($args)

    if ( ! -d "$var" ) then

        echo "$var nie jest poprawna sciezka katalogu!"
        continue

    endif
    set i = `expr $i + 1`
    set paths=( $paths "$var" )

end

# Przygotowanie argumentow wywolania skryptow glownych
set input_bash="-s -p"
set input_perl=""
set input_python=""

if ( $graphical_graphs == true ) then

    set input_python="$input_python -g "

endif

if ( $output_to_file == true ) then

    set input_python="$input_python -o "

endif

if ( $show_tables == false ) then

    set input_python="$input_python -t "

endif

if ( $quiet == true ) then

    set input_bash="$input_bash -q "
    set input_perl="$input_perl -q "
    set input_python="$input_python -q "

endif

foreach var ($paths)

    set input_bash="$input_bash -d $var"

end
if (($output_to_file == true) || ($graphical_graphs == true)) then

    set output_python1="Wykresy dla poszczegolnych katalogow zapisano do plikow:"

else

    set output_python1=""

endif

set output_python2=""
set output_python3=""

foreach j (`seq 1 $i`)

    set input_perl="$input_perl OUTPUT_BASH_$j"
    set input_python="$input_python OUTPUT_PERL_$j"
    if ( $output_to_file == true ) then
        
        if ( "$output_python2" != "" ) then

            set output_python2="$output_python2\n"

        endif

        set output_python2="$output_python2""$paths[$j] -> OUTPUT_PYTHON_$j"

    endif
    if ( $graphical_graphs == true ) then

        if ( "$output_python3" != "" ) then

            set output_python3="$output_python3\n"
            
        endif
        
        set output_python3="$output_python3""$paths[$j] -> OUTPUT_PYTHON_$j""_X.png"

    endif

end

# Uruchomienie glownych skryptow
if ( $quiet == false ) then

    echo "Uruchamianie skryptu $bash_script..."

endif
bash $bash_script $input_bash
if ( $quiet == false ) then

    echo "\nUruchamianie skryptu $perl_script..."

endif
perl $perl_script $input_perl
if ( $quiet == false ) then

    echo "\nUruchamianie skryptu $python_script..."

endif
python3 $python_script $input_python
if ( $quiet == false ) then

    if ( "$output_python1" != "" ) then 

        echo "\n$output_python1"
        
        if ( -e "OUTPUT_PYTHON_1" ) then
        
            echo "$output_python2"
        
        endif

        if ( -e "OUTPUT_PYTHON_1_1.png" ) then
        
            echo "$output_python3"
        
        endif

    endif

endif

exit 0

# Wypisanie na ekran pomocnych informacji o skrypcie
help_info:
    echo "Cezary924, Projekt zaliczeniowy, Skrypt Tsch"
    echo "Skrypt uruchamiajacy wszystkie skrypty projektu generujacego wykresy"
    echo "na podstawie plikow znajdujacych sie w katalogach zadanych sciezkami."
    goto usage_info

# Wypisanie na ekran informacji o wprowadzeniu niepoprawnego argumentu
wrong_arg_info:
    echo "Wprowadzono nieprawidlowy argument!"
    goto usage_info

# Wypisanie na ekran informacji o uruchomieniu skryptu
usage_info:
    echo "Uzycie: $0 [OPCJE] SCIEZKA"
    echo "Opcje:"
    echo "  -t           Nie wyswietla wykresow tekstowych."
    echo "  -o           Zapisuje wykresy tekstowe do plikow wyjsciowych."
    echo "  -g           Zapisuje wykresy graficzne do plikow wyjsciowych."
    echo "  -h, --help   Wyswietla pomoc"
    echo "  -q, --quiet  Nie wyswietla informacji o dzialaniu skryptu"
    echo "Przyklady:"
    echo "  $0"
    echo "    Skrypt uruchamia glowne skrypty projektu dla katalogu biezacego."
    echo "    Wykresy tekstowe zostana wyswietlone."
    echo "  $0 -t -o SCIEZKA"
    echo "    Skrypt uruchamia glowne skrypty projektu dla katalogu SCIEZKA."
    echo "    Wykresy tekstowe zostana zapisane do pliku wyjsciowego."
    echo "    Wykresy tekstowe nie zostana wyswietlone."
    echo "  $0 -t -g SCIEZKA1 SCIEZKA2"
    echo "    Skrypt uruchamia glowne skrypty projektu dla katalogow SCIEZKA1 i SCIEZKA2."
    echo "    Wykresy graficzne zostana zapisane do plikow wyjsciowych."
    echo "    Wykresy tekstowe nie zostana wyswietlone."
    echo "  $0 -o -g SCIEZKA1 SCIEZKA2"
    echo "    Skrypt uruchamia glowne skrypty projektu dla katalogow SCIEZKA1 i SCIEZKA2."
    echo "    Wykresy tekstowe zostana wyswietlone."
    echo "    Wykresy tekstowe zostana zapisane do plikow wyjsciowych."
    echo "    Wykresy graficzne zostana zapisane do plikow wyjsciowych."