# Projekt zaliczeniowy - Pracownia Języków Skryptowych

Tytul: _Zbior skryptów do zebrania informacji o plikach_

Autor: _Cezary924_

Jezyk: _Bash, Perl, Python_

Rok: _2023/2024_


## Temat projektu
Zbior skryptow umozliwiajacy zebranie informacji o plikach znajdujacych sie 
w katalogach zadanych sciezkami (kartotekach), a takze stworzenie wykresow 
przedstawiajacych rozklady tych danych.


## Informacje ogolne
Projekt sklada sie z 3 glownych skryptow napisanych w Bash, Perl i Python. 
Kazdy ze skryptow implementuje inna funkcjonalnosc:
- skrypt Bash - 'CZ_PJS_gr1_PROJEKT_Bash.sh' - umozliwia zebranie danych 
o plikach w zadanym katalogu (oraz jego podkatalogach) do jednego pliku 
tekstowego.
- skrypt Perl - 'CZ_PJS_gr1_PROJEKT_Perl.pl' - umozliwia przetworzenie 
zebranych wczesniej danych o plikach (pliki wyjsciowe poprzedniego skryptu 
(Bash)) na informacje podsumowujace o katalogach, w ktorych sie znajduja.
- skrypt Python - 'CZ_PJS_gr1_PROJEKT_Python.py' - umozliwia stworzenie tabel 
z wykresami na podstawie danych z plikow wejsciowych (bedacych plikami 
wyjsciowymi skryptu poprzedniego (Perl)).
Dodatkowo dolaczony zostal rowniez skrypt Tcsh - 'CZ_PJS_gr1_PROJEKT_Tcsh.csh',
przy pomocy ktorego mozna uruchomic wszystkie trzy wymienione skrypty 
w podanej powyzej (odpowiedniej) kolejnosci przy pomocy jednego polecenia.


## Struktura i dzialanie
Glowne skrypty maja budowe modulowa - funkcje, z ktorych korzystaja, zapisane 
sa w oddzielnych plikach z koncowka '_Modul' w nazwie. Skrypty zaprojektowane 
zostaly tak, aby ich wspolna praca pozwalala osiagnac zamierzony efekt.
Jednakze tak naprawde kazdy z tych trzech skryptow moze dzialac niezaleznie 
od siebie w sposob jak najbardziej poprawny, przy zalozeniu dostarczenia 
odpowiednich (poprawnych skladniowo) danych wejsciowych.


## Uruchamianie
Najbardziej preferowane jest uruchomienie zespolu skryptow poprzez start 
skryptu Tcsh, jednakze mozna rowniez uruchomic glowne skrypty samodzielnie 
sekwencyjnie. Kazdy z czterech skryptow ma zaimplementowane opcje 
_'-h'_/_'--help'_, przy pomocy ktorych mozna szczegolowo dowiedziec sie, jak 
uruchomic kazdy z nich, a takze jakiej struktury powinny byc pliki wejsciowe
(o ile takie sa) oraz pliki wyjsciowe.


## Generowane wykresy
Efektem pracy skryptow (w szczegolnosci tego w Pythonie) sa wykresy slupkowe 
poziome (forma tekstowa lub graficzna (jesli dostepna)) przedstawiajace 
rozklad roznych cech plikow znajdujacych sie w danych katalogach.
Rodzaje wykresow:
- Liczba plikow w poszczegolnych katalogach.
- Suma rozmiaru plikow znajdujacych sie w poszczegolnych katalogach.
- Liczba zwyklych plikow w poszczegolnych katalogach.
- Liczba dowiazan symbolicznych w poszczegolnych katalogach.
- Liczba dowiazan twardych w poszczegolnych katalogach.
