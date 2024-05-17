# Cezary924, Projekt zaliczeniowy, Skrypt Bash, Modul, Wersja 3

# Funkcja wypisujaca na ekran informacje o uruchomieniu skryptu
usage_info() {

    echo "Uzycie: $0 [OPCJE] [SCIEZKA]"
    echo "Opcje:"
    echo "  -d           Umozliwia sprecyzowanie katalogu do sprawdzenia"
    echo "  -s           Sprawdza rowniez podkatalogi zadanego katalogu"
    echo "  -p           Wypisuje do pliku dodatkowo sciezki do analizowanych plikow"
    echo "  -h, --help   Wyswietla pomoc"
    echo "  -q, --quiet  Nie wyswietla informacji o dzialaniu skryptu"
    echo "Przyklady:"
    echo "  $0"
    echo "    Skrypt zbiera informacje o plikach znajdujacych sie w katalogu biezacym."
    echo "  $0 -d SCIEZKA"
    echo "    Skrypt zbiera informacje o plikach znajdujacych sie w katalogu w lokalizacji"
    echo "    SCIEZKA."
    echo "  $0 -s"
    echo "    Skrypt zbiera informacje o plikach znajdujacych sie w katalogu biezacym oraz"
    echo "    jego podkatalogach."
    echo "  $0 -p"
    echo "    Skrypt zbiera informacje o plikach znajdujacych sie w katalogu biezacym oraz"
    echo "    jego podkatalogach. Do pliku zapisana zostanie dodatkowo sciezka do"
    echo "    poszczegolnych plikow."
    echo "  $0 -s -p -d SCIEZKA1 -d SCIEZKA2"
    echo "    Skrypt zbiera informacje o plikach znajdujacych sie w katalogu w lokalizacji"
    echo "    SCIEZKA1 oraz jego podkatalogach. Do pliku zapisana zostanie dodatkowo sciezka"
    echo "    do poszczegolnych plikow. Analogicznie dla katalogu w lokalizacji SCIEZKA2."

}

# Funkcja wypisujaca na ekran pomocne informacje o skrypcie
help_info() {

    echo "Cezary924, Projekt zaliczeniowy, Skrypt Bash"
    echo "Skrypt gromadzacy dane o plikach w zadanym katalogu."
    echo "Zbierane dane: nazwa, rozmiar, typ, (opcjonalnie) sciezka."
    echo "Dane zapisane zostaja w plikach 'OUTPUT_BASH_X', gdzie X to numer"
    echo "zadanego katalogu (kolejnosc zgodna z wprowadzonymi sciezkami)."
    echo "Zapis linii postaci:"
    echo "'(sciezka_do_pliku)|nazwa_pliku|rozmiar_w_bajtach|typ_pliku'"
    usage_info

}

# Funkcja wypisujaca na ekran informacje o blednych argumentach
wrong_arg_info() {

    echo "Wprowadzono nieprawidlowy argument!" >&2
    usage_info

}

# Funkcja do przetwarzania plikow i zapisywania
# informacji o nich do pliku
process_file() {

    type="regular"

    if [ -L "$1" ]; then
        type="symbolic_link"
    elif [ -h "$1" ]; then
        type="hard_link"
    fi

    if [ "$1" != "$(echo "$2" | grep -oE "[^/]+$")" ]; then
        size="$(stat -c %s $1)"
        if [ "$3" = false ]; then
            echo "$1|$size|$type" >> "$2"
        else
            echo "$(pwd)/$1|$1|$size|$type" >> "$2"
        fi
    fi

}

# Funkcja do przetwarzania katalogow
process_directory() {

    cd "$1" || exit

    for file in *; do
        if [ -f "$file" ]; then
            process_file "$file" "$2" "$4"
        elif [ -d "$file" ]; then
            if [ "$3" = true ]; then
                process_directory "$file" "$2" "$3" "$4"
            fi
        fi
    done

    cd ..

}