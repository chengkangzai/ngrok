Import-Module ".\core.psm1" -DisableNameChecking

$port = Get-NgrokPort

Send-Email -port $port -Heartbeat 0
Send-Discord -port $port -Heartbeat 0 

