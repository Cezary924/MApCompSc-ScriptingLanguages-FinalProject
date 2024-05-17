#!/usr/bin/env python3
# Cezary924, Projekt zaliczeniowy, Skrypt Python, Wersja 3

import sys, re
import CZ_PJS_gr1_PROJEKT_Python_Modul as M

# Zadeklarowanie i zainicjalizowanie zmiennych pomocniczych
help = False # True, jesli uzyto -h/--help
quiet = False # True, jesli uzyto -q/--quiet
show_tables = True # False, jesli uzyto -t
output_to_file = False # True, jesli uzyto -o
graphical_graphs = False # True, jesli uzyto -g
wrong_arg = False # True, jesli wprowadzono niepoprawne argumenty wywolania
files = [] # tablica przechowujaca nazwy zadanych plikow

# Petla zajmujaca sie argumentami wywolania skryptu
for arg in sys.argv[1:]:
    if arg == "-h" or arg == "--help":
        help = True
    elif arg == "-q" or arg == "--quiet":
        quiet = True
    elif arg == "-o":
        output_to_file = True
    elif arg == "-g":
        graphical_graphs = True
    elif arg == "-t":
        show_tables = False
    elif arg.startswith("-"):
        wrong_arg = True
    else:
        files.append(arg)

# Obsluzenie uzycia opcji -h/--help
if help:
    M.help_info(sys.argv[0])
    sys.exit(0)

# Obsluzenie wprowadzenia niepoprawnej opcji
if wrong_arg:
    M.wrong_arg_info(sys.argv[0])
    sys.exit(1)

# Obsluzenie wprowadzenia zbyt malej liczby argumentow
if len(files) < 1:
    M.wrong_arg_count(sys.argv[0])
    sys.exit(1)

# Glowna petla skryptu - stworzenie tabl i wykresow na podstawie danych zawartych w plikach
i = 1
for file_name in files:
    try:
        with open(file_name, 'r') as file_in:
            lines = file_in.readlines()
            wrong_line = ""
            for line in lines:
                if not re.match(r'^[\/]\S+[|]\d+[|]\d+[|]\d+[|]\d+[|]\d+$', line):
                    wrong_line = line
                    break
            if wrong_line != "":
                print("Plik " + file_name + " zawiera niepoprawna linie!\n'" + line[:-1] + "'")
                continue
    except Exception as e:
        print("Nie mozna otworzyc pliku " + file_name + "!")
        continue

    paths = []
    files_count = []
    files_size = []
    regular_files_count = []
    sym_links_count = []
    hard_links_count = []
    for line in lines:
        words = line.split('|')
        paths.append(words[0])
        files_count.append(words[1])
        files_size.append(words[2])
        regular_files_count.append(words[3])
        sym_links_count.append(words[4])
        hard_links_count.append(words[5].strip())

    if output_to_file:
        output_file = "OUTPUT_PYTHON_" + str(i)
        try:
            with open(output_file, 'w') as file_out:
                file_out.truncate(0)
        except Exception as e:
            print("Nie mozna otworzyc pliku " + output_file + "!")
            continue
    else:
        output_file = None

    if graphical_graphs:
        graphical_output_file = "OUTPUT_PYTHON_" + str(i)
    else:
        graphical_output_file = None

    ret_val = 0
    if len(paths) != 0:
        ret_val += M.create_table(1, paths, files_count, quiet, output_file, graphical_output_file, show_tables, "Liczba plikow w poszczegolnych katalogach")
        ret_val += M.create_table(2, paths, files_size, quiet, output_file, graphical_output_file, show_tables, "Suma rozmiaru plikow znajdujacych sie w poszczegolnych katalogach")
        ret_val += M.create_table(3, paths, regular_files_count, quiet, output_file, graphical_output_file, show_tables, "Liczba zwyklych plikow w poszczegolnych katalogach")
        ret_val += M.create_table(4, paths, sym_links_count, quiet, output_file, graphical_output_file, show_tables, "Liczba dowiazan symbolicznych w poszczegolnych katalogach")
        ret_val += M.create_table(5, paths, hard_links_count, quiet, output_file, graphical_output_file, show_tables, "Liczba dowiazan twardych w poszczegolnych katalogach")
    else:
        if output_to_file:
            try:
                with open(output_file, 'a') as file_out:
                    file_out.write("Wykresy nie zostaly utworzone - plik wejsciowy jest nieprawidlowy!" + "\n")
            except Exception as e:
                print("Nie mozna otworzyc pliku " + output_file + "!")
                continue
        else:
            if not quiet:
                print("Wykresy nie zostaly utworzone - plik wejsciowy jest nieprawidlowy!")

    if output_to_file:
        if not quiet:
            if ret_val % 10 == 0:
                print("Wykresy tekstowe na podstawie pliku " + file_name + " zapisano w pliku " + output_file + ".")
    if graphical_graphs:
        if not quiet:
            if ret_val < 10:
                print("Wykresy graficzne na podstawie pliku " + file_name + " zapisano w pliku " + graphical_output_file + "_X.png.")
    i += 1

    continue