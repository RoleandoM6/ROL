# Ruta a Chrome
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# Lista de ventanas (cada una con su perfil y archivo local)
$ventanas = @(
 #  @{ Profile = "C:\ChromeProfiles\Perfil0"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\0.WIP-DVD.html" 
    @{ Profile = "C:\ChromeProfiles\Perfil1"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\1.Crono.html" }
 #                                  Perfil2 DADOS 
 #  @{ Profile = "C:\ChromeProfiles\Perfil3"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\3.Condiciones.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil4"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\4.Bestiario.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil5"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\5.Hojas PJ.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil6"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\6.Diario.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil7"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\7.Calendario.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil8"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\8.Objetos Errantes.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil9"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\9.Tiendas.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil10"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\10.Mapamundi.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil11"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\11.Listado de Iniciativa.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil12"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\12.Barra de Iniciativa.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil13"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\13.Ajedrez.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil14"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\14.Majunji.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil15"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\15.Tablero.html" }





)

# --- ABRIR HTMLS EN CHROME ---
foreach ($v in $ventanas) {
    $dir = $v.Profile
    $path = $v.FilePath

    # Asegura que la carpeta de perfil existe
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    # Convierte la ruta local a URL file:// con espacios correctamente codificados
    $uri = [System.Uri]::new($path).AbsoluteUri

    # Comprueba si ya hay un chrome.exe abierto con ese --user-data-dir
    $pattern = "--user-data-dir=""?{0}""?(\s|$)" -f ([regex]::Escape($dir))
    $yaExiste = Get-CimInstance Win32_Process -Filter "Name='chrome.exe'" |
                Where-Object { $_.CommandLine -match $pattern }

    if (-not $yaExiste) {
        Start-Process -FilePath $chrome -ArgumentList @("--user-data-dir=""$dir""","--new-window","$uri","--start-maximized") | Out-Null
        Start-Sleep -Milliseconds 200
    }
}

# --- ABRIR ACCESOS DIRECTOS ---
#$links = @(
 #   "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\1. Hoja PJ 01.lnk",
  #  "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\1. Hoja PJ 02.lnk",
   # "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\1. Hoja PJ 03.lnk",
    #"C:\Users\monsi\Desktop\ROL\7. Misiones HTML\1. Hoja PJ 04.lnk",
    #"C:\Users\monsi\Desktop\ROL\7. Misiones HTML\1. Hoja PJ 05.lnk"
#)

foreach ($link in $links) {
    Start-Process -FilePath $link
    Start-Sleep -Milliseconds 200   # pequeña pausa opcional
}
