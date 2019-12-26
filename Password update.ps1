function CreateEmailCredential {
    $path = ".\email.cred"
    if (Test-Path $path -PathType Leaf) {
        New-Item -Path $path -Type File
        Set-Content $path $secureStringText    
    }
    else {
        Set-Content $path $secureStringText    
    }
}
$password = Read-Host 'What is your password?' -AsSecureString
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$secureStringText = $secureStringPwd | ConvertFrom-SecureString 
CreateEmailCredential

#Reference https://blog.kloud.com.au/2016/04/21/using-saved-credentials-securely-in-powershell-scripts/

