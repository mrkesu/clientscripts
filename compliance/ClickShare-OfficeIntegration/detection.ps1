$exit = 0

$barcoPath = 'HKCU:\SOFTWARE\Barco\ClickShare Client'

if (Test-Path $barcoPath) {
    if ( (Get-ItemProperty -LiteralPath $barcoPath -Name 'CalendarIntegration' -ErrorAction SilentlyContinue).CalendarIntegration -ne 'false' ) {
        Write-Host "CalendarIntegration not equal 'false'"
        $exit = 1
    }

    if ( (Get-ItemProperty -LiteralPath $barcoPath -Name 'CalendarIntegrationImprovement' -ErrorAction SilentlyContinue).CalendarIntegrationImprovement -ne 'done' ) {
        Write-Host "CalendarIntegration not equal 'done'"
        $exit = 1
    }
}

Exit $exit