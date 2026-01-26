$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

# =====================================================================
# UV Environment Management Functions (Extended, English Only)
# Supports automatic environment variable sync for uv projects
# =====================================================================

# -------------------------------
# 1. Activate UV environment
# -------------------------------
function uv-activate {
    param(
        [Parameter(Mandatory=$true, HelpMessage="Name of the environment to activate (e.g. myproject)")]
        [string]$EnvName
    )

    $envPath = Join-Path $env:UV_ENVS_DIR $EnvName
    $activateScript = Join-Path $envPath "Scripts\Activate.ps1"
    $pythonExePath = Join-Path $envPath "Scripts\python.exe"

    # Check if environment exists
    if (-not (Test-Path $activateScript)) {
        Write-Error "Error: Environment '$EnvName' not found. Check path: $activateScript"
        return
    }

    # Activate the virtual environment
    & $activateScript

    # Set UV environment variables
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
    # Call original deactivate if it exists
    if (Test-Path function:deactivate) {
        deactivate
    }

    # Remove UV environment variables
    foreach ($var in "UV_PROJECT_ENVIRONMENT","UV_PYTHON") {
        if (Test-Path "env:$var") {
            Remove-Item "env:$var" -ErrorAction SilentlyContinue
            Write-Host "Removed environment variable: $var" -ForegroundColor DarkGray
        }
    }

    Write-Host "`nUV environment deactivated and variables cleared." -ForegroundColor Yellow
}

# -------------------------------
# 3. Create new UV environment
# -------------------------------
function uv-new {
    param(
        [Parameter(Mandatory=$true, HelpMessage="Name of the new environment")]
        [string]$EnvName,
        [string]$PythonVer
    )

    $envPath = Join-Path $env:UV_ENVS_DIR $EnvName

    if (Test-Path $envPath) {
        Write-Error "Error: Environment '$EnvName' already exists at $envPath"
        return
    }

    $cmd = @("venv")
    if ($PythonVer) { $cmd += "--python", $PythonVer }
    $cmd += "`"$envPath`""

    try {
        Write-Host "Creating UV environment: $EnvName (Path: $envPath)" -ForegroundColor Cyan
        Invoke-Expression "uv $($cmd -join ' ')"
        Write-Host "Success! Activate with: uv-activate $EnvName" -ForegroundColor Green
    }
    catch {
        Write-Error "Creation failed: $_"
        if (Test-Path $envPath) {
            Remove-Item $envPath -Recurse -Force
            Write-Host "Residual files removed" -ForegroundColor Yellow
        }
    }
}

# -------------------------------
# 4. List all UV environments
# -------------------------------
function uv-list {
    if (-not (Test-Path $env:UV_ENVS_DIR)) {
        Write-Warning "UV environment directory not found: $env:UV_ENVS_DIR"
        return
    }

    $envs = Get-ChildItem $env:UV_ENVS_DIR -Directory | Select-Object -ExpandProperty Name
    if ($envs.Count -eq 0) {
        Write-Host "No UV environments found." -ForegroundColor Yellow
        return
    }

    Write-Host "`nUV Environments ($($envs.Count) total):" -ForegroundColor Cyan
    $envs | ForEach-Object { Write-Host "  - $_" }
    Write-Host "`nUse: uv-activate <env-name> to start" -ForegroundColor Gray
}

# -------------------------------
# 5. Delete UV environment
# -------------------------------
function uv-delete {
    param(
        [Parameter(Mandatory=$true, HelpMessage="Name of the environment to delete")]
        [string]$EnvName
    )

    $envPath = Join-Path $env:UV_ENVS_DIR $EnvName

    if (-not (Test-Path $envPath)) {
        Write-Error "Error: Environment '$EnvName' not found"
        return
    }

    if ($env:UV_PROJECT_ENVIRONMENT -eq $envPath) {
        Write-Error "Error: Cannot delete active environment '$EnvName'. Run 'uv-deactivate' first."
        return
    }

    $confirm = Read-Host "Delete '$EnvName'? (Y/N)"
    if ($confirm -in "Y","y") {
        try {
            Remove-Item $envPath -Recurse -Force
            Write-Host "UV environment deleted: $EnvName" -ForegroundColor Green
        }
        catch {
            Write-Error "Deletion failed: $_"
        }
    }
    else {
        Write-Host "Deletion cancelled" -ForegroundColor Yellow
    }
}