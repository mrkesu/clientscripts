Param
(
    # Param1 help description
    [Parameter(HelpMessage = 'Filsti til script som skal signeres, eller blank for alle ps1-filer i alle undermapper')]
    [ValidateScript({
            if (-Not ($_ | Test-Path) ) {
                throw "Fil eller mappe eksisterer ikke." 
            }
            return $true
        })]
    [System.IO.FileInfo]$Path = $PSScriptRoot
)

# Dobbeltsjekk dersom mappe er spesifisert
if (Test-Path -Path $Path -PathType Container) {
    $choice = ""
    while ($choice -notmatch "[j|n]") {
        Write-Host "Mappe $Path spesifisert."
        $choice = Read-Host "Er du sikker på at du vil fortsette? (J/N)"
    }
    if ($choice -eq "n") {
        exit
    }
}

# Finn kodesigneringssertifikatet for gjeldende bruker
$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert
if (!$cert) {
    Write-Error "Finner ikke kodesigneringssertifikat."
}
elseif ($cert.GetType().Name -eq "Object[]") {
    Write-Error "Fant mere enn et kodesigneringssertifikat."
}

# Hent filer som skal signeres, minus dette scriptet selv :)
$files = Get-ChildItem -Path $Path -Recurse -File -Include "*.ps1" | Where-Object { $_.FullName -ne $PSCommandPath }

$results = @()
foreach ($file in $files.FullName) {

    $signingParameters = @{
        FilePath    = $file
        Certificate = $cert
        TimestampServer = 'http://timestamp.digicert.com'
        # Timestampserver er ikke nødvendig, men ved å legge til en timestamp så vil ikke signaturen
        # bli ugyldig den dagen sertifikatet utløper. Det holder å vite at sertifikatet var gyldig når vi signerte :)
        # Med andre ord slipper vi da å re-signere script senere.
    }

    $results += Set-AuthenticodeSignature @signingParameters

    if ($results[-1].Status -ne "Valid") {
        Write-Error "$file - Signering feilet."
    }
}

$results | Select-Object -Property Status, StatusMessage, Path