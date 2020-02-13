Set-Location C:\ngrok
$config=Get-Content .\setup.json | ConvertFrom-Json
Set-Location $config.dirPath
Import-Module ".\core.psm1" -DisableNameChecking

function StartNgrok {
    $process = (Get-Process -Name ngrok -ErrorAction SilentlyContinue).Count
    if ($process -eq 0) {
        Write-Host "Initiate NGROK now"
        Start-Process .\ngrok.exe "tcp 3389 -region=ap" -WindowStyle Hidden  
        Send-Restart
    }
    else {
        Write-Host "Ngrok Detected, sending Heart Beat"
        Send-Heartbeat
    }
}    


$stat = $true
while ($stat) {
    if (Test-Connection www.google.com -Quiet) {
        $stat = $false
        Write-Host "Network Connection detected!"
        StartNgrok
    }
    else {
        Write-Host "No Network! what the heck!?"
        Start-Sleep 10
    }
}
