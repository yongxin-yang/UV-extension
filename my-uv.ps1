$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

# =====================================================================
# my-uv: UV Environment Management Functions (CLI Wrapper)
# =====================================================================

function Show-Help {
    Write-Host @"
my-uv: Manage UV environments

Usage:
  my-uv activate <env-name>      Activate an environment
  my-uv deactivate               Deactivate current environment
  my-uv new <env-name> [python]  Create new environment (optional Python version)
  my-uv list                     List all environments
  my-uv delete <env-name>        Delete an environment
  my-uv help                     Show this help message

Aliases:
  my-uv a <env-name>             Activate
  my-uv d                        Deactivate
  my-uv n <env-name> [python]    New
  my-uv l                        List
  my-uv del <env-name>           Delete
"@ -ForegroundColor Cyan
}

# -------------------------------
# 1. Activate UV environment
# -------------------------------
function uv-activate { param([string]$EnvName)
    $envPath = Join-Path $env:UV_ENVS_DIR $EnvName
    $activateScript = Join-Path $envPath "Scripts\Activate.ps1"
    $pythonExePath = Join-Path $envPath "Scripts\python.exe"

    if (-not (Test-Path $activateScript)) { Write-Error "Error: Environment '$EnvName' not found!"; return }

    & $activateScript
    $env:UV_PROJECT_ENVIRONMENT = $envPath
    $env:UV_PYTHON = $pythonExePath

    Write-Host "`nActivated UV environment: $EnvName" -ForegroundColor Green
    Write-Host "  UV_PROJECT_ENVIRONMENT = $envPath" -ForegroundColor Cyan
    Write-Host "  UV_PYTHON              = $pythonExePath" -ForegroundColor Cyan
}

# -------------------------------
# 2. Deactivate UV environment
# -------------------------------
function uv-deactivate {
    if (Test-Path function:deactivate) { deactivate }
    foreach ($var in "UV_PROJECT_ENVIRONMENT","UV_PYTHON") {
        if (Test-Path "env:$var") { Remove-Item "env:$var" -ErrorAction SilentlyContinue }
    }
    Write-Host "`nUV environment deactivated and variables cleared." -ForegroundColor Yellow
}

# -------------------------------
# 3. Create new UV environment
# -------------------------------
function uv-new { param([string]$EnvName, [string]$PythonVer)
    $envPath = Join-Path $env:UV_ENVS_DIR $EnvName
    if (Test-Path $envPath) { Write-Error "Error: Environment '$EnvName' already exists!"; return }

    $cmd = @("venv")
    if ($PythonVer) { $cmd += "--python"; $cmd += $PythonVer }
    $cmd += "`"$envPath`""

    try {
        Write-Host "Creating UV environment: $EnvName..." -ForegroundColor Cyan
        Invoke-Expression "uv $($cmd -join ' ')"
        Write-Host "Success! Activate with: my-uv activate `"$EnvName`"" -ForegroundColor Green
    } catch { Write-Error "Creation failed: $_" }
}

# -------------------------------
# 4. List all UV environments
# -------------------------------
function uv-list {
    if (-not (Test-Path $env:UV_ENVS_DIR)) { Write-Warning "UV environment directory not found: $env:UV_ENVS_DIR"; return }

    $envs = Get-ChildItem $env:UV_ENVS_DIR -Directory | Select-Object -ExpandProperty Name
    if ($envs.Count -eq 0) { Write-Host "No UV environments found." -ForegroundColor Yellow; return }

    Write-Host "`nUV Environments ($($envs.Count) total):" -ForegroundColor Cyan
    $envs | ForEach-Object { Write-Host "  - $_" }
}

# -------------------------------
# 5. Delete UV environment
# -------------------------------
function uv-delete { param([string]$EnvName)
    $envPath = Join-Path $env:UV_ENVS_DIR $EnvName
    if (-not (Test-Path $envPath)) { Write-Error "Error: Environment '$EnvName' not found"; return }
    if ($env:UV_PROJECT_ENVIRONMENT -eq $envPath) { Write-Error "Error: Cannot delete active environment '$EnvName'. Run 'my-uv deactivate' first."; return }

    $confirm = Read-Host "Delete '$EnvName'? (Y/N)"
    if ($confirm -in "Y","y") { Remove-Item $envPath -Recurse -Force; Write-Host "UV environment deleted: $EnvName" -ForegroundColor Green }
    else { Write-Host "Deletion cancelled." -ForegroundColor Yellow }
}

# -------------------------------
# Command dispatcher using $args
# -------------------------------
if ($args.Count -eq 0) { Show-Help; return }

$cmd = $args[0].ToLower()
$cmdArgs = if ($args.Count -gt 1) { $args[1..($args.Count-1)] -join " " } else { "" }

switch ($cmd) {
    "activate"   { uv-activate $cmdArgs }
    "a"          { uv-activate $cmdArgs }
    "deactivate" { uv-deactivate }
    "d"          { uv-deactivate }
    "new"        { $parts = $cmdArgs -split ' ',2; uv-new $parts[0] $parts[1] }
    "n"          { $parts = $cmdArgs -split ' ',2; uv-new $parts[0] $parts[1] }
    "list"       { uv-list }
    "l"          { uv-list }
    "delete"     { uv-delete $cmdArgs }
    "del"        { uv-delete $cmdArgs }
    "help"       { Show-Help }
    "--help"     { Show-Help }
    default      { Write-Host "Unknown command: $cmd" -ForegroundColor Red; Show-Help }
}