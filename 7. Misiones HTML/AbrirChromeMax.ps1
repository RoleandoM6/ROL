# Ruta a Chrome
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# Lista de ventanas (cada una con su perfil y archivo local)
$ventanas = @(
    @{ Profile = "C:\ChromeProfiles\Perfil1"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\1. Barra INI.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil2"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\2. Listado INI.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil3"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\3. ALGO.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil5"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\4. Tablero.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil4"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\5. Calendario.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil6"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\6. Diario.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil7"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\7. Mapamundi.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil8"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\8. Condiciones.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil9"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\9. Tienda.html" }

    )

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
