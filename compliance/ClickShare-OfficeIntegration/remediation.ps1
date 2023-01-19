$barcoPath = 'HKCU:\SOFTWARE\Barco\ClickShare Client'

# Process name
$process = "clickshare_native"

# Stop process if running
$activeprocess = Get-Process -ProcessName $process -ErrorAction SilentlyContinue
if ($activeprocess) {
    Stop-Process -ProcessName $process -Force
}

Try {
    if ((Test-Path -LiteralPath $barcoPath) -ne $true) {
        New-Item $barcoPath -Force -ErrorAction SilentlyContinue
    }
    if ((Test-Path -LiteralPath "$barcoPath\calendar") -ne $true) {
        New-Item "$barcoPath\calendar" -Force -ErrorAction SilentlyContinue
    }
    if ((Test-Path -LiteralPath "$barcoPath\WindowPosition") -ne $true) {
        New-Item "$barcoPath\WindowPosition" -Force -ErrorAction SilentlyContinue
    }

    Set-ItemProperty -LiteralPath $barcoPath -Name 'CalendarIntegrationImprovement' -Value 'done' -Type String -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -LiteralPath $barcoPath -Name 'CalendarIntegration' -Value 'false' -Type String -Force -ErrorAction SilentlyContinue

    # Start process
    $appversion = (Get-ChildItem "$($env:USERPROFILE)\AppData\Local\ClickShare" -Filter app* -ErrorAction SilentlyContinue).name
    $path = "$($env:USERPROFILE)\AppData\Local\ClickShare\$($appversion)\clickshare_native.exe"

    if ($activeprocess) {
        if ($appversion) {
            Start-Process -FilePath $path -ErrorAction SilentlyContinue
        }
        else {
            Start-Process -FilePath "$env:LOCALAPPDATA\ClickShare\app-4.27.0-b8\clickshare_native.exe" -ErrorAction SilentlyContinue
        }
    }

}

Catch {
    exit 1
}