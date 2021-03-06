function CreateEmailCredential {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $secureStringText
    )
    Set-Location C:\ngrok
    $config=Get-Content .\setup.json | ConvertFrom-Json
    Set-Location $config.dirPath
    $path="C:\ngrok\email.cred"
    if (Test-Path $path -PathType Leaf) {
        Set-Content $path $secureStringText    
    }
    else {
        New-Item -Path $path -Type File
        Set-Content $path $secureStringText    
    }
}
$password = Read-Host 'What is your password?' -AsSecureString
$secureStringText = $password | ConvertFrom-SecureString 
CreateEmailCredential -secureStringText $secureStringText
Pause 
#Reference https://blog.kloud.com.au/2016/04/21/using-saved-credentials-securely-in-powershell-scripts/
