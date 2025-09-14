# Ruta a Chrome
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# Lista de ventanas (cada una con su perfil y archivo local)
$ventanas = @(
    @{ Profile = "C:\ChromeProfiles\Perfil15"; FilePath = "C:\Users\monsi\Desktop\ROL\7. Misiones HTML\15. Bestiario.html" }
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