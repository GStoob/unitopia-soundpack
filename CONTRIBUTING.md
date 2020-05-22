# Contributing Guidelines for UNItopia MUSHclient Soundpack

Please note that the following document will be provided in German only, as good German skills are required to contribute to this project.

# Code-Standards
Um eine Konsistenz in den verschiedenen Plugins, Klassen, funktionen usw. zu garantieren, werden hier einfache `Code Style Guidelines` aufgelistet. Wir bitten euch, diese einzuhalten, damit der Code in diesem Projekt so sauber wie möglich bleibt.

## Allgemein
- Aussagekräftige Namen für Variablen, Funktionen etc. verwenden (z.B. `PlaySound()` statt `PS()`)
- Bitte keine ungarische Notation verwenden.
- Lokale Variablen - sofern möglich - den globalen vorziehen. Dies gilt vor allem für Funktionen und Skripte, die Variablen definieren, die nur im aktuellen Scope der Funktion  / des Skripts von Relevanz sind.
- Einrückung: 2 Leerzeichen

## Funktionen
- Notation in Pascal Case. Beispiel: `InitializeConfig()`

## Variablen und Konstanten
- Globale Variablen als Pascal Case definieren. Beispiel: `MyVariable = ...`
- Funktions-Parameter und lokale Variablen als Camel-Case definieren. Beispiel: `local myLocalVariable = ...`
- Konstanten, wie man sie aus anderen Sprachen kennt, gibt es in `Lua` nicht, es ist immer möglich, einen Wert zu ändern. Dennoch gibt es Werte, die konstant bleiben (z.B. IDs anderer Plugins etc.). Deshalb haben wir uns dazu entschlossen, auch dafür eine
 Schreibweise zu definieren. Die Konstanten - nennen wir sie der Einfachheit halber mal so, sollten gänzlich grossgeschrieben werden, mit einem Underscore ( _ ) als Trenner. Beispiel: `AUDIO_PLUGIN_ID = ...`

## Klassen und Skriptdateien
Die Klassen sind auch ein Konstrukt, welches in Lua nicht existiert. Dennoch kann mittels der [Penlight-Library](https://stevedonovan.github.io/Penlight/api/index.html) eine Klassen ähnliche Funktionalität erreicht werden.
- Klassennamen als Pascal Case definieren. Beispiel: `Class.MyClass()`
- Eigenschaften einer Klasse auch als Pascal Case definieren. Beispiel:
```lua
Class.Person()
function Person:_init(firstName, lastName)
  self.FirstName = firstName
  self.LastName = lastName
  end

  return Person
```

- Skriptdateien sollten im Ordner `lua/unitopia` abgelegt werden. Je nach Bedarf, können weitere Unterordner für die Kategorisierung angelegt werden.
- Skriptnamen in Kleinschreibung definieren, mit Bindestrichen ( - ) als Trennzeichen, falls nötig.

