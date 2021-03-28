import urllib.request
from socket import gethostname

import base64
import getpass
import json
import psutil
import requests
import smtplib
import socket
import ssl
import time


class Config:
    def __init__(self):
        file = open('config.json')
        config = json.loads(file.read())
        self.From = config["From"]
        self.To = config["To"]
        self.SMTPServer = config["SMTPServer"]
        self.SMTPPort = config["SMTPPort"]
        self.discordWebHookUrl = config["discordWebHookUrl"]
        self.webServerUrl = config["webServerUrl"]
        self.spamTimeInSecond = config["spamTimeInSecond"]
        file.close()

    @staticmethod
    def savePassword() -> str:
        pswd = getpass.getpass('Password:')
        secureString = str(base64.b64encode(pswd.encode("utf-8"))).replace("b", "").replace("'", "")
        f = open('../email.py.cred', 'w')
        f.write(secureString)
        f.close()
        return secureString

    @staticmethod
    def getPassword():
        return str(base64.b64decode(open('../email.py.cred').readline()).decode("utf-8"))


class Core:
    testUrl = 'https://google.com'

    def isConnected(self) -> bool:
        print("Checking Internet Connection")
        status = True
        while status:
            try:
                urllib.request.urlopen(self.testUrl)  # Python 3.x
                print("Internet is connected")
                status = False
                return True
            except:
                print("No Internet Connection !")
                return False

    @staticmethod
    def getNgrok() -> json:
        status = True
        while status:
            url = 'http://localhost:4040/api/tunnels'
            jsonRes = json.loads(requests.get(url).text)
            if jsonRes['tunnels'][0]['public_url'].__contains__('ngrok'):
                status = False
                return jsonRes
            else:
                time.sleep(100)

    @staticmethod
    def __get_ip_addresses(family):
        for interface, snics in psutil.net_if_addrs().items():
            for snic in snics:
                if snic.family == family:
                    yield (snic.address)

    def checkVpnIP(self):
        ipv4s: list[str] = list(self.__get_ip_addresses(socket.AF_INET))
        for ip in ipv4s:
            if ip.__contains__('10.0.0'):
                return ip
            else:
                return None


class Postman:
    def __init__(self, ngrokPort, status):
        self.ngrokPort = ngrokPort['tunnels'][0]['public_url']
        self.protocol = ngrokPort['tunnels'][0]['proto']
        self.pcName = gethostname()
        self.status = status

    def sendDiscord(self):
        data = {'content': '[ ' + self.pcName + ' | ' + self.status + ' ] ' + self.ngrokPort}
        requests.post(Config().discordWebHookUrl, data)
        return self

    def sendWebServer(self, vpnIp=None):
        data = {
            'ngrok': self.ngrokPort,
            'protocol': self.protocol,
            'pcName': self.pcName + 'TEST',
            'email': Config().To,
        }
        if vpnIp is not None:
            data['vpnIP'] = vpnIp

        requests.post(Config().webServerUrl, data)
        return self

    def sendEmail(self):
        context = ssl.create_default_context()

        with smtplib.SMTP_SSL(Config().SMTPServer, Config().SMTPPort) as server:
            server.starttls(context=context)
            server.login(Config().From, Config().getPassword())
            server.sendmail(Config().From, Config().To,
                            """
                            <html>
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
</html>""")
            server.close()
        return self
