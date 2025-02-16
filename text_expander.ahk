#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
FileEncoding, UTF-8

; Ustawienia wysyłania tekstu
SetWorkingDir %A_ScriptDir%
SendMode Input

; Ścieżka do pliku konfiguracyjnego
ConfigFile = %A_ScriptDir%\config.txt

; Sprawdź czy plik istnieje
IfNotExist, %ConfigFile%
{
    MsgBox, Nie znaleziono pliku konfiguracyjnego: %ConfigFile%
    ExitApp
}

; Pierwsza inicjalizacja skrótów
GoSub, LoadHotstrings
return

LoadHotstrings:
FileRead, FileContent, %ConfigFile%

; Przetwórz każdą linię
Loop, Parse, FileContent, `n, `r
{
    ; Pomiń puste linie i komentarze
    if (A_LoopField = "" || SubStr(A_LoopField, 1, 1) = ";" || SubStr(A_LoopField, 1, 1) = "#")
        continue
        
    ; Pomiń nagłówki sekcji
    if (SubStr(A_LoopField, 1, 1) = "[")
        continue
        
    ; Znajdź pozycję znaku =
    pos := InStr(A_LoopField, "=")
    if (pos)
    {
        shortcut := SubStr(A_LoopField, 1, pos-1)
        text := SubStr(A_LoopField, pos+1)
        
        ; Usuń spacje z początku i końca
        shortcut := Trim(shortcut)
        text := Trim(text)
        
        if (shortcut && text)
        {
            ; Konwertuj `n na {Enter} jeśli występuje w tekście
            text := StrReplace(text, "``n", "{Enter}")
            Hotstring("::" . shortcut, text)
        }
    }
}

; Dodaj dynamiczne skróty daty/czasu
FormatTime, CurrentDate,, dd.MM.yyyy
FormatTime, CurrentTime,, HH:mm

::[data]::%CurrentDate%
::[czas]::%CurrentTime%
::[dt]::%CurrentDate% %CurrentTime%

return

; Skrót do manualnego przeładowania (Ctrl+Alt+R)
^!r::
Reload
return
