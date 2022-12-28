Herzlich willkommen zum UNItopia Soundpack!

Das Soundpack ist ein modifizierter MUSHclient, der mit diversen Plugins ausgestattet wurde, um das MUD UNItopia mit diversen Sounds zu untermalen. Die Hauptentwickler des Soundpacks sind Arija, Flarr und FrankieT.

Dieses Dokument bietet eine Übersicht über die Funktionen des Soundpacks. Bei Fragen, konstruktiver Kritik oder Ideen könnt ihr uns sehr gerne direkt im MUD ansprechen oder eine E-Mail an info@unitopiasoundpack.ch senden.

Allgemeine Informationen
===================

Das Soundpack bietet aktuell die Folgenden Features / Anpassungen:

- Direkte Anbindung an einen Screenreader
- Wiedergabe von Sounds für verschiedene Ereignisse
- Wiedergabe von Hintergrundgeräuschen in verschiedenen Umgebungen
- Wiedergabe von Hintergrundmusik auf verschiedenen Kontinenten der Spielwelt
- Ausgabefunktionen (output_functions, erleichtert allgemein das Nachlesen von Meldungen) welches dem bekannten Notepad-Fenster nachempfunden ist
- Kanalverlauf (erleichtert das Nachlesen von erhaltenen Nachrichten über rede, sage usw.)
- Ausblenden von sich ständig wiederholenden Meldungen (ist vor allem für Screen Reader Nutzer von Vorteil, um unnötigen Scroll zu vermeiden)
- Ausblenden von sehr langen Meldungen auf Strassen und Wegen

Allgemeine Tastenkombinationen
==============================

F9: Lautstärke von Sounds verringern
F10: Lautstärke von Sounds erhöhen
Steuerung+F9: Lautstärke von Hintergrundgeräuschen verringern
Steuerung+F10: Lautstärke von Hintergrundgeräuschen erhöhen
Steuerung+Umschalt+F9: Lautstärke der Hintergrundmusik verringern
Steuerung+Umschalt+F10: Lautstärke der Hintergrundmusik erhöhen
F11: Soundpack komplett stummschalten / Stummschaltung aufheben
Steuerung+F12: TTS-Plugin umschalten (aktuell werden die Plugins MushReader und tts_jfw unterstützt)

Bewegung per Nummernblock
=========================

Im Soundpack wurde auch der Nummernblock mit Funktionen ausgestattet. So gibt es beispielsweise die Möglichkeit, mit dem Nummbernblock in alle Himmelsrichtungen zu laufen oder sich die aktuellen AP und ZP ausgeben zu lassen. Nachfolgend eine Übersicht der Tasten und den dazugehörigen Funktionen:

Nummernblock 1: Suedwesten
Nummernblock 2: Sueden
Nummernblock 3: Suedosten
Nummernblock 4: Westen
Nummernblock 5: betrachte
Nummernblock 6: Osten
Nummernblock 7: Nordwesten
Nummernblock 8: Norden
Nummernblock 9: Nordosten
Nummernblock Plus: Runter
Nummernblock Minus: Hoch
Nummernblock Schrägstrich: Ausdauerpunkte ausgeben
Nummernblock Stern: Zauberpunkte ausgeben

Tastenkombinationen für den Kanalverlauf  (für Screen Reader Nutzer)
========================================

Für Screen Reader Nutzer gibt es die Möglichkeit, die letzten 10 Nachrichten eines Kanals Client-intern abzufragen und in die Zwischenablage zu kopieren.

Alt+1 bis 0: Liest die letzte bis zehntletzte Nachricht im ausgewählten Kanal. Durch zweimaliges Drücken wird die Nachricht in die Zwischenablage kopiert. Durch dreimaliges Drücken wird die Nachricht wieder eingefügt.
Alt+Pfeil links: Zum vorherigen Kanal wechseln
Alt+Pfeil rechts: Zum nächsten Kanal wechseln

Sound Collector
===============

