$config=Get-Content .\setup.json | ConvertFrom-Json
Set-Location $config.dirPath

Import-Module ".\core.psm1" -DisableNameChecking

function StartNgrok {
    Write-Host "ngrok is running Running "
    $process = (Get-Process -Name ngrok -ErrorAction SilentlyContinue).Count
    if ($process -eq 0) {
        Write-Host "Initiate NGROK now"
        Start-Process .\ngrok.exe "tcp 3389 -region=ap" -WindowStyle Hidden  
        Send-Restart
    }else{
        Send-Spam
    }        
}    

$stat = $true
while ($stat) {
    if (Test-Connection www.google.com -Quiet) {
        Write-Host "Network Connection detected!  Proceed to start ngrok"
        StartNgrok
        $sleepTime=300
        Write-Host "Start Sleep for $sleepTime second"
        Start-Sleep $sleepTime
    }
    else {
        Write-Host "No Network! what the heck!?"
        Start-Sleep 10
    }
}

