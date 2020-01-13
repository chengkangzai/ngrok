$config=Get-Content .\setup.json | ConvertFrom-Json
$dir=$config.dirPath
$sleepTime = $config.spamTimeInSecond 
Write-Host "Setting Location to $dir"
Set-Location $dir

Import-Module ".\core.psm1" -DisableNameChecking

function StartNgrok {
    $process = (Get-Process -Name ngrok -ErrorAction SilentlyContinue).Count
    if ($process -eq 0) {
        Write-Host "Initiate NGROK now"
        Start-Process .\ngrok.exe "tcp 3389 -region=ap" -WindowStyle Hidden  
        Send-Restart
    }else{
        Write-Host "Ngrok is started"
        Send-Spam
    }        
}    

$stat = $true
while ($stat) {
    if (Test-Connection www.google.com -Quiet) {
        Write-Host "Network Connection detected!"
        StartNgrok
        Write-Host "Start Sleep for $sleepTime second"
        Start-Sleep $sleepTime
    }
    else {
        Write-Host "No Network! what the heck!?"
        Start-Sleep 10
    }
}

