# https://support.microsoft.com/en-us/topic/when-trying-to-install-updates-from-windows-update-you-might-receive-updates-failed-there-were-problems-installing-some-updates-but-we-ll-try-again-later-with-errors-0x80073701-0x800f0988-e74b3505-f054-7f15-ec44-6ec0ab15f3e0
# https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/clean-up-the-winsxs-folder?view=windows-10

Write-Host 'Cleaning up the WinSxS folder...'

Try {
    Start-Process -FilePath 'DISM.exe' -ArgumentList '/Online /Cleanup-Image /StartComponentCleanup' -Wait
    Exit 0
} Catch {
    Write-Host "Noe gikk galt..."
    Write-Error $_.Exception.Message
    Exit 1
}