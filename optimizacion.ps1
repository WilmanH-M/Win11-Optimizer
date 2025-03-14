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
    Write-Host "[8] Actualizar Sistema"
    Write-Host "[9] Configurar Seguridad"
    Write-Host "[0] Salir"
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Cyan
    $option = Read-Host "Elige una opción [1,2,3,4,5,6,7,8,9,0]"
    return $option
}

function Remove-Bloatware {
    Write-Host "Eliminando Bloatware..." -ForegroundColor Yellow
    .\debloat.ps1
}

function Disable-Services {
    Write-Host "Desactivando Servicios Innecesarios..." -ForegroundColor Yellow
    $services = @("DiagTrack", "dmwappushservice", "WSearch", "Fax", "XblGameSave", "XboxNetApiSvc", "RetailDemo", "MapsBroker", "WalletService")
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
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Value 1
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "SecondLevelDataCache" -Value 256
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "IoPageLockLimit" -Value 134217728
    Set-MpPreference -DisableRealtimeMonitoring $true
    Set-MpPreference -DisableBehaviorMonitoring $true
    Set-MpPreference -DisableIOAVProtection $true
    Set-MpPreference -DisablePrivacyMode $true
}

function Clean-TempFiles {
    Write-Host "Limpiando Archivos Temporales..." -ForegroundColor Yellow
    Get-ChildItem -Path "C:\Windows\Temp","C:\Users\$env:UserName\AppData\Local\Temp" -Recurse -Force | Remove-Item -Force -Recurse
    Write-Host "Archivos temporales limpiados." -ForegroundColor Green
}

function Activate-WindowsOffice {
    Write-Host "Activando Windows y Office..." -ForegroundColor Yellow
    .\activate.ps1
}

function Show-SystemStatus {
    Write-Host "Estado del Sistema:" -ForegroundColor Cyan
    Get-ComputerInfo | Select-Object CsName, OsName, WindowsVersion, OsArchitecture, CsTotalPhysicalMemory
}

function Restore-Defaults {
    Write-Host "Restaurando configuración original..." -ForegroundColor Yellow
    .\restore.ps1
}

function Update-System {
    Write-Host "Actualizando el sistema y software..." -ForegroundColor Yellow
    Install-Module PSWindowsUpdate -Force -SkipPublisherCheck
    Import-Module PSWindowsUpdate
    Get-WindowsUpdate -Install -AcceptAll -AutoReboot
}

function Configure-Security {
    Write-Host "Configurando las políticas de seguridad..." -ForegroundColor Yellow
    Set-MpPreference -DisableRealtimeMonitoring $false
    Set-MpPreference -DisableBehaviorMonitoring $false
    Set-MpPreference -DisableIOAVProtection $false
    Set-MpPreference -DisablePrivacyMode $false
    New-NetFirewallRule -DisplayName "Bloquear conexiones entrantes" -Direction Inbound -Action Block -Profile Any
    New-NetFirewallRule -DisplayName "Bloquear conexiones salientes" -Direction Outbound -Action Block -Profile Any
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
        "8" { Update-System }
        "9" { Configure-Security }
        "0" { exit }
        default { Write-Host "Opción no válida, intenta de nuevo." -ForegroundColor Red }
    }
    Pause
} while ($choice -ne "0")