Falls ihr selber Ideen habt, welche Ereignisse im MUD vertont werden könnten, so gibt es die Möglichkeit, selber Sound Trigger zu erstellen. Dafür könnt ihr das Sound Collector Plugin benutzen, welches euch erlaubt, einen beliebigen Trigger in das für das Soundpack benötigte Format zu konvertieren. Dazu muss nur das Plugin gestartet werden und den Trigger Text in das dafür vorgesehene Abfragefenster eingefügt werden. Starten könnt ihr das Plugin mit dem Befehl "// sc start", ohne Anführungszeichen.
Das Ergebnis könnt ihr entweder uns via Ingame Mail oder einer E-Mail zukommen lassen. Für die Coder unter euch besteht selbstverständlich auch die Möglichkeit, direkt einen neuen Pull Request auf GitHub zu öffnen. Bitte öffnet aber bei grösseren Features zuerst ein Issue!

Bitte beachtet auch weiterhin folgende Punkte:
- Das Team des UNItopia Soundpacks behält sich das Recht vor, selber zu entscheiden, ob und wie der erstellte Sound Trigger in das Soundpack eingepflegt wird.
- Sollten eigene Sounds mit dem Sound Trigger mitgeliefert werden (beispielsweise als Dropbox-Link, E-Mail Anlage o.ä.), müsst ihr darauf achten, kein Copyright geschütztes Material zu nutzen!! Sendet uns daher bitte immer eine Quellenangabe mit - ansonsten werden wir das Tonmaterial nicht verwenden.

Credits 
=======

Musik 
----

Nachfolgend eine Liste der Musikstücke, die im Soundpack verwendet werden:

"Cambodian Odyssey",
"Crusade - Heavy Industry",
"Danse Macabre",
"Divertimento K131",
"Errigal",
"I Can Feel it Coming",
"Jalandhar",
"Kalimba Relaxation Music",
"Mystery Bazaar",
"Village Consort"
Kevin MacLeod (incompetech.com)
Licensed under Creative Commons: By Attribution 3.0
http://creativecommons.org/licenses/by/3.0/

Trauermarsch - Frederic Chopin (aus der YouTube Audio Library)

Sounds
------

Die folgenden Sounds stehen unter der Creative Commons — Attribution 4.0 Lizenz
https://creativecommons.org/licenses/by/4.0

EminYILDIRIM:
- Sword Drop
  https://freesound.org/people/EminYILDIRIM/sounds/536099
  ItemRemove/Weapons/1.ogg
- Sword Drop Medium
  https://freesound.org/people/EminYILDIRIM/sounds/536102
  ItemRemove/Weapons/2.ogg
- Sword Drop Heavy
  https://freesound.org/people/EminYILDIRIM/sounds/536100
  ItemRemove/Weapons/3.ogg
- Sword Drop Light
  https://freesound.org/people/EminYILDIRIM/sounds/536101
  ItemRemove/Weapons/4.ogg

sonically_sound:
- Coins Shake in Hand and Count
  https://freesound.org/people/sonically_sound/sounds/635934
  ItemAdd/Money/1.ogg bis 5.ogg (modifiziert)

Die folgenden Sounds stehen unter der Creative Commons — Attribution 3.0 Lizenz
http://creativecommons.org/licenses/by/3.0/

jobro:
- Sword pulled 1.wav
  https://freesound.org/people/jobro/sounds/74831
  ItemAdd/Weapons/1.ogg
- Sword pulled 2.wav
  https://freesound.org/people/jobro/sounds/74832
  ItemAdd/Weapons/2.ogg
- Sword pulled 3.wav
  https://freesound.org/people/jobro/sounds/74833
  ItemAdd/Weapons/3.ogg
- Sword pulled 4.wav
  https://freesound.org/people/jobro/sounds/74834
  ItemAdd/Weapons/4.ogg
- Sword pulled 5.wav
  https://freesound.org/people/jobro/sounds/74835
  ItemAdd/Weapons/5.ogg

Weitere Sounds von u.a.
Sonnis GDC Game Audio Bundles2015 - 2020
https://sonniss.com/gameaudiogdc

Und nun wünschen wir euch viel Spass beim Spielen!
Arija, Flarr und FrankieT