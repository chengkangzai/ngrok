Set-Location C:\ngrok
$config=Get-Content .\setup.json | ConvertFrom-Json
Set-Location $config.dirPath
Import-Module ".\core.psm1" -DisableNameChecking

function StartNgrok {
    $process = (Get-Process -Name ngrok -ErrorAction SilentlyContinue).Count
    if ($process -eq 0) {
        Write-Host "Initiate NGROK now"
        $param = "tcp 3389 --region=ap"
        Start-Process .\ngrok.exe $param -WindowStyle Hidden
        Start-Sleep 5
        Write-Host "Initializing NGROK with param $param "
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
