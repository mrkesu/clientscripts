$result = Get-AppxPackage -AllUsers "MicrosoftCorporationII.QuickAssist"

if($null -ne $result -AND [System.Version]::Parse($result.Version) -ge "2.0.6.0") {
    # Found the package
    Write-Host $result
}