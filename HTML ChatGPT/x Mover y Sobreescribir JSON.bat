@echo off
set "source=C:\Users\monsi\Downloads"
set "dest=C:\Users\monsi\Desktop\ROL\HTML ChatGPT"

:: Crear carpeta destino si no existe
if not exist "%dest%" mkdir "%dest%"

:: Mover todos los JSON y sobrescribir si ya existen
move /Y "%source%\*.json" "%dest%"

echo Todos los archivos JSON se han movido a "%dest%" y sobrescrito si era necesario.
exit
