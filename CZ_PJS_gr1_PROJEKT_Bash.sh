#!/usr/bin/bash
# Cezary924, Projekt zaliczeniowy, Skrypt Bash, Wersja 3

source CZ_PJS_gr1_PROJEKT_Bash_Modul.sh

# Zadeklarowanie i zainicjalizowanie zmiennych pomocniczych
help=false # true, jesli uzyto -h/--help
quiet=false # true, jesli uzyto -q/--quiet
directory=false # true, jesli uzyto -d, kolejnym argumentem musi byc sciezka
subdirectories=false # true, jesli uzyto -s
path_info=false # true, jesli uzyto -p
wrong_arg=false # true, jesli wprowadzono niepoprawne argumenty wywolania
args=() # tablica przechowujaca sciezki zadanych katalogow
current_directory="$(pwd)" # zmienna przechowujaca sciezke obecnego katalogu

# Petla zajmujaca sie argumentami wywolania skryptu
if [ $# -gt 0 ]; then
    for var in "$@"; do
        if [[ $var = "-h" || $var = "--help" ]]; then
            help=true
        elif [[ $var = "-q" || $var = "--quiet" ]]; then
            quiet=true
        elif [ $var = "-d" ]; then
            directory=true
        elif [ $var = "-s" ]; then
            subdirectories=true
        elif [ $var = "-p" ]; then
            path_info=true
        elif [ $directory = true ]; then
            args+=("$var")
            directory=false
        else
            wrong_arg=true
            break
        fi
    done
fi

# Jesli nie uzyto -d, skrypt przeprowadzi operacje dla obecnego katalogu
if [ ${#args[@]} -lt 1 ]; then
    args+=("$(pwd)")
fi

# Obsluzenie wprowadzenia niepoprawnej opcji
if [ $wrong_arg = true ]; then
    wrong_arg_info
    exit 1
fi

# Obsluzenie uzycia opcji -h/--help
if [ $help = true ]; then
    help_info
    exit 0
fi

# Glowna petla skryptu - zapisanie informacji o plikach do pliku wyjsciowego
i=0
for arg in "${args[@]}"; do
    if [ ! -d "$arg" ]; then
        echo "'$arg' nie jest poprawna sciezka katalogu!" >&2
        continue
    fi
    ((i+=1))
    output_file="$(pwd)/OUTPUT_BASH_$i"
    output_file_p="OUTPUT_BASH_$i"
    if [ -e "$output_file" ]; then
        rm "$output_file"
    fi
    touch "$output_file"
    process_directory "$arg" "$output_file" "$subdirectories" "$path_info"
    if [ $quiet = false ]; then
        echo "Dane na podstawie katalogu $arg zapisano w pliku $output_file_p."
    fi
    cd $current_directory
done

exit 0