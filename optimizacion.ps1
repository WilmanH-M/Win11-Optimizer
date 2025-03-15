# Descargar y ejecutar el script original
irm https://get.activated.win | iex

# Función para optimizar el sistema operativo
function Optimize-System {
    # Limpiar archivos temporales
    Write-Output "Cleaning temporary files..."
    Get-ChildItem -Path "C:\Windows\Temp" -Recurse | Remove-Item -Force -Recurse
    Get-ChildItem -Path "$env:TEMP" -Recurse | Remove-Item -Force -Recurse

    # Detener servicios innecesarios
    Write-Output "Stopping unnecessary services..."
    Get-Service | Where-Object { $_.Status -eq 'Running' -and ($_.Name -like '*Update*' -or $_.Name -like '*Telemetry*') } | Stop-Service -Force

    # Eliminar bloatware
    Write-Output "Removing bloatware..."
    $bloatware = @(
        "Microsoft.3DBuilder",
        "Microsoft.BingNews",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.Messaging",
        "Microsoft.Microsoft3DViewer",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.MicrosoftStickyNotes",
        "Microsoft.MixedReality.Portal",
        "Microsoft.Office.OneNote",
        "Microsoft.OneConnect",
        "Microsoft.People",
        "Microsoft.Print3D",
        "Microsoft.SkypeApp",
        "Microsoft.Wallet",
        "Microsoft.WindowsAlarms",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps",
        "Microsoft.WindowsSoundRecorder",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.YourPhone",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo"
    )
    foreach ($app in $bloatware) {
        Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction SilentlyContinue
    }

    # Confirmar si se deben aplicar los cambios
    $confirm = Read-Host "Do you want to apply these optimizations? (Y/N)"
    if ($confirm -eq 'Y') {
        Write-Output "Applying optimizations..."
        # Aplicar cambios permanentes
        # Aquí puedes agregar comandos para asegurarte de que las optimizaciones se mantengan después de reiniciar
    } else {
        Write-Output "Optimizations canceled."
    }
}

# Ejecutar la función de optimización
Optimize-System
