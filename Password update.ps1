$password = "Your Frikin Password"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$secureStringText = $secureStringPwd | ConvertFrom-SecureString 
Set-Content "C:\ngrok\email.cred" $secureStringText