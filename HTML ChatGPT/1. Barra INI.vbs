Set WshShell = CreateObject("WScript.Shell")

' --- Ajusta el título de tu ventana aquí ---
titulo = "1. Barra INI - Google Chrome"

' Dar un pequeño margen antes de intentar enfocar (opcional)
WScript.Sleep 300

' Activar la ventana con ese título fijo
If WshShell.AppActivate(titulo) Then
    ' Ya está en primer plano
Else
    MsgBox "No se encontró la ventana con el título: " & titulo, vbExclamation
End If
