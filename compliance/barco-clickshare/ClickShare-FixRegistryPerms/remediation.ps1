# AppX sin tilgangsbruker er lokalisert, så avhenger av OS-språk. Må derfor søke opp via SID for å få korrekt brukernavn.
$objSID = New-Object System.Security.Principal.SecurityIdentifier ("S-1-15-2-1") #	"APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES - All applications running in an app package context."
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$user = $objUser.Value
$PackagesUser = $user.Split('\')
$PackagesUser = $PackagesUser[1]

$key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-12-1-*'
$profiles = (Get-Item $key)

Foreach ($profile in $profiles) {
    $sids = $profile
    $sids = Split-Path -Path $sids -Leaf
    $user = "HKU:\$sids\"
    $test = Test-Path $user

    if ($test -eq $true) {
        $Folder = "HKU:\$sids\Software\Microsoft\windows\currentversion\explorer\"
        $Acl = Get-Acl $folder
        $AccessRule = New-Object System.Security.AccessControl.RegistryAccessRule($PackagesUser, "Readkey", "ContainerInherit", "None", "Allow")
        $Acl.SetAccessRule($AccessRule)
        Set-Acl $folder $Acl

        $Folder = "HKU:\$sids\Software\Microsoft\windows\currentversion\explorer\user shell folders"
        $Acl = Get-Acl $folder
        $AccessRule = New-Object System.Security.AccessControl.RegistryAccessRule($PackagesUser, "Readkey", "ContainerInherit", "None", "Allow")
        $Acl.SetAccessRule($AccessRule)
        Set-Acl $folder $Acl
    }
}

Get-AppXPackage -AllUsers | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }