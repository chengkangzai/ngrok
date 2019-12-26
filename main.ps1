Import-Module ".\core.psm1" -DisableNameChecking

function StartNgrok {
    Start-Process C:\ngrok\ngrok.exe "tcp 3389 -region=ap" -WindowStyle Hidden  
    $port = Get-NgrokPort 

    Send-Discord -port $port 
    Send-Email -port $port
}

$stat = $true
while($stat){
	if(Test-Connection www.google.com -Quiet){
        $stat = $false
        Write-Host "Network Connection detected! Proceed to start ngrok"
        StartNgrok
	} else {
        Write-Host "No Network! what the heck!?"
		Start-Sleep 10
	}
}


