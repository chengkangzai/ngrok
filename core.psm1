$pcname = HOSTNAME.EXE
$pcname = $pcname.ToUpper()

function Send-Email {
    [CmdletBinding()]
    param (
        #is it a heartbeat ? 0 = yes, 1= Restart
        [Parameter(Mandatory=$true)]
        [bool]
        $Heartbeat,
        #What is the tunnel port ?
        [Parameter(Mandatory=$true)]
        [string]
        $port,
        #What is the IP address in the VPN
        [Parameter(Mandatory=$false)]
        [string]
        $ipaddress
    )
    if ($Heartbeat -eq $true) {
        $heading = "Heart Beat! "
        $status = "$pcname heart beat at $currentTimestamp"
    }
    else {
        $heading = "Restart! "
        $status = "$pcname restarted at $currentTimestamp"
    }
    Write-Host "--------------------- Send Email ------------------------------"
    Write-Host "The type of notify is $heading"
    $config = Get-Content .\setup.json | ConvertFrom-Json
    Set-Location $config.dirPath

    $currentTimestamp = Get-Date -Format g
    $username = $config.From
    $pwdTxt = Get-Content ".\email.cred"
    $securePwd = $pwdTxt | ConvertTo-SecureString 
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd

    
    $From = $config.From
    $To = $config.To
    $Subject = " $pcname ngrok port update"

    
    Write-Host "Preparing Email "
    Write-Host "Send from : $From "
    Write-Host "Send to : $To"
    Write-Host "Current Time : $currentTimestamp"
    $Body = "<html>
    
<head>
    <meta name='viewport' content='width=device-width'>
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
    <style>
        @media only screen and (max-width: 620px) {
            table[class=body] h1 {
                font-size: 28px !important;
                margin-bottom: 10px !important;
            }
            table[class=body] p,
            table[class=body] ul,
            table[class=body] ol,
            table[class=body] td,
            table[class=body] span,
            table[class=body] a {
                font-size: 16px !important;
            }
            table[class=body] .wrapper,
            table[class=body] .article {
                padding: 10px !important;
            }
            table[class=body] .content {
                padding: 0 !important;
            }
            table[class=body] .container {
                padding: 0 !important;
                width: 100% !important;
            }
            table[class=body] .main {
                border-left-width: 0 !important;
                border-radius: 0 !important;
                border-right-width: 0 !important;
            }
            table[class=body] .btn table {
                width: 100% !important;
            }
            table[class=body] .btn a {
                width: 100% !important;
            }
            table[class=body] .img-responsive {
                height: auto !important;
                max-width: 100% !important;
                width: auto !important;
            }
        }
        
        @media all {
            .ExternalClass {
                width: 100%;
            }
            .ExternalClass,
            .ExternalClass p,
            .ExternalClass span,
            .ExternalClass font,
            .ExternalClass td,
            .ExternalClass div {
                line-height: 100%;
            }
            .apple-link a {
                color: inherit !important;
                font-family: inherit !important;
                font-size: inherit !important;
                font-weight: inherit !important;
                line-height: inherit !important;
                text-decoration: none !important;
            }
        }
    </style>
</head>

<body class='' style='background-color: #f6f6f6; font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;'>
    <table border='0' cellpadding='0' cellspacing='0' class='body' style='border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background-color: #f6f6f6;'>
        <tr>
            <td style='font-family: sans-serif; font-size: 14px; vertical-align: top;'>&nbsp;</td>
            <td class='container' style='font-family: sans-serif; font-size: 14px; vertical-align: top; display: block; Margin: 0 auto; max-width: 580px; padding: 10px; width: 580px;'>
                <div class='content' style='box-sizing: border-box; display: block; Margin: 0 auto; max-width: 580px; padding: 10px;'> <span class='preheader' style='color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0;'>
                $heading
                </span>
                    <table class='main' style='border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background: #ffffff; border-radius: 3px;'>
                        <tr>
                            <td class='wrapper' style='font-family: sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 20px;'>
                                <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;'>
                                    <tr>
                                        <td style='font-family: sans-serif; font-size: 14px; vertical-align: top;'>
                                            <p style='font-family: sans-serif; font-size: 20px; font-weight: normal; margin: 0; Margin-bottom: 15px;'>Hello,</p>
                                            <p style='font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; Margin-bottom: 15px;'>$status</p>
                                            <p style='font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; Margin-bottom: 15px;'>The ngrok port for this pc is :<br>$port</p>
                                            <p style='font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; Margin-bottom: 15px;'>The ngrok port for this pc is :<br>$ipaddress</p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
            <td style='font-family: sans-serif; font-size: 14px; vertical-align: top;'>&nbsp;</td>
        </tr>
    </table>
</body>

</html>"
    $SMTPServer = $config.SMTPServer
    $SMTPPort = $config.SMTPPort

    Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -port $SMTPPort -UseSsl -Credential $cred -DeliveryNotificationOption OnFailure
    Write-Host "Email is sent"
}
function Send-Discord {
    [CmdletBinding()]
    param (
        #is it a heartbeat ? 0 = yes, 1= Restart
        [Parameter(Mandatory=$false)]
        [bool]
        $Heartbeat,
        #What is the tunnel port ?
        [Parameter()]
        [string]
        $port,
        #What is the IP address in the VPN
        [Parameter(Mandatory=$false)]
        [string]
        $ipaddress
    )
    Write-Host "---------------Discord------------------------------"
    Write-Host "initialize Discord Webhook"
    if ($Heartbeat -eq $true ) {
        $Heartbeatinfo = "Heart Beat" 
    }
    else {
        $Heartbeatinfo = "Restart" 
    }
    Write-Host "Current Type of notify : $Heartbeatinfo "
    $config = Get-Content .\setup.json | ConvertFrom-Json
    $DiscordUrl = $config.discordWebHookUrl 
    
    if ($ipaddress -eq "") {
        $DiscordBody = @{
            "content" = "[ $pcname | $Heartbeatinfo ] $port"
        }    
    }else {
        $DiscordBody = @{
            "content" = "[ $pcname | $Heartbeatinfo ] $port [ IP ] $ipaddress"
        }  
    }
    
    $message = $DiscordBody.content
    Write-Host "Sending message $message"
    $discord = Invoke-WebRequest -Uri $DiscordUrl -Method Post -Body $DiscordBody 
    $discordResposnse = $discord.StatusCode
    if ($discordResposnse -eq "204") {
        Write-Host "Message send successfully "
    }
    else {
        Write-Host "Message didnt send well, here is the response $discordResposnse"
    }   
    
}
function Clear-cache {
    Remove-Variable * -ea SilentlyContinue
    Remove-Module *
    $error.Clear()
    Clear-Host
}

