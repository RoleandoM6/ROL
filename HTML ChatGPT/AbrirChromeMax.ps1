# Ruta a Chrome
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# Lista de ventanas (cada una con su perfil y archivo local)
$ventanas = @(
    @{ Profile = "C:\ChromeProfiles\Perfil1"; FilePath = "C:\Users\monsi\Desktop\ROL\HTML ChatGPT\1. Barra de Iniciativa.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil2"; FilePath = "C:\Users\monsi\Desktop\ROL\HTML ChatGPT\2. Listado de Iniciativa.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil3"; FilePath = "C:\Users\monsi\Desktop\ROL\HTML ChatGPT\3. Rondas.html" },
    @{ Profile = "C:\ChromeProfiles\Perfil5"; FilePath = "C:\Users\monsi\Desktop\ROL\HTML ChatGPT\4. Tablero.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil4"; FilePath = "C:\Users\monsi\Desktop\ROL\HTML ChatGPT\5. Calendario y Tiempo.html" }
    @{ Profile = "C:\ChromeProfiles\Perfil6"; FilePath = "C:\Users\monsi\Desktop\ROL\HTML ChatGPT\6. Diario de Misiones.html" }
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
