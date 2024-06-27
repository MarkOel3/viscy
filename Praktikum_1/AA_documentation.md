# Aufgabe 1
a) 
Eine Entity kann mehrere Architekturen (Behaviour, Dataflow, Structure, RTL haben)

b) 
- Dataflow -> Parallele Zuweisungen ohne Prozesse 
- Behaviour -> Prozess (sequentielle Zuweisungen)
- Structure -> Wie Komponenten verbunden sind (Portmapping zwischen Komponenten)
- RTL -> Wie Behaviour aber automatisch Synthetisierbar

c) 
ghdl -a and2.vhdl xor2.vhdl half_adder.vhdl half_adder_tb.vhdl

Zeige alle Entities/Architekturen aus WORK Bibliothek:
ghdl --dir

d) 
ghdl -r HALF_ADDER_TB --wave=*half_adder_tb.ghw*

e)
Nachdem Savefile erstellt wurde kann man es auch so aufrufen
gtkwave -A *half_adder_tb.ghw*

# Aufgabe 2
f)
U = Uninitialisiert vor der ersten Zuweisung
X = Auf unbekannt zwingen (Zwischen einzelnen Testcases das sicher Fehler von längsten Pfaden erkannt werden)

g)
8 ns -> 1/(8*(10^-9)) = 125_000_000 = 125 MHz maximale Taktfrequenz

h)
a = 1, b = 1, c = 0

i)
Genau 8 ns warten, wenn jetzt eins der Gatter länger braucht wird dies als Fehler erkannt

# Aufgabe 3
b)
Weil die Zuweisungen parallel ausgeführt werden.

c)
a=1, b=0, c=1
