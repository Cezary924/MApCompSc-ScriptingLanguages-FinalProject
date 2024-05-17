# Cezary924, Projekt zaliczeniowy, Skrypt Python, Modul, Wersja 3

# Funkcja wypisujaca na ekran informacje o uruchomieniu skryptu
def usage_info(name):
    print("Uzycie: " + name + " [OPCJE] PLIK")
    print("Opcje:")
    print("  -t           Nie wyswietla tekstowych wykresow")
    print("  -o           Zapisuje tekstowe wykresy do plikow 'OUTPUT_PYTHON_X'")
    print("  -g           Zapisuje graficzne wykresy do plikow 'OUTPUT_PYTHON_X.png'")
    print("  -h, --help   Wyswietla pomoc")
    print("  -q, --quiet  Nie wyswietla informacji o dzialaniu skryptu")
    print("Przyklady:")
    print("  " + name + " PLIK")
    print("    Skrypt przetwarza dane zawarte w pliku o nazwie PLIK.")
    print("    Wykresy tekstowe wypisywane sa na ekran.")
    print("  " + name + " -t -o PLIK")
    print("    Skrypt przetwarza dane zawarte w pliku o nazwie PLIK.")
    print("    Wykresy tekstowe zapisywane sa do pliku wyjsciowego.")
    print("    Wykresy tekstowe nie zostana wyswietlone.")
    print("  " + name + " -t -g PLIK")
    print("    Skrypt przetwarza dane zawarte w pliku o nazwie PLIK.")
    print("    Wykresy graficzne zapisywane sa do plikow wyjsciowych.")
    print("    Wykresy tekstowe nie zostana wyswietlone.")
    print("  " + name + " -o -g PLIK1 PLIK2")
    print("    Skrypt przetwarza dane zawarte w pliku o nazwie PLIK1.")
    print("    Analogicznie dla pliku PLIK2.")
    print("    Wykresy tekstowe wypisywane sa na ekran.")
    print("    Wykresy tekstowe zapisywane sa do pliku wyjsciowego.")
    print("    Wykresy graficzne zapisywane sa do plikow wyjsciowych.")

# Funkcja wypisujaca na ekran pomocne informacje o skrypcie
def help_info(name):
    print("Cezary924, Projekt zaliczeniowy, Skrypt Python")
    print("Skrypt tworzacy tabele z wykresami na podstawie danych z plikow wejsciowych.")
    print("Informacje pobierane sa z plikow zawierajacych wylacznie linie postaci:")
    print("'sciezka_katalogu|liczba_plikow|rozmiar_plikow_w_bajtach")
    print("(cd.)|liczba_zwyklych_plikow|liczba_dowiazan_miekkich|liczba_dowiazan_twardych'.")
    print("Wyswietla stworzone wykresy w formie tekstowej.")
    print("Opcjonalnie, wykresy tekstowe moga rowniez zostac zapisane w plikach")
    print("'OUTPUT_PYTHON_X', gdzie X to numer zadanego pliku (kolejnosc zgodna")
    print("z wprowadzonymi argumentami). Istnieje rowniez mozliwosc stworzenia graficznych ")
    print("wykresow (wymaga uzycia odpowiedniej opcji, wymaga posiadania zainstalowanej ")
    print("biblioteki matplotlib) - wykresy te zostana zapisane do plikow 'OUTPUT_PYTHON_X_Y'.")
    print("Rodzaje tabel: porownanie liczby plikow w poszczegolnych katalogach,")
    print("por. sumy rozmiaru p. w p. k., por. l. zwyklych plikow w p. k.,")
    print("por. l. dowiazan symb. w p. k., por. l. dowiazan twardych w p. k.")
    usage_info(name)

# Funkcja wypisujaca na ekran informacje o blednych argumentach
def wrong_arg_info(name):
    print("Wprowadzono nieprawidlowy argument!")
    usage_info(name)

# Funkcja wypisujaca na ekran informacje o zbyt malej liczbie wprowadzonych argumentow
def wrong_arg_count(name):
    print("Wprowadzono za malo argumentow!")
    usage_info(name)

# Funkcja znajdujaca wsrod elementow listy (sciezek katalogow) wspolny ich czlon
def find_substring(list_of_strings):
    catalogs = [s.split('/') for s in list_of_strings]
    
    shared_path = min(catalogs, key=len)
    
    for index, catalog in enumerate(shared_path):
        if all(catalog == path[index] for path in catalogs):
            continue
        else:
            substring = '/'.join(shared_path[:index])
            return substring
    
    return ""

# Funkcja, ktora w razie potrzeby skraca poczatek sciezki katalogu
def prepare_string(string, table_size):
    if len(string) > (table_size/2):
        rem = len(string)-(table_size/2)
        if rem < 3:
            rem = 3
        string_print = "..." + string[rem:]
    else:
        string_print = string
    return string_print