function Get-VPNIPAddress {
    #Getting VPN IP Address 
    $ip=(Get-NetIPAddress -IPAddress "10.0.0*").IPAddress 
    return $ip
}
function Get-NgrokPort {
    $stat = $true
    while ($stat) {
        Write-Host "------------ Get Ngrok Port -----------------"
        Write-Host "Finding the ngrok port"
        $tunnel = Invoke-WebRequest -Uri "http://localhost:4040/api/tunnels" -UseBasicParsing | ConvertFrom-Json
        $port = $tunnel[0].tunnels.public_url
        if ($port -like "*.ngrok*") {
            Write-Host "Hey! Got cha cover! We got the port already !"
            Write-Host "The ngrok port : $port "
            $stat = $false
            return $port
        }
        else {
            Start-Sleep 10
        }
    }    
}
function Send-Heartbeat {
    $port = Get-NgrokPort 
    $ipaddress=Get-VPNIPAddress
    Send-Discord -port $port -Heartbeat $true -ipaddress $ipaddress
    Send-Email -port $port -Heartbeat $true -ipaddress $ipaddress
}
function Send-Restart {
    $port = Get-NgrokPort 
    $ipaddress = Get-VPNIPAddress
    Send-Discord -port $port -ipaddress $ipaddress
    Send-Email -port $port -ipaddress $ipaddress
}

function Send-Spam {
    $port = Get-NgrokPort 
    $ipaddress= Get-VPNIPAddress 
    Send-Discord -port $port -Heartbeat $true -ipaddress $ipaddress
}