Import-Module ".\core.psm1" -DisableNameChecking

function StartNgrok {
    $process=Get-Process -Name ngrok -ErrorAction SilentlyContinue
    if ($process -eq "") {
        Write-Host "Initiate NGROK now"
        Start-Process .\ngrok.exe "tcp 3389 -region=ap" -WindowStyle Hidden  
        $port = Get-NgrokPort 
        Send-Discord -port $port 
        Send-Email -port $port
    }else {
        $start =Get-Date -Hour 12 -Minute 0 -Second 0
        $end =Get-Date -Hour 12 -Minute 30 -Second 0
        $start1 =Get-Date -Hour 00 -Minute 0 -Second 0
        $end1 =Get-Date -Hour 00 -Minute 30 -Second 0
        $now= Get-Date
        if ($now -ge $start -and $now -le $end ) {
            Write-Host "It's in Spamming Area... Spamming Started"
            $port = Get-NgrokPort 
            Send-Discord -port $port -Heartbeat 1
            Send-Email -port $port -Heartbeat 1
        }elseif ($now -ge $start1 -and $now -le $end1) {
            Write-Host "It's in Spamming Area... Spamming Started"
            $port = Get-NgrokPort 
            Send-Discord -port $port -Heartbeat 1
            Send-Email -port $port -Heartbeat 1
        } else {
            Write-Host "You are not in Spamming Zone, Notify canceled"
        }
    }
    
}

$stat = $true
while($stat){
	if(Test-Connection www.google.com -Quiet){
        $stat = $false
        $process=Get-Process -Name ngrok -ErrorAction SilentlyContinue
        if ($process -eq "") {
            Write-Host "Network Connection detected! Proceed to start ngrok"    
        }else {
            Write-Host "Network Connection detected! Proceed to notify"    
        }
        StartNgrok
	} else {
        Write-Host "No Network! what the heck!?"
		Start-Sleep 10
	}
}


