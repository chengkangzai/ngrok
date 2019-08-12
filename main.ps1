Function Internet{
if (Test-Connection www.google.com -Quiet) {} {netsh wlan connect name="VC-A1-10-06" interface="Wi-Fi"}
}

Internet 
 
start C:\ngrok\ngrok.exe "tcp 3389 -region=ap" -WindowStyle Hidden 

powershell C:\ngrok\updatengrokserver.ps1
