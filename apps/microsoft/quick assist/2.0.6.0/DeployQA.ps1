#Log output results
function LogOutput {
    Param ([string]$logMessage)
    $LogFile = "C:\Temp\Quick-Assist.log"
    Add-Content -Path $LogFile -Value "$(Get-date -format G) - $logMessage"
}

# Hvis sjekk-fil eksisterer, betyr det at scriptet har kjørt før, og dermed avinstallert den brukerspesifikke versjonen
if (!(Test-Path "C:\Temp\QAoffline.zip") -AND !(Test-Path "C:\Temp\Quick-Assist.log")) {
    LogOutput "første gang scriptet kjører, avinstallerer alle Store-installasjoner"
    Get-AppxPackage -AllUsers -PackageTypeFilter Bundle -Name "*quickassist*" | Remove-AppxPackage -AllUsers -Confirm:$false
}
else {
    LogOutput "Scriptet har kjørt før, fjerner ikke eksisterende Store-installasjoner"
}

Try {
    # Check if old pre-store version still exists
    $WinCap = Get-WindowsCapability -Online -Name App.Support.QuickAssist*
    If ($WinCap.State -match "NotPresent") {
        LogOutput "Windows Capability - Quick Assist missing - exiting"
    }
     
    $AppXStatus = Get-AppxPackage -AllUsers "MicrosoftCorporationII.QuickAssist"
    If ($AppXStatus.status -eq 'OK') {
        LogOutput "Status of new version is OK"
        LogOutput "Uninstalling native version of quick assist..."
        Remove-WindowsCapability -Online -Name 'App.Support.QuickAssist~~~~0.0.1.0' -ErrorAction 'SilentlyContinue'
    }
    else {
        LogOutput "Status of new version is NOT OK, installing new QA"

        # Trying to uninstall existing version...
        Try {
            Get-AppxPackage -AllUsers "MicrosoftCorporationII.QuickAssist" | Remove-AppxPackage -AllUsers
        }
        Catch {
            LogOutput "[Error] An error occurred uninstalling The Windows store version of Quick Assist: $($_.Exception.Message)" 
        }

        # Extract files...
        Try {
            Add-Type -A 'System.IO.Compression.FileSystem';
            [IO.Compression.ZipFile]::ExtractToDirectory("$($PSScriptRoot)\QAoffline.zip", 'C:\Temp\QAoffline')
        }
        Catch {
            LogOutput "[Error] Could not extract files: $($_.Exception.Message)" 
        }
        
        # Install Quick Assist offline
        Add-AppxProvisionedPackage -online -PackagePath:"C:\temp\qaoffline\MicrosoftCorporationII.QuickAssist_2022.509.2259.0_neutral___8wekyb3d8bbwe.AppxBundle" -LicensePath:"C:\temp\qaoffline\MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe_4bc27046-84c5-8679-dcc7-d44c77a47dd0.xml"

        # Create shortcut...
        $TargetFile = "C:\Windows\explorer.exe"
        $ShortcutFile = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\QA.lnk"
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
        $Shortcut.Arguments = "shell:AppsFolder\MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe!App"
        $Shortcut.TargetPath = $TargetFile
        $shortcut.HotKey = "CTRL+ALT+X"
        $Shortcut.Save()
    }
    LogOutput "[Info] The Windows store version of Quick Assist has successfully been installed." 
}
catch [exception] {
    LogOutput "[Error] An error occurred: $($_.Exception.Message)" 
}

# Check if old pre-store version still exists and uninstall if it does
$WinCap = Get-WindowsCapability -online -name App.Support.QuickAssist*

If ($WinCap.State -match "NotPresent") {
    LogOutput "Windows Capability - Quick Assist missing - exiting"
}
else {
    LogOutput "Windows Capability - Quick Assist installed, Running Remediation script"
    Remove-WindowsCapability -Online -Name App.Support.QuickAssist~~~~0.0.1.0
}