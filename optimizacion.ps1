# Verificar permisos de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Ejecuta este script como Administrador." -ForegroundColor Red
    exit
}

function Show-Menu {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host " Windows 11 Optimization Tool " -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[1] Eliminar Bloatware"
    Write-Host "[2] Desactivar Servicios Innecesarios"
    Write-Host "[3] Optimizar Procesos y Subprocesos"
    Write-Host "[4] Limpiar Archivos Temporales"
    Write-Host "[5] Activar Windows y Office"
    Write-Host "[6] Mostrar Estado del Sistema"
    Write-Host "[7] Restaurar Configuración por Defecto"
    Write-Host "[0] Salir"
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Cyan
    $option = Read-Host "Elige una opción [1,2,3,4,5,6,7,0]"
    return $option
}

function Remove-Bloatware {
    Write-Host "Eliminando Bloatware..." -ForegroundColor Yellow
    irm https://git.io/debloat | iex
}

function Disable-Services {
    Write-Host "Desactivando Servicios Innecesarios..." -ForegroundColor Yellow
    $services = @("DiagTrack", "dmwappushservice", "WSearch", "Fax", "XblGameSave", "XboxNetApiSvc")
    foreach ($service in $services) {
        Get-Service -Name $service -ErrorAction SilentlyContinue | Stop-Service -Force -PassThru | Set-Service -StartupType Disabled
    }
}

function Optimize-Processes {
    Write-Host "Optimizando Procesos y Subprocesos..." -ForegroundColor Yellow
    bcdedit /set useplatformtick yes
    bcdedit /set disabledynamictick yes
    bcdedit /set tscsyncpolicy Enhanced
    powercfg -h off
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Value 1
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1
}

function Clean-TempFiles {
    Write-Host "Limpiando Archivos Temporales..." -ForegroundColor Yellow
    Get-ChildItem -Path "C:\Windows\Temp","C:\Users\$env:UserName\AppData\Local\Temp" -Recurse -Force | Remove-Item -Force -Recurse
    Write-Host "Archivos temporales limpiados." -ForegroundColor Green
}

function Activate-WindowsOffice {
    Write-Host "Activando Windows y Office..." -ForegroundColor Yellow
    irm https://get.activated.win | iex
}

function Show-SystemStatus {
    Write-Host "Estado del Sistema:" -ForegroundColor Cyan
    Get-ComputerInfo | Select-Object CsName, OsName, WindowsVersion, OsArchitecture, CsTotalPhysicalMemory
}

function Restore-Defaults {
    Write-Host "Restaurando configuración original..." -ForegroundColor Yellow
    irm https://raw.githubusercontent.com/yourrepo/restore-windows/main/restore.ps1 | iex
}

# Menú principal
do {
    $choice = Show-Menu
    switch ($choice) {
        "1" { Remove-Bloatware }
        "2" { Disable-Services }
        "3" { Optimize-Processes }
        "4" { Clean-TempFiles }
        "5" { Activate-WindowsOffice }
        "6" { Show-SystemStatus }
        "7" { Restore-Defaults }
        "0" { exit }
        default { Write-Host "Opción no válida, intenta de nuevo." -ForegroundColor Red }
    }
    Pause
} while ($choice -ne "0")