# Funkcja tworzaca tabele z wykresem
def create_table(no, list_of_paths, list_of_values, quiet, output_file, graphical_output_file, show_tables, name, table_size=160):
    check = 0
    for i in range(1):
        if graphical_output_file != None:
            try:
                import matplotlib.pyplot as plt
            except ImportError as e:
                if no == 1:
                    print("Biblioteka 'matplotlib' nie jest zainstalowana!")
                    print("Wykresy graficzne nie zostaly wygenerowane.")
                    check += 10
                break
            list_of_values_int = list(map(int, list_of_values))
            list_of_paths_str = []
            for path in list_of_paths:
                list_of_paths_str.append(path)

            start = find_substring(list_of_paths_str)
            if len(start) > 0:
                for i in range(len(list_of_paths_str)):
                    new_path = list_of_paths_str[i].replace(start, '')
                    list_of_paths_str[i] = new_path

            plt.figure(figsize=(10, 8))
            plt.barh(list_of_paths_str, list_of_values_int)
            plt.xlim(0, max(list_of_values_int) * 1.23 + 1)
            plt.gca().invert_yaxis()
            plt.title(name + "\n\n")
            plt.annotate(start, xy=(0, 1.01), xycoords='axes fraction')
            adj = 0.1
            min_size = 12
            if len(max(list_of_paths_str, key=len)) > min_size:
                adj += 0.01 * (len(max(list_of_paths_str, key=len)) - min_size)
            if adj > 0.49:
                adj = 0.49
            plt.subplots_adjust(left=adj)
            for i, w in enumerate(list_of_values_int):
                k = 0.5
                if w == 0:
                    k = 0.1
                if max(list_of_values_int) == 0:
                    k = 0.025
                plt.text(w + k, i, str(w), va='center')
            plt.savefig(graphical_output_file + "_" + str(no) + ".png")

    if output_file != None or show_tables == True:
        output_string = ""
        space = 2

        # tytul
        output_string += ("+" + (table_size-2)*"-" + "+\n")
        output_string += ("|" + (table_size-2)*" " + "|\n")
        output_string += ("|" + (table_size-2)*" " + "|\n")
        output_string += ("|" + name.center(table_size-2) + "|\n")
        output_string += ("|" + (table_size-2)*" " + "|\n")
        output_string += ("|" + (table_size-2)*" " + "|\n")

        # wspolna czesc sciezek
        start = find_substring(list_of_paths)
        if len(start) > 0:
            start_print = prepare_string(start, table_size)
            output_string += ("| " + start_print + (table_size-space*2-len(start_print))*" " + " |\n")
            output_string += ("|" + (table_size-2)*" " + "|\n")

        # maksymalna dlugosc sciezek
        l_max = 0
        if len(start) > 0:
            for path in list_of_paths:
                path = "/" + path
        for path in list_of_paths:
            if l_max < len(path.replace(start, '')) + 2:
                l_max = len(path.replace(start, '')) + 2
        if l_max > table_size/2:
            l_max = table_size/2
            
        # maksymalna dlugosc wartosci
        v_max = 0
        for count in list_of_values:
            if v_max < int(count):
                v_max = int(count)
        if v_max == 0:
            v_max = 1
            
        # wypisanie sciezki i slupka wykresu
        k = 0
        for path in list_of_paths:
            output_string += ("|")
            beginning = (" "*space + "*" + " "*space)
            output_string += beginning
            path_print = prepare_string(path.replace(start, ''), table_size)
            output_string += (path_print + " "*space)
            l = len(path_print) + space
            output_string += (" "*(l_max-l))
            l = l_max + len(str(v_max)) + space*4 + len(beginning)
            bar_len = int((table_size-l)*(int(list_of_values[k])/v_max))
            if bar_len == 0:
                if int(list_of_values[k]) > 0:
                    bar_len = 1
            output_string += ("|")
            output_string += ("-"*bar_len)
            output_string += (" "*(table_size-l-bar_len))
            output_string += ("|")
            output_string += (" "*(len(str(v_max))-len(list_of_values[k])))
            output_string += ("  " + list_of_values[k] + "  ")
            output_string += ("|\n")
            k += 1

        output_string += ("|" + (table_size-2)*" " + "|\n")
        output_string += ("+" + (table_size-2)*"-" + "+\n")

        if quiet == True:
            if output_file == None:
                return 0
            else:
                try:
                    with open(output_file, 'a') as file_out:
                        file_out.write(output_string + "\n")
                except Exception as e:
                    print("Nie mozna otworzyc pliku " + output_file + "!")
                    return 1
        else:
            if output_file == None:
                if show_tables:
                    print(output_string)
            else:
                if show_tables:
                    print(output_string)
                try:
                    with open(output_file, 'a') as file_out:
                        file_out.write(output_string + "\n")
                except Exception as e:
                    print("Nie mozna otworzyc pliku " + output_file + "!")
                    return 1
                
    return check